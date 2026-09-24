<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="bittorrent_archive"></a>

## bittorrent_archive

<pre>
load("@rules_bittorrent//:repo.bzl", "bittorrent_archive")

bittorrent_archive(<a href="#bittorrent_archive-name">name</a>, <a href="#bittorrent_archive-build_file_content">build_file_content</a>, <a href="#bittorrent_archive-extract">extract</a>, <a href="#bittorrent_archive-file">file</a>, <a href="#bittorrent_archive-integrity">integrity</a>, <a href="#bittorrent_archive-quiet">quiet</a>, <a href="#bittorrent_archive-repo_mapping">repo_mapping</a>,
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
| <a id="bittorrent_archive-build_file_content"></a>build_file_content |  The content of the build file to place in the repo   | String | required |  |
| <a id="bittorrent_archive-extract"></a>extract |  Whether to extract the downloaded torrent (torrent with multiple files may not need this)   | Boolean | optional |  `True`  |
| <a id="bittorrent_archive-file"></a>file |  The name of the file to use for the downloaded file.   | String | optional |  `""`  |
| <a id="bittorrent_archive-integrity"></a>integrity |  The integrity signature of this file   | String | required |  |
| <a id="bittorrent_archive-quiet"></a>quiet |  Whether to omit printing download progress   | Boolean | optional |  `True`  |
| <a id="bittorrent_archive-repo_mapping"></a>repo_mapping |  In `WORKSPACE` context only: a dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.<br><br>For example, an entry `"@foo": "@bar"` declares that, for any time this repository depends on `@foo` (such as a dependency on `@foo//some:target`, it should actually resolve that dependency within globally-declared `@bar` (`@bar//some:target`).<br><br>This attribute is _not_ supported in `MODULE.bazel` context (when invoking a repository rule inside a module extension's implementation function).   | <a href="https://bazel.build/rules/lib/core/dict">Dictionary: String -> String</a> | optional |  |
| <a id="bittorrent_archive-strip_prefix"></a>strip_prefix |  The prefix (directory) within the archive to strip away   | String | optional |  `""`  |
| <a id="bittorrent_archive-timeout"></a>timeout |  The timeout in seconds for the download.   | Integer | optional |  `200000`  |
| <a id="bittorrent_archive-uri"></a>uri |  The torrent URI to download the file from.   | String | required |  |


<a id="bittorrent_file"></a>

## bittorrent_file

<pre>
load("@rules_bittorrent//:repo.bzl", "bittorrent_file")

bittorrent_file(<a href="#bittorrent_file-name">name</a>, <a href="#bittorrent_file-file">file</a>, <a href="#bittorrent_file-integrity">integrity</a>, <a href="#bittorrent_file-quiet">quiet</a>, <a href="#bittorrent_file-repo_mapping">repo_mapping</a>, <a href="#bittorrent_file-timeout">timeout</a>, <a href="#bittorrent_file-uri">uri</a>)
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
| <a id="bittorrent_file-file"></a>file |  The name of the file to use for the downloaded file.   | String | optional |  `""`  |
| <a id="bittorrent_file-integrity"></a>integrity |  The integrity signature of this file   | String | required |  |
| <a id="bittorrent_file-quiet"></a>quiet |  Whether to omit printing download progress   | Boolean | optional |  `True`  |
| <a id="bittorrent_file-repo_mapping"></a>repo_mapping |  In `WORKSPACE` context only: a dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.<br><br>For example, an entry `"@foo": "@bar"` declares that, for any time this repository depends on `@foo` (such as a dependency on `@foo//some:target`, it should actually resolve that dependency within globally-declared `@bar` (`@bar//some:target`).<br><br>This attribute is _not_ supported in `MODULE.bazel` context (when invoking a repository rule inside a module extension's implementation function).   | <a href="https://bazel.build/rules/lib/core/dict">Dictionary: String -> String</a> | optional |  |
| <a id="bittorrent_file-timeout"></a>timeout |  The timeout in seconds for the download.   | Integer | optional |  `200000`  |
| <a id="bittorrent_file-uri"></a>uri |  The torrent URI to download the file from.   | String | required |  |


