load("//rules_godot:rules.bzl", "godot_lib")

package(default_visibility = ["//visibility:public"])

godot_lib(
    name = "character_gdscript",
    srcs = glob(
        ["**/*"],
        exclude = ["project.godot"],
    ),
    deps = ["//character_common"],
)
