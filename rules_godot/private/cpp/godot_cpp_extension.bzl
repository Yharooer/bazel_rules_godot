load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

godot_cpp_url = "https://github.com/godotengine/godot-cpp.git"

def _register_godot_cpp(attr):
    git_repository(
        name = "godot_cpp",
        remote = "https://github.com/godotengine/godot-cpp.git",
        branch = attr.branch,
        build_file = ":private/cpp/godot_cpp_build.bzl",
    )

def godot_cpp_extension(ctx):
    for mod in ctx.modules:
        for gdcpp in mod.tags.register_godot_cpp:
            _register_godot_cpp(gdcpp)
