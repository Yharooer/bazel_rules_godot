# TODO can we write a export script which creates the Godot game exports? can this automatically download Godot from the web
# https://dev.to/bazel/bazel-can-write-to-the-source-folder-b9b
#
# bazel build -s //character_gdscript:character_gdscript --verbose_failures
# bazel run //character_gdscript:character_gdscript_wrapper -s

load("//godot_rules:godot_core_rules.bzl", "gdbazel_wrapper_rule", "godot_exec_rule", "godot_lib_rule")
load("//godot_rules:godot_cpp_rules.bzl", "godot_cpp_repo_rule")

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

def godot_cpp_repo(*args, **kwargs):
    godot_cpp_repo_rule(*args, **kwargs)
