# TODO can we write a export script which creates the Godot game exports? can this automatically download Godot from the web
# https://dev.to/bazel/bazel-can-write-to-the-source-folder-b9b
#
# bazel build -s //character_gdscript:character_gdscript --verbose_failures
# bazel run //character_gdscript:character_gdscript_wrapper -s

wrapper_script_template = """
#!/bin/sh
set -e
cd $BUILD_WORKSPACE_DIRECTORY

mkdir -p {addon_dir}
ln -sf {bazel_out_dir}/* {addon_dir}/
"""

def _create_wrapper_impl(ctx):
    script = ctx.actions.declare_file(ctx.label.name + ".sh")

    print("help i am confused")
    print(ctx.attr.deps[0].files.to_list()[0].path)
    print(ctx.attr.deps[0].files.to_list()[0].path.rsplit("/", 1)[0])

    script_content = wrapper_script_template.format(
        addon_dir = "addons",
        bazel_out_dir = ctx.attr.deps[0].files.to_list()[0].path,
    )

    ctx.actions.write(script, script_content, is_executable = True)

    return [DefaultInfo(
        executable = script,
        runfiles = ctx.runfiles(files = ctx.attr.deps[0].files.to_list()),
    )]

create_wrapper = rule(
    implementation = _create_wrapper_impl,
    attrs = {
        "deps": attr.label_list(allow_files = True),
    },
    executable = True,
)

def _godot_addons_impl(ctx):
    output_dir = ctx.actions.declare_directory(ctx.attr.name)

    commands = []
    for dep in ctx.attr.deps:
        for f in dep.files.to_list():
            dst_path = output_dir.path + "/" + dep.label.name
            commands += ["mkdir -p $(dirname {dst}) && cp -r {src} {dst}".format(
                src = f.path,
                dst = dst_path,
            )]
    command = " && ".join(commands)

    ctx.actions.run_shell(
        inputs = ctx.files.deps,
        outputs = [output_dir],
        command = command,
    )

    return [DefaultInfo(files = depset([output_dir]))]

godot_deps = rule(
    implementation = _godot_addons_impl,
    attrs = {
        "deps": attr.label_list(allow_files = True),
    },
)

def _godot_package_impl(ctx):
    output_dir = ctx.actions.declare_directory(ctx.attr.name)
    src_files = ctx.files.srcs

    commands = ["mkdir -p {out_dir}".format(out_dir = output_dir.path)]
    for src_file in src_files:
        dst_path = output_dir.path + "/" + "/".join(src_file.path.split("/")[1:])
        commands += ["mkdir -p $(dirname {dst}) && cp {src} {dst}".format(
            src = src_file.path,
            dst = dst_path,
        )]
    command = " && ".join(commands)

    ctx.actions.run_shell(
        inputs = src_files,
        outputs = [output_dir],
        command = command,
    )

    return [DefaultInfo(files = depset([output_dir]))]

godot_package = rule(
    implementation = _godot_package_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
    },
)

default_exclude = [
    "project.godot",
    "addons/**",
    ".godot/**",
    "BUILD",
    ".DS_Store",
]

def godot_addon(name, srcs = None, deps = None, visibility = None):
    if srcs == None:
        srcs = native.glob(["**/*"], exclude = default_exclude)

    godot_package(
        name = name + "_addon",
        srcs = srcs,
        visibility = visibility or ["//visibility:public"],
    )

    targets = [":" + name + "_addon"]

    if deps:
        godot_deps(
            name = name + "_deps",
            deps = deps,
        )
        targets += [":" + name + "_deps"]

    native.filegroup(
        name = name,
        srcs = targets,
        visibility = visibility or ["//visibility:public"],
    )

    create_wrapper(
        name = name + "_wrapper",
        deps = [name + "_deps"],
    )
