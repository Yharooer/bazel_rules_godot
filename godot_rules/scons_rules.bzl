def _scons_build_impl(ctx):
    output_dir = ctx.actions.declare_directory("bin")

    ctx.actions.run_shell(
        outputs = [output_dir],
        inputs = ctx.attr.srcs,
        command = "scons",
    )

    return [DefaultInfo(files = output_dir)]

scons_build = rule(
    _scons_build_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
    },
)
