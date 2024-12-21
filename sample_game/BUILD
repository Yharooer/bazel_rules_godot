load("//rules_godot:rules.bzl", "godot_exec")

package(default_visibility = ["//visibility:public"])

godot_exec(
    name = "sample_game",
    srcs = glob(
        ["**/*"],
    ),
    deps = [
        "//character_cpp_gdext",
        "//character_gdscript",
    ],
)
