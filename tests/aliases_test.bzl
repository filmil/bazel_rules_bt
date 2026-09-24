"""Checks that the old rule names still name the renamed rules."""

load("//:repo.bzl", "bittorrent_archive", "bittorrent_file", "bt_archive", "bt_file")

def _aliases_test_impl(ctx):
    script = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(script, "#!/bin/sh\nexit 0\n", is_executable = True)
    return [DefaultInfo(executable = script)]

_aliases_test = rule(
    implementation = _aliases_test_impl,
    test = True,
)

def aliases_test(name, **kwargs):
    """Fails the load of the calling package when an alias names another rule.

    The check runs while the package loads, so a broken alias fails
    `bazel test //...` before any test runs. The test itself only passes.

    Example:

    ```starlark
    load(":aliases_test.bzl", "aliases_test")

    aliases_test(name = "aliases_test")
    ```

    Args:
      name: The name of the test target.
      **kwargs: Passed to the test rule, for example `size` or `tags`.
    """
    if bt_file != bittorrent_file:
        fail("bt_file must be the same rule as bittorrent_file")
    if bt_archive != bittorrent_archive:
        fail("bt_archive must be the same rule as bittorrent_archive")
    _aliases_test(name = name, **kwargs)
