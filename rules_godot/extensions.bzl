load(":private/cpp/godot_cpp_extension.bzl", "godot_cpp_extension")

def _rules_godot_extension(ctx):
    godot_cpp_extension(ctx)

_register_godot_cpp = tag_class(attrs = {"branch": attr.string(mandatory = True)})

rules_godot = module_extension(
    implementation = _rules_godot_extension,
    tag_classes = {
        "register_godot_cpp": _register_godot_cpp,
    },
)
