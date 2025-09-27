[![Bazel CI](https://github.com/filmil/rules_bt/actions/workflows/main.yml/badge.svg)](https://github.com/filmil/bazel_rules_bt/actions/workflows/main.yml)

# rules_bt

Bazel rules for downloading files using the BitTorrent protocol.

These rules use [rules_multitool](https://github.com/filmil/rules_multitool) and its embedded `rain` torrent client to download files from torrents.

## Setup

To use `rules_bt`, add the following to your `MODULE.bazel` file:

```starlark
bazel_dep(name = "rules_bt", version = "0.0.0") # Replace with the actual version
```

And then load the rules in your `repo.bzl` file:

```starlark
load("@rules_bt//:repo.bzl", "bt_file")
```

## Usage

You can use the `bt_file` rule to download a single file from a torrent.

### `bt_file`

In your `MODULE.bazel`:

```starlark
load("@rules_bt//:repo.bzl", "bt_file")

bt_file(
    name = "my_file",
    uri = "magnet:?xt=urn:btih:...", # Or a URL to a .torrent file
)
```

This will download the file from the torrent and make it available as `@my_file//:file`.

### `bt_archive`

In your `MODULE.bazel`:

```starlark
load("@rules_bt//:repo.bzl", "bt_archive")

bt_archive(
    name = "my_archive",
    uri = "magnet:?xt=urn:btih:...", # Or a URL to a .torrent file
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

### `bt_file`

A repository rule to download a file from a torrent.

**Attributes**

| Name      | Description                                                                 | Type   | Mandatory | Default |
|-----------|-----------------------------------------------------------------------------|--------|-----------|---------|
| `name`    | A unique name for this repository.                                          | String | Yes       |         |
| `uri`     | The magnet link or URL to the `.torrent` file, or `@@//:some_file.torrent` to refer to a torrent file present locally.                              | String | Yes       |         |
| `file`    | The name of the file to extract from the torrent. If not specified, it is assumed to be the same as `name`. | String | No        | `name`  |
| `timeout` | The timeout in seconds for the download.                                    | Integer| No        | `20000`|

### `bt_archive`

A repository rule to download and extract an archive file from a torrent.

**Attributes**

| Name                 | Description                                                                 | Type   | Mandatory | Default |
|----------------------|-----------------------------------------------------------------------------|--------|-----------|---------|
| `name`               | A unique name for this repository.                                          | String | Yes       |         |
| `uri`                | The magnet link or URL to the `.torrent` file, or `@@//:some_file.torrent` to refer to a torrent file present locally.                              | String | Yes       |         |
| `file`               | The name of the file to extract from the torrent. If not specified, it is assumed to be the same as `name`. | String | No        | `name`  |
| `timeout`            | The timeout in seconds for the download.                                    | Integer| No        | `20000`|
| `strip_prefix`       | The prefix (directory) within the archive to strip away.                    | String | No        | `''`    |
| `build_file_content` | The content of the build file to place in the repo.                         | String | Yes       |         |
| `extract`            | Whether to extract the downloaded torrent.                                  | Boolean| No        | `True`  |

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.
