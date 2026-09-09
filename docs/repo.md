<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="bt_archive"></a>

## bt_archive

<pre>
load("@rules_bt//:repo.bzl", "bt_archive")

bt_archive(<a href="#bt_archive-name">name</a>, <a href="#bt_archive-build_file_content">build_file_content</a>, <a href="#bt_archive-extract">extract</a>, <a href="#bt_archive-file">file</a>, <a href="#bt_archive-integrity">integrity</a>, <a href="#bt_archive-quiet">quiet</a>, <a href="#bt_archive-repo_mapping">repo_mapping</a>, <a href="#bt_archive-strip_prefix">strip_prefix</a>,
           <a href="#bt_archive-timeout">timeout</a>, <a href="#bt_archive-uri">uri</a>)
</pre>

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="bt_archive-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="bt_archive-build_file_content"></a>build_file_content |  The content of the build file to place in the repo   | String | required |  |
| <a id="bt_archive-extract"></a>extract |  Whether to extract the downloaded torrent (torrent with multiple files may not need this)   | Boolean | optional |  `True`  |
| <a id="bt_archive-file"></a>file |  The name of the file to use for the downloaded file.   | String | optional |  `""`  |
| <a id="bt_archive-integrity"></a>integrity |  The integrity signature of this file   | String | required |  |
| <a id="bt_archive-quiet"></a>quiet |  Whether to omit printing download progress   | Boolean | optional |  `True`  |
| <a id="bt_archive-repo_mapping"></a>repo_mapping |  In `WORKSPACE` context only: a dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.<br><br>For example, an entry `"@foo": "@bar"` declares that, for any time this repository depends on `@foo` (such as a dependency on `@foo//some:target`, it should actually resolve that dependency within globally-declared `@bar` (`@bar//some:target`).<br><br>This attribute is _not_ supported in `MODULE.bazel` context (when invoking a repository rule inside a module extension's implementation function).   | <a href="https://bazel.build/rules/lib/core/dict">Dictionary: String -> String</a> | optional |  |
| <a id="bt_archive-strip_prefix"></a>strip_prefix |  The prefix (directory) within the archive to strip away   | String | optional |  `""`  |
| <a id="bt_archive-timeout"></a>timeout |  The timeout in seconds for the download.   | Integer | optional |  `200000`  |
| <a id="bt_archive-uri"></a>uri |  The torrent URI to download the file from.   | String | required |  |


<a id="bt_file"></a>

## bt_file

<pre>
load("@rules_bt//:repo.bzl", "bt_file")

bt_file(<a href="#bt_file-name">name</a>, <a href="#bt_file-file">file</a>, <a href="#bt_file-integrity">integrity</a>, <a href="#bt_file-quiet">quiet</a>, <a href="#bt_file-repo_mapping">repo_mapping</a>, <a href="#bt_file-timeout">timeout</a>, <a href="#bt_file-uri">uri</a>)
</pre>

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="bt_file-name"></a>name |  A unique name for this repository.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="bt_file-file"></a>file |  The name of the file to use for the downloaded file.   | String | optional |  `""`  |
| <a id="bt_file-integrity"></a>integrity |  The integrity signature of this file   | String | required |  |
| <a id="bt_file-quiet"></a>quiet |  Whether to omit printing download progress   | Boolean | optional |  `True`  |
| <a id="bt_file-repo_mapping"></a>repo_mapping |  In `WORKSPACE` context only: a dictionary from local repository name to global repository name. This allows controls over workspace dependency resolution for dependencies of this repository.<br><br>For example, an entry `"@foo": "@bar"` declares that, for any time this repository depends on `@foo` (such as a dependency on `@foo//some:target`, it should actually resolve that dependency within globally-declared `@bar` (`@bar//some:target`).<br><br>This attribute is _not_ supported in `MODULE.bazel` context (when invoking a repository rule inside a module extension's implementation function).   | <a href="https://bazel.build/rules/lib/core/dict">Dictionary: String -> String</a> | optional |  |
| <a id="bt_file-timeout"></a>timeout |  The timeout in seconds for the download.   | Integer | optional |  `200000`  |
| <a id="bt_file-uri"></a>uri |  The torrent URI to download the file from.   | String | required |  |


