load("@rules_rust//rust:defs.bzl", "rust_library", "rust_shared_library")
load(":private/gdextension/gdextension_rule.bzl", "gdextension_rule")

def godot_gdextension_rust(*args, **kwargs):
    rust_shared_library(
        name = "rust_shared_library",
        srcs = kwargs.get("srcs"),
        deps = kwargs.get("deps", default = []) + ["@crates//:godot"],
        visibility = ["//visibility:public"],
    )

    gdextension_rule(
        name = kwargs.get("name"),
        lib = ":rust_shared_library",
        shared_library_filename = "librust_shared_library",
        entry_symbol = "gdext_rust_init",
        deps = [],  # TODO handle deps
    )
