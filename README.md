[![Bazel CI](https://github.com/filmil/bazel_rules_bt/actions/workflows/main.yml/badge.svg)](https://github.com/filmil/bazel_rules_bt/actions/workflows/main.yml)
[![Publish on Bazel Central Registry](https://github.com/filmil/bazel_rules_bt/actions/workflows/publish-bcr.yml/badge.svg)](https://github.com/filmil/bazel_rules_bt/actions/workflows/publish-bcr.yml)
[![Publish to my Bazel registry](https://github.com/filmil/bazel_rules_bt/actions/workflows/publish.yml/badge.svg)](https://github.com/filmil/bazel_rules_bt/actions/workflows/publish.yml)
[![Tag and Release](https://github.com/filmil/bazel_rules_bt/actions/workflows/tag-and-release.yml/badge.svg)](https://github.com/filmil/bazel_rules_bt/actions/workflows/tag-and-release.yml)

# rules_bittorrent

Bazel rules for downloading files using the BitTorrent protocol.

These rules use [rules_multitool](https://github.com/filmil/rules_multitool) and its embedded `rain` torrent client to download files from torrents.

## Setup

To use `rules_bittorrent`, add the following to your `MODULE.bazel` file:

```starlark
bazel_dep(name = "rules_bittorrent", version = "0.0.0") # Replace with the actual version
```

Then import the rules in the same `MODULE.bazel` file, with
`use_repo_rule`:

```starlark
bittorrent_file = use_repo_rule("@rules_bittorrent//:repo.bzl", "bittorrent_file")
```

This module used to be named `rules_bt`.
Versions from 2.0.0 on are published as `rules_bittorrent`.
To migrate, change the module name in `bazel_dep` and in every `load` or
`use_repo_rule` label.

The rules used to be named `bt_file` and `bt_archive`.
They are now `bittorrent_file` and `bittorrent_archive`.
The old names still work: `repo.bzl` exports them as aliases of the new
rules, so existing `use_repo_rule` calls need no change.
New code should use the new names.

## Supported platforms

The rules run the [rain](https://github.com/cenkalti/rain) torrent client on
the host.
rain publishes binaries for these hosts:

* Linux x86_64.
* macOS x86_64.
* macOS arm64. rain has no native arm64 build for macOS, so the x86_64
  binary runs under Rosetta 2.

Other hosts fail with an error that lists the supported platforms.

## Usage

Use `bittorrent_file` to download a single file from a torrent, and
`bittorrent_archive` to download an archive and extract it.

### `bittorrent_file`

In your `MODULE.bazel`:

```starlark
bittorrent_file = use_repo_rule("@rules_bittorrent//:repo.bzl", "bittorrent_file")

bittorrent_file(
    name = "my_file",
    uri = "magnet:?xt=urn:btih:...", # Or a URL to a .torrent file
    integrity = "...",
)
```

This will download the file from the torrent and make it available as `@my_file//:file`.

### `bittorrent_archive`

In your `MODULE.bazel`:

```starlark
bittorrent_archive = use_repo_rule("@rules_bittorrent//:repo.bzl", "bittorrent_archive")

bittorrent_archive(
    name = "my_archive",
    uri = "magnet:?xt=urn:btih:...", # Or a URL to a .torrent file
    integrity = "...",
    strip_prefix = "my_archive-1.0",
    build_file_content = """
filegroup(
    name = "my_archive_files",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
""",
)
```

This will download the archive file from the torrent, extract it, and make its contents available as `@my_archive//:my_archive_files`.

## API

### `bittorrent_file`

A repository rule to download a file from a torrent.
`bt_file` is an alias of this rule.

**Attributes**

| Name        | Description                                                                 | Type   | Mandatory | Default |
|-------------|-----------------------------------------------------------------------------|--------|-----------|---------|
| `name`      | A unique name for this repository.                                          | String | Yes       |         |
| `uri`       | The magnet link or URL to the `.torrent` file, or `@@//:some_file.torrent` to refer to a torrent file present locally.                              | String | Yes       |         |
| `integrity` | The integrity signature of the downloaded file.                             | String | Yes       |         |
| `file`      | The name of the file to extract from the torrent. If not specified, it is assumed to be the same as `name`. | String | No        | `name`  |
| `timeout`   | The timeout in seconds for the download.                                    | Integer| No        | `200000`|
| `quiet`     | Whether to omit printing download progress.                                 | Boolean| No        | `True`  |

### `bittorrent_archive`

A repository rule to download and extract an archive file from a torrent.
`bt_archive` is an alias of this rule.

**Attributes**

| Name                 | Description                                                                 | Type   | Mandatory | Default |
|----------------------|-----------------------------------------------------------------------------|--------|-----------|---------|
| `name`               | A unique name for this repository.                                          | String | Yes       |         |
| `uri`                | The magnet link or URL to the `.torrent` file, or `@@//:some_file.torrent` to refer to a torrent file present locally.                              | String | Yes       |         |
| `integrity`          | The integrity signature of the downloaded file.                             | String | Yes       |         |
| `file`               | The name of the file to extract from the torrent. If not specified, it is assumed to be the same as `name`. | String | No        | `name`  |
| `timeout`            | The timeout in seconds for the download.                                    | Integer| No        | `200000`|
| `quiet`              | Whether to omit printing download progress.                                 | Boolean| No        | `True`  |
| `strip_prefix`       | The prefix (directory) within the archive to strip away.                    | String | No        | `''`    |
| `build_file_content` | The content of the build file to place in the repo.                         | String | Yes       |         |
| `extract`            | Whether to extract the downloaded torrent.                                  | Boolean| No        | `True`  |

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

## API documentation

The generated reference for every rule in `repo.bzl` is in
[docs/repo.md](docs/repo.md).
It is produced by Stardoc and checked into the tree, so that the rendered
reference is reviewable in a diff alongside the change that alters a rule.

Regenerate it after editing `repo.bzl`:

```console
bazel run //:docs
```

`bazel test //...` runs `//:docs_test`, which fails when `docs/repo.md` no
longer matches `repo.bzl`.

The same documentation is published to the registry. Each release attaches a
`bazel_rules_bt-<tag>.docs.tar.gz` archive of the `starlark_doc_extract`
output, and `.bcr/source.template.json` points the registry entry at it
through `docs_url`, which is what renders the API reference on
[registry.bazel.build](https://registry.bazel.build).
