load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@rules_foreign_cc//foreign_cc:defs.bzl", "make")

#MAKEFILE = """
#.PHONY: default
#default: SConstruct
#    if [ "$(PLATFORM)" == "macos" ]; then
#        scons target=$(TARGET) platform=$(PLATFORM)
#    else
#        scons target=$(TARGET) platform=$(PLATFORM) arch=$(ARCH)
#    fi
#
#install:
#    cp -r bin build
#"""
#
#write_file(
#    name = "godot-cpp-makefile",
#    out = "Makefile",
#    content = [MAKEFILE],
#    visibility = ["//visibility:public"],
#)

#filegroup(
#    name = "godot-cpp-src",
#    srcs = glob(["**"], exclude = ["Makefile"]),
#    visibility = ["//visibility:public"],
#)

filegroup(
    name = "godot-cpp-src",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

make(
    name = "godot-cpp",
    lib_source = ":godot-cpp-src",
    args = ["-e", "macos"],
    out_lib_dir = "lib",
    out_include_dir = "include",
    out_static_libs = ["libgodot-cpp.macos.template_debug.universal.a"],
    targets = [""],
    postfix_script = "cp -r bin/ $INSTALLDIR/lib && cp -r include/ $INSTALLDIR/include && cp -r gen/include/ $INSTALLDIR/include && cp -r gdextension/**.h $INSTALLDIR/include",
    visibility = ["//visibility:public"],
)

#genrule(
#    name = "godot-cpp",
#    srcs = glob(["**/*"], exclude = ["Makefile"]),
#    outs = ["bin/*"],
#    cmd = "scons",
#    visibility = ["//visibility:public"],
#)

#scons_build(
#    name = "godot-cpp",
#    srcs = glob(["**/*"]),
#)

#cmake(
#    name = "godot-cpp",
#    lib_source = ":godot-cpp-src",
#    visibility = ["//visibility:public"],
#    out_static_libs = ["libgodot-cpp.macos.template_debug.universal.a"],
#)

# I think its doing make then make install but it only needs to do make.
