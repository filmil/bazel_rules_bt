<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="bittorrent_archive"></a>

## bittorrent_archive

<pre>
load("@rules_bittorrent//:repo.bzl", "bittorrent_archive")

bittorrent_archive(<a href="#bittorrent_archive-name">name</a>, <a href="#bittorrent_archive-attempt_timeout">attempt_timeout</a>, <a href="#bittorrent_archive-build_file_content">build_file_content</a>, <a href="#bittorrent_archive-extract">extract</a>, <a href="#bittorrent_archive-file">file</a>, <a href="#bittorrent_archive-integrity">integrity</a>, <a href="#bittorrent_archive-quiet">quiet</a>,
                   <a href="#bittorrent_archive-strip_prefix">strip_prefix</a>, <a href="#bittorrent_archive-timeout">timeout</a>, <a href="#bittorrent_archive-uri">uri</a>)
</pre>

Downloads an archive from a torrent, and extracts it.

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
    build_file_content = """
filegroup(
    name = "files",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
""",
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="bittorrent_archive-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="bittorrent_archive-attempt_timeout"></a>attempt_timeout |  How long, in seconds, one run of rain may take.<br><br>rain sometimes never exits after it has downloaded the whole file (https://github.com/filmil/bazel_rules_bt/issues/49). So rain runs for at most this long at a time, and after each run the file is checked against `integrity`:<br><br>* a matching file ends the fetch, whether or not rain exited; * if rain exited, or the file did not change over a whole run (rain is   done or stuck), the fetch fails, and a file that differs from   `integrity` is reported with both hashes; * otherwise rain runs again and resumes where it stopped.<br><br>`timeout` bounds the sum of the runs' limits; the checks between runs come on top. A fetch that runs out of `timeout` keeps rain's resume file, so the next fetch resumes.   | Integer | optional |  `120`  |
| <a id="bittorrent_archive-build_file_content"></a>build_file_content |  The content of the build file to place in the repo   | String | required |  |
| <a id="bittorrent_archive-extract"></a>extract |  Whether to extract the downloaded torrent (torrent with multiple files may not need this)   | Boolean | optional |  `True`  |
| <a id="bittorrent_archive-file"></a>file |  The name of the file to use for the downloaded file.   | String | optional |  `""`  |
| <a id="bittorrent_archive-integrity"></a>integrity |  The expected hash of the downloaded file, in Subresource Integrity form: `sha256-` followed by the base64 of the SHA-256 digest (`sha384-` and `sha512-` also work).<br><br>The fetch fails if the file rain downloads does not have this hash, and the error shows both values. To get the value for a new file, set any well-formed wrong value, for example `sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=`, and copy the hash the error reports.   | String | required |  |
| <a id="bittorrent_archive-quiet"></a>quiet |  Whether to omit printing download progress   | Boolean | optional |  `True`  |
| <a id="bittorrent_archive-strip_prefix"></a>strip_prefix |  The prefix (directory) within the archive to strip away   | String | optional |  `""`  |
| <a id="bittorrent_archive-timeout"></a>timeout |  The timeout in seconds for the download, over all its attempts.   | Integer | optional |  `200000`  |
| <a id="bittorrent_archive-uri"></a>uri |  The torrent URI to download the file from.   | String | required |  |


<a id="bittorrent_file"></a>

## bittorrent_file

<pre>
load("@rules_bittorrent//:repo.bzl", "bittorrent_file")

bittorrent_file(<a href="#bittorrent_file-name">name</a>, <a href="#bittorrent_file-attempt_timeout">attempt_timeout</a>, <a href="#bittorrent_file-file">file</a>, <a href="#bittorrent_file-integrity">integrity</a>, <a href="#bittorrent_file-quiet">quiet</a>, <a href="#bittorrent_file-timeout">timeout</a>, <a href="#bittorrent_file-uri">uri</a>)
</pre>

Downloads a single file from a torrent.

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="bittorrent_file-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="bittorrent_file-attempt_timeout"></a>attempt_timeout |  How long, in seconds, one run of rain may take.<br><br>rain sometimes never exits after it has downloaded the whole file (https://github.com/filmil/bazel_rules_bt/issues/49). So rain runs for at most this long at a time, and after each run the file is checked against `integrity`:<br><br>* a matching file ends the fetch, whether or not rain exited; * if rain exited, or the file did not change over a whole run (rain is   done or stuck), the fetch fails, and a file that differs from   `integrity` is reported with both hashes; * otherwise rain runs again and resumes where it stopped.<br><br>`timeout` bounds the sum of the runs' limits; the checks between runs come on top. A fetch that runs out of `timeout` keeps rain's resume file, so the next fetch resumes.   | Integer | optional |  `120`  |
| <a id="bittorrent_file-file"></a>file |  The name of the file to use for the downloaded file.   | String | optional |  `""`  |
| <a id="bittorrent_file-integrity"></a>integrity |  The expected hash of the downloaded file, in Subresource Integrity form: `sha256-` followed by the base64 of the SHA-256 digest (`sha384-` and `sha512-` also work).<br><br>The fetch fails if the file rain downloads does not have this hash, and the error shows both values. To get the value for a new file, set any well-formed wrong value, for example `sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=`, and copy the hash the error reports.   | String | required |  |
| <a id="bittorrent_file-quiet"></a>quiet |  Whether to omit printing download progress   | Boolean | optional |  `True`  |
| <a id="bittorrent_file-timeout"></a>timeout |  The timeout in seconds for the download, over all its attempts.   | Integer | optional |  `200000`  |
| <a id="bittorrent_file-uri"></a>uri |  The torrent URI to download the file from.   | String | required |  |


