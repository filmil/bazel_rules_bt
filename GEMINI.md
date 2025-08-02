# Instructions

Firstly, read README.md to understand how to build and what the purpose of
things is.

Never auto-modify the following files:
* //tools/bazel
* Any dotfile.
* Any `*.lock` files.
* Any `*.nix` files.

Unless otherwise instructed, only apply maintenance tasks to files in the git
index, or uncommitted files, to avoid redoing work on files that are already
committed to git.

## General change rules

Do not change files in `//third_party` without user's explicit permission.

## General git commit rules

Any git commit created by Gemini must contain this note as the last line in the
commit message in addition to any commit summaries added:

```
This commit has been created by an automated coding assistant,
with human supervision.
```

## Documentation

Use Doxygen rules for documenting.

Whenever you add Doxygen documentation, also add the source filegroup targets ,
or source files where filegroups are unavailable, to the `srcs` attribute of
the `doxygen` target named "//:docs", so that doxygen docs could be updated
too. Include all VHDL files, but also C headers, and any other program source
files which contain documentation.

Do not run buildifier, as it will mess up the VHDL file ordering.

When updating documentation run `bazel build //:docs` to verify that it is
correct.

## License maintenance

When maintaining the license files do not modify the following:

* Files matching `*.gtkw`.
* Files under the directory `//third_party`.
* Any files with filenames beginning with a dot.

For all source files and all BUILD files, verify that they have a license
reference at the beginning of the file.

If a file does not have a license reference, add the following text in the
header, appropriately enclosed in comments that are appropriate for the
source file type in question:

```
LICENSE sha256: c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4
```

## `//third_party` maintenance

Every subdir under `//third_party` must have a LICENSE file with the appropriate
license copied from its source distribution.

## Public API documentation maintenance

Ensure that the repository is clean before starting this procedure.

For all source files, we want to maintain an up-to-date documentation of their
respective public API.

# Publish to Bazel central registry

Ensure that the repository is clean without uncommitted changes and with an
empty index.

In file `MODULE.bazel` increment the `version` SemVer parameter value in the
`module` statement as follows:

* Note the current value of the parameter `version` in statement `module` in the
  file `MODULE.bazel.`

    * If the short descriptions of the git changes from since the commit tag equal
      to the current value of `version` contains a prefix `BREAKING:`, increment
      the major SemVer version number, set minor and patch both to zero.
    * Otherwise if in the same range of commits there are `feat:` descriptions,
      increment the minor version number and set patch to zero.
    * Otherwise increment the patch version number only.

* Modify parameter `version` in the statement `module` in file MODULE.bazel` to
  the newly computed version number.

* Create a commit for this change. If able use the `gh` command line utility
  to create a pull request.

* Tag this commit with the value of `version` previously computed. Push that tag
  to the remote repository.

