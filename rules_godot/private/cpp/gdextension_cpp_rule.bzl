load(":private/gdextension/gdextension_rule.bzl", "gdextension_rule")

def godot_gdextension_cpp(*args, **kwargs):
    native.cc_library(
        name = "cc_library",
        srcs = kwargs.get("srcs"),
        hdrs = kwargs.get("hdrs"),
        deps = kwargs.get("deps", default = []) + ["@godot_cpp"],
        include_prefix = "include",
        visibility = ["//visibility:private"],
    )

    native.cc_shared_library(
        name = "cc_shared_library",
        deps = [":cc_library"],
    )

    gdextension_rule(
        name = kwargs.get("name"),
        lib = ":cc_shared_library",
        shared_library_filename = "libcc_shared_library",
        entry_symbol = kwargs.get("entry_symbol"),
        deps = [],  # TODO handle deps
    )
