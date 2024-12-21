load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@rules_foreign_cc//foreign_cc:defs.bzl", "make")

filegroup(
    name = "godot_cpp_src",
    srcs = glob(["**"]),
    visibility = ["//visibility:private"],
)

make(
    name = "godot_cpp",
    lib_source = ":godot_cpp_src",
    args = ["-e", "macos"],
    out_lib_dir = "lib",
    out_include_dir = "include",
    out_static_libs = ["libgodot-cpp.macos.template_debug.universal.a"],
    targets = [""],
    postfix_script = "cp -r bin/ $INSTALLDIR/lib && cp -r include/ $INSTALLDIR/include && cp -r gen/include/ $INSTALLDIR/include && cp -r gdextension/**.h $INSTALLDIR/include",
    visibility = ["//visibility:public"],
)
