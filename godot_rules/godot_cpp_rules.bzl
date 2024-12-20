load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@rules_cc//cc:defs.bzl", "cc_library")
load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

godot_cpp_url = "https://github.com/godotengine/godot-cpp.git"

#def _godot_cpp_git_repository(name, tag):
#    git_repository(
#        name = name,
#        remote = godot_cpp_url,
#        tag = tag,
#    )

def _godot_cpp_repo_impl(ctx):
    git_repository(
        name = "godot_cpp",
        remote = godot_cpp_url,
        tag = ctx.attr.tag,
    )

godot_cpp_repo_rule = repository_rule(
    _godot_cpp_repo_impl,
    attrs = {
        "tag": attr.string(mandatory = True),
    },
)

#def godot_cpp_gdext_internal(*args, **kwargs):
#    gdext_tag = kwargs.get("gdext_tag")
#    _godot_cpp_git_repository("godot-cpp-%s-src" % gdext_tag, gdext_tag)
#
#    cmake(
#        name = "godot-cpp-%s" % gdext_tag,
#        lib_source = "godot-cpp-%s-src" % gdext_tag,
#    )
#
#    cc_library(
#        deps = kwargs.get("deps") + ["godot-cpp-%s" % gdext_tag],
#        *args,
#        **kwargs
#    )
