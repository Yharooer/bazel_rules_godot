CONFIGURATION_SECTION_TEMPLATE = """[configuration]
entry_symbol = "%s"
reloadable = %s
compatibility_minimum = 4.3
"""

LIBRARIES_SECTION_TEMPLATE = """[libraries]
macos.debug = "%s"
"""

DEPENDENCIES_SECTION_TEMPLATE = """[dependencies]
macos.debug = {
    %s
}
"""

def _generate_configuration_section(ctx):
    # TODO get compatibility_minimum from godot-cpp version
    return CONFIGURATION_SECTION_TEMPLATE % (
        ctx.attr.entry_symbol,
        str(ctx.attr.reloadable).lower(),
    )

def _generate_library_section(filename):
    return LIBRARIES_SECTION_TEMPLATE % filename

def _generate_gdextension_file_content(ctx, filename):
    return "\n".join([
        _generate_configuration_section(ctx),
        _generate_library_section(filename),
        # TODO add dependencies
        # TODO add icons
    ])

def _find_binary(ctx):
    for file in ctx.attr.lib[DefaultInfo].files.to_list():
        if file.basename.split("/")[-1].split(".")[0] == ctx.attr.shared_library_filename:
            return file
    fail("Couldn't find C++ shared library out of [%s]." % str(ctx.attr.lib[DefaultInfo].files.to_list()))

def _gdextension_rule_impl(ctx):
    out_files = []

    # Add binary to output
    src_lib_file = _find_binary(ctx)
    extension = src_lib_file.basename.split(".")[-1]
    target_library_filename = "lib%s.%s" % (ctx.label.name, extension)
    target_library_file = ctx.actions.declare_file(target_library_filename)
    ctx.actions.symlink(output = target_library_file, target_file = src_lib_file)
    out_files.append(target_library_file)

    # Create .gdextension file
    gdext_file = ctx.actions.declare_file("%s.gdextension" % ctx.label.name)
    ctx.actions.write(output = gdext_file, content = _generate_gdextension_file_content(ctx, target_library_filename))
    out_files.append(gdext_file)

    return [
        DefaultInfo(files = depset(out_files)),
        # TODO add CcInfo here so this can be dependended on by other cc_library targets
    ]

gdextension_rule = rule(
    implementation = _gdextension_rule_impl,
    attrs = {
        "lib": attr.label(allow_files = True),
        "deps": attr.label_list(allow_files = True, default = []),
        "shared_library_filename": attr.string(mandatory = True),
        "entry_symbol": attr.string(mandatory = True),
        "reloadable": attr.bool(default = True),
    },
)
