load("//godot_rules:godot_rules.bzl", "godot_lib")

package(default_visibility = ["//visibility:public"])

godot_lib(
    name = "character_common",
    srcs = glob(
        ["**/*"],
        exclude = ["project.godot"],
    ),
)
