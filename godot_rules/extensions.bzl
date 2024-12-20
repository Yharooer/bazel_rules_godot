load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("//godot_rules:godot_cpp_rules.bzl", "godot_cpp_repo_rule")

def _godot_cpp_extension_impl(ctx):
    git_repository(
        name = "godot_cpp",
        remote = "https://github.com/godotengine/godot-cpp.git",
        branch = "master",
        build_file = "//godot_rules:godot_cpp_BUILD.bzl",
    )

_godot_cpp = tag_class(attrs = {"tag": attr.string(mandatory = True)})

rules_godot = module_extension(
    implementation = _godot_cpp_extension_impl,
    tag_classes = {
        "godot_cpp": _godot_cpp,
    },
)
