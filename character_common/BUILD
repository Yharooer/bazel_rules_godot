load("//rules_godot:rules.bzl", "godot_lib")

package(default_visibility = ["//visibility:public"])

godot_lib(
    name = "character_common",
    srcs = glob(
        ["**/*"],
        exclude = ["project.godot"],
    ),
)
