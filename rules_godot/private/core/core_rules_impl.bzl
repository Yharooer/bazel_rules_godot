wrapper_external_name = "_gdbazel"
wrapper_internal_name = "gdbazel_wrapper"

def _get_deps_file_list(deps):
    return [dep[DefaultInfo].files for dep in deps]

def _copy_src_files(ctx, basepath = None, remove_path_prefix_levels = 0):
    path_template = "%s" if basepath == None else (basepath + "/%s")
    output_files = []
    for src_file in [file for target in ctx.attr.srcs for file in target[DefaultInfo].files.to_list()]:
        # Ignore any .godot or _gdbazel files.
        path_split = src_file.short_path.split("/")
        root_dir = path_split[1] if len(path_split) >= 2 else ""
        if root_dir in [".godot", wrapper_external_name]:
            continue

        end_path = "/".join(path_split[remove_path_prefix_levels:])
        out_file = ctx.actions.declare_file(path_template % end_path)
        ctx.actions.symlink(output = out_file, target_file = src_file)
        output_files.append(out_file)
    return output_files

def _create_bazel_wrapper_directory(ctx, deps, basepath):
    out_files = []
    for file in deps.to_list():
        out_file = ctx.actions.declare_file("%s/%s" % (basepath, file.short_path))
        ctx.actions.symlink(output = out_file, target_file = file)
        out_files.append(out_file)

    # Declare .gitignore file
    gitignore_file = ctx.actions.declare_file("%s/.gitignore" % basepath)
    ctx.actions.write(output = gitignore_file, content = "*\n.*")
    out_files.append(gitignore_file)

    return out_files

def _gdbazel_wrapper_impl(ctx):
    deps = depset([], transitive = _get_deps_file_list(ctx.attr.deps))
    out_files = _create_bazel_wrapper_directory(ctx, deps, wrapper_internal_name)
    return [DefaultInfo(files = depset(out_files, transitive = _get_deps_file_list(ctx.attr.deps)))]

gdbazel_wrapper_rule = rule(
    implementation = _gdbazel_wrapper_impl,
    attrs = {
        "deps": attr.label_list(),
    },
)

def _godot_lib_impl(ctx):
    output_files = _copy_src_files(ctx)
    return [DefaultInfo(files = depset(output_files, transitive = _get_deps_file_list(ctx.attr.deps)))]

godot_lib_rule = rule(
    implementation = _godot_lib_impl,
    attrs = {
        "deps": attr.label_list(default = []),
        "srcs": attr.label_list(allow_files = True, default = ["**/*"]),
    },
)

def _godot_exec_impl(ctx):
    # Create gdbazel_wrapper directory
    deps = depset([], transitive = _get_deps_file_list(ctx.attr.deps))
    bazel_wrapper_files = _create_bazel_wrapper_directory(ctx, deps, wrapper_internal_name)

    # Create tmp build directory
    tmp_build_out = _copy_src_files(ctx, basepath = "tmp/gdbazel_godot_export", remove_path_prefix_levels = 1)
    bazel_wrapper_build_dir = ctx.actions.declare_symlink("tmp/gdbazel_godot_export/%s" % wrapper_external_name)
    ctx.actions.symlink(output = bazel_wrapper_build_dir, target_path = ("../../%s/" % wrapper_internal_name))
    tmp_build_out.append(bazel_wrapper_build_dir)

    # TODO download Godot and create exports

    return [DefaultInfo(files = depset(tmp_build_out + bazel_wrapper_files))]  # TODO remove all dirs apart from build directory

godot_exec_rule = rule(
    implementation = _godot_exec_impl,
    attrs = {
        "deps": attr.label_list(default = []),
        "srcs": attr.label_list(allow_files = True, default = []),
    },
)
