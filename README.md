# bazel_rules_bt

Bazel rules for downloading files using the BitTorrent protocol.

These rules use [rules_multitool](https://github.com/filmil/rules_multitool) and its embedded `rain` torrent client to download files from torrents.

## Setup

To use `bazel_rules_bt`, add the following to your `MODULE.bazel` file:

```starlark
bazel_dep(name = "bazel_rules_bt", version = "0.0.0") # Replace with the actual version
```

And then load the rules in your `repo.bzl` file:

```starlark
load("@bazel_rules_bt//:repo.bzl", "bt_file", "bt_files")
```

## Usage

You can use the `bt_file` rule to download a single file from a torrent.

### `bt_file`

In your `MODULE.bazel` or `WORKSPACE` file:

```starlark
load("@bazel_rules_bt//:repo.bzl", "bt_file")

bt_file(
    name = "my_file",
    uri = "magnet:?xt=urn:btih:...", # Or a URL to a .torrent file
)
```

This will download the file from the torrent and make it available as `@my_file//:file`.

### `bt_files`

If a torrent contains multiple files, you can use the `bt_files` macro to download them.

```starlark
load("@bazel_rules_bt//:repo.bzl", "bt_files")

bt_files(
    name = "my_files",
    torrent = "magnet:?xt=urn:btih:...", # Or a URL to a .torrent file
    files = [
        "file1.txt",
        "path/to/file2.iso",
    ],
)
```

This will create a repository for each file, named `my_files_file1.txt` and `my_files_path_to_file2.iso`.

## API

### `bt_file`

A repository rule to download a file from a torrent.

**Attributes**

| Name      | Description                                                                 | Type   | Mandatory | Default |
|-----------|-----------------------------------------------------------------------------|--------|-----------|---------|
| `name`    | A unique name for this repository.                                          | String | Yes       |         |
| `uri`     | The magnet link or URL to the `.torrent` file.                              | String | Yes       |         |
| `file`    | The name of the file to extract from the torrent. If not specified, it is assumed to be the same as `name`. | String | No        | `name`  |
| `timeout` | The timeout in seconds for the download.                                    | Integer| No        | `200000`|

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.