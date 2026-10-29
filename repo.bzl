# Maps the values of repository_ctx.os.name and repository_ctx.os.arch to the
# os and cpu names used in multitool.lock.json.
_OS_NAMES = {
    "linux": "linux",
    "mac os x": "macos",
}

_CPU_NAMES = {
    "aarch64": "arm64",
    "amd64": "x86_64",
    "arm64": "arm64",
    "x86_64": "x86_64",
}

# The rain binary for each supported "{os}_{cpu}" pair. The repos are imported
# under these names by use_repo in MODULE.bazel.
#
# rain publishes one macOS binary, built for x86_64. On arm64 macOS it runs
# under Rosetta 2.
_TOOL_REPOS = {
    "linux_x86_64": Label("@rain_linux_x86_64//tools/rain:linux_x86_64_executable"),
    "macos_arm64": Label("@rain_macos_arm64//tools/rain:macos_arm64_executable"),
    "macos_x86_64": Label("@rain_macos_x86_64//tools/rain:macos_x86_64_executable"),
}


_COMMON_ATTRS = {
        "timeout": attr.int(
            doc = "The timeout in seconds for the download, over all its attempts.",
            default = 200000,
        ),
        "attempt_timeout": attr.int(
            doc = """How long, in seconds, one run of rain may take.

rain sometimes never exits after it has downloaded the whole file
(https://github.com/filmil/bazel_rules_bt/issues/49). So rain runs for at
most this long at a time. After each run the file is checked against
`integrity`; a complete file ends the fetch, whether or not rain exited.
Otherwise rain runs again and resumes where it stopped, until `timeout`
is used up.""",
            default = 120,
        ),
        "integrity": attr.string(
            doc = """The expected hash of the downloaded file, in Subresource Integrity form: `sha256-` followed by the base64 of the SHA-256 digest (`sha384-` and `sha512-` also work).

The fetch fails if the file rain downloads does not have this hash, and the error shows both values. To get the value for a new file, set any well-formed wrong value, for example `sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=`, and copy the hash the error reports.""",
            mandatory = True,
        ),
        "quiet": attr.bool(
            default = True,
            doc = "Whether to omit printing download progress",
        ),
        "file": attr.string(
            doc = "The name of the file to use for the downloaded file.",
        ),
}


def _get_tool_label(ctx):
    """Obtains the label of the multitool binary target to use for downloading
    the files.

    This performs a function similar to toolchain resolution in ordinary rules.
    Except repo rules don't have this API, so we have to make do.

    Fails with a readable message on a host that has no rain binary.
    """
    platform = "{}_{}".format(
        _OS_NAMES.get(ctx.os.name, ctx.os.name),
        _CPU_NAMES.get(ctx.os.arch, ctx.os.arch),
    )
    if platform not in _TOOL_REPOS:
        fail("rules_bittorrent: no rain binary for host {} (os.name={}, os.arch={}). Supported: {}".format(
            platform,
            ctx.os.name,
            ctx.os.arch,
            ", ".join(sorted(_TOOL_REPOS.keys())),
        ))
    return _TOOL_REPOS[platform]


