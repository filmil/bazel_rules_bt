_CPU_TO_ARCH = {
    "amd64": "x86_64",
}


def _get_tool_label(ctx):
    """Obtains the label of the multitool binary target to use for downloading
    the files.

    This performs a function similar to toolchain resolution in ordinary rules.
    Except repo rules don't have this API, so we have to make do.

    """
    arch = _CPU_TO_ARCH[ctx.os.arch]
    os = ctx.os.name
    tool_label = Label(
        "".join([
            "@@rules_multitool++multitool+multitool.rain.{os}_{arch}",
            "//tools/rain:{os}_{arch}_executable"]).format(os=os,arch=arch))
    return tool_label



def _bt_file_impl(ctx):
    uri = ctx.attr.uri
    tool_path = str(ctx.path(_get_tool_label(ctx)))
    filename = ctx.attr.file or ctx.attr.name
    args = [
        tool_path, "download",
        "--torrent", uri,
        "--resume", "/tmp/_bazel.{}.resume".format(ctx.attr.name)]
    result = ctx.execute(args, quiet = False, timeout = ctx.attr.timeout)

    ctx.file(
        "BUILD.bazel",
        """#
exports_files([
    "{name}",
])
""".format(name=filename),
    )


bt_file = repository_rule(
    implementation = _bt_file_impl,
    attrs = {
        "uri": attr.string(mandatory=True),
        "timeout": attr.int(default=200000),
        "file": attr.string(),
    },
)
