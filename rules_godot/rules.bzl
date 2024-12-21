# bazel build -s //character_gdscript:character_gdscript --verbose_failures

load(":private/core/core_rules.bzl", _godot_exec = "godot_exec", _godot_lib = "godot_lib")
load(":private/cpp/gdextension_cpp_rule.bzl", _godot_gdextension_cpp = "godot_gdextension_cpp")

godot_lib = _godot_lib
godot_exec = _godot_exec
godot_gdextension_cpp = _godot_gdextension_cpp