def _bittorrent_common(ctx):
    quiet = ctx.attr.quiet
    uri = ctx.attr.uri
    if uri.startswith("@@//:"):
        uri = "/".join([str(ctx.workspace_root), uri[5:]])
    tool_path = str(ctx.path(_get_tool_label(ctx)))
    filename = ctx.attr.file or ctx.attr.name
    integrity = ctx.attr.integrity
    if not integrity.startswith(("sha256-", "sha384-", "sha512-")):
        fail("rules_bittorrent: {}: integrity must be a Subresource Integrity hash such as sha256-<base64>, got {}".format(
            ctx.attr.name,
            repr(integrity),
        ))
    # rain listens on port 7246 for both RPC and DHT by default. Bazel fetches
    # repositories in parallel, so two rain processes started with the
    # defaults collide on that port. The download command does not need RPC,
    # and port 0 lets the OS pick a free DHT port.
    ctx.file("config.yaml", """#
resume-on-startup: true
dht-enabled: true
dht-port: 0
rpc-enabled: false
""")
    # The resume file resume_file_path
    resume_file_path = "/tmp/_bazel.{}.resume".format(ctx.attr.name)
    # rain writes into its working directory. It downloads into a directory
    # of its own, so that only the copy checked below becomes the
    # repository's file.
    download_dir = "_rain_download"
    ctx.file(download_dir + "/.keep", "")
    args = [
        tool_path, "download",
        "--config", str(ctx.path("config.yaml")),
        "--torrent", uri,
        "--resume", resume_file_path
    ]
    downloaded = ctx.path(download_dir + "/" + filename)
    if ctx.attr.attempt_timeout <= 0 or ctx.attr.timeout <= 0:
        fail("rules_bittorrent: {}: timeout and attempt_timeout must be positive".format(ctx.attr.name))
    left = ctx.attr.timeout
    result = None
    for _ in range(left // ctx.attr.attempt_timeout + 1):
        if left <= 0:
            break
        slice = min(ctx.attr.attempt_timeout, left)
        left -= slice
        result = ctx.execute(
            args,
            quiet = quiet,
            timeout = slice,
            working_directory = download_dir,
        )

        # Starlark cannot hash a file, but Bazel's own downloader checks
        # `integrity` for any URL, a file:// one included. A complete file
        # ends the fetch, even when rain did not exit (issue #49).
        if downloaded.exists and _complete(ctx, downloaded, filename, integrity):
            # Remove the resume file, so that a later download of the same
            # torrent starts afresh.
            # See: https://github.com/cenkalti/rain/issues/205
            ctx.delete(resume_file_path)
            ctx.delete(download_dir)
            return filename
        timed_out = result.return_code == _TIMED_OUT
        if not timed_out:
            break

    # rain is done or out of time, and the file is not right.
    ctx.delete(resume_file_path)
    if result.return_code == 0 and downloaded.exists:
        # rain says it finished: the file differs from `integrity`. Check it
        # again without allow_fail, so the error shows both hashes.
        ctx.download(
            url = "file://" + str(downloaded),
            output = filename,
            integrity = integrity,
        )
    if result.return_code == 0:
        fail("rules_bittorrent: {}: rain finished, but {} is not among the files it downloaded. Check `file`.".format(
            ctx.attr.name,
            filename,
        ))
    fail("rules_bittorrent: rain failed to download {} (exit code {}{}):\n{}\n{}".format(
        uri,
        result.return_code,
        ", out of time after {} s".format(ctx.attr.timeout) if result.return_code == _TIMED_OUT else "",
        result.stdout,
        result.stderr,
    ))

# The exit code repository_ctx.execute reports when the timeout killed the
# command (its stderr then says "Timed out").
_TIMED_OUT = 256

def _complete(ctx, downloaded, filename, integrity):
    """Copies the downloaded file into place if it matches integrity."""
    return ctx.download(
        url = "file://" + str(downloaded),
        output = filename,
        integrity = integrity,
        allow_fail = True,
    ).success


def _bittorrent_file_impl(ctx):
    filename = _bittorrent_common(ctx)
    ctx.file(
        "BUILD.bazel",
        """# Autogenerated, do not edit.

# @<repo_name>//:file
filegroup(
    name = "file",
    srcs = [
        "{name}",
    ],
)
exports_files([
    "{name}",
])
""".format(name=filename),
    )



bittorrent_file = repository_rule(
    implementation = _bittorrent_file_impl,
    doc = """Downloads a single file from a torrent.

The file is available as `@<name>//:file`, and is exported under its own
file name.

Example, in `MODULE.bazel`:

```starlark
bittorrent_file = use_repo_rule("@rules_bittorrent//:repo.bzl", "bittorrent_file")

bittorrent_file(
    name = "my_file",
    uri = "magnet:?xt=urn:btih:...",
    integrity = "...",
)
```
""",
    attrs = _COMMON_ATTRS | {
        "uri": attr.string(
            doc = "The torrent URI to download the file from.",
            mandatory = True,
        ),
    },
)


def _bittorrent_archive_impl(ctx):
    filename = _bittorrent_common(ctx)
    if ctx.attr.extract:
        ctx.extract(filename, strip_prefix=ctx.attr.strip_prefix)
    ctx.file("BUILD.bazel", ctx.attr.build_file_content.format(name=filename))


bittorrent_archive = repository_rule(
    implementation = _bittorrent_archive_impl,
    doc = """Downloads an archive from a torrent, and extracts it.

The repository gets a `BUILD.bazel` file with `build_file_content` as its
content. `{name}` in that content is replaced by the downloaded file name.

Example, in `MODULE.bazel`:

```starlark
bittorrent_archive = use_repo_rule("@rules_bittorrent//:repo.bzl", "bittorrent_archive")

bittorrent_archive(
    name = "my_archive",
    uri = "magnet:?xt=urn:btih:...",
    integrity = "...",
    strip_prefix = "my_archive-1.0",
    build_file_content = \"""
filegroup(
    name = "files",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
\""",
)
```
""",
    attrs = _COMMON_ATTRS | {
        "uri": attr.string(
            doc = "The torrent URI to download the file from.",
            mandatory = True,
        ),
        "build_file_content": attr.string(
            doc = "The content of the build file to place in the repo",
            mandatory = True,
        ),
        "strip_prefix": attr.string(
            doc = "The prefix (directory) within the archive to strip away",
            default = '',
        ),
        "extract": attr.bool(
            default = True,
            doc = "Whether to extract the downloaded torrent (torrent with multiple files may not need this)",
        ),
    },
)


# The names the rules had before the module was renamed from rules_bt to
# rules_bittorrent. They are the same rules, kept so that existing
# `use_repo_rule` calls keep working. New code uses the names above.
bt_file = bittorrent_file
bt_archive = bittorrent_archive
