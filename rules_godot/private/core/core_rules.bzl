load(":private/core/core_rules_impl.bzl", "gdbazel_wrapper_rule", "godot_exec_rule", "godot_lib_rule")

def godot_lib(*args, **kwargs):
    godot_lib_rule(*args, **kwargs)

    gdbazel_wrapper_rule(
        name = "gdbazel_wrapper",
        deps = kwargs.get("deps"),
    )

def godot_exec(*args, **kwargs):
    godot_exec_rule(*args, **kwargs)

    gdbazel_wrapper_rule(
        name = "gdbazel_wrapper",
        deps = kwargs.get("deps"),
    )
