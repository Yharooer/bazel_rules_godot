load("//rules_godot:rules.bzl", "godot_gdextension_cpp")

package(default_visibility = ["//visibility:public"])

godot_gdextension_cpp(
    name = "character_cpp_gdext",
    srcs = glob(["src/**/*.cpp"]),
    hdrs = glob(["src/**/*.h"]),
    entry_symbol = "example_library_init",
)
