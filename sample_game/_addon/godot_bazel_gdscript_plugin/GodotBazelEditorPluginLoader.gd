@tool
extends EditorPlugin

const bazel_dependencies_dock_scene: PackedScene = preload("res://_addon/godot_bazel_gdscript_plugin/BazelDependenciesDock.tscn")
const bazel_build_button_scene: PackedScene = preload("res://_addon/godot_bazel_gdscript_plugin/BazelBuildButton.tscn")

var bazel_dependencies_dock: Control
var bazel_build_button: Button

func _enter_tree():
	if not Engine.is_editor_hint():
		return
	bazel_dependencies_dock = bazel_dependencies_dock_scene.instantiate()
	bazel_build_button = bazel_build_button_scene.instantiate()
	
	add_control_to_dock(DOCK_SLOT_LEFT_BR, bazel_dependencies_dock)
	add_control_to_container(CONTAINER_TOOLBAR, bazel_build_button)
	
func _exit_tree():
	if not Engine.is_editor_hint():
		return
	remove_control_from_docks(bazel_dependencies_dock)
	remove_control_from_container(CONTAINER_TOOLBAR, bazel_build_button)
	bazel_dependencies_dock.queue_free()
	bazel_dependencies_dock = null
	bazel_build_button.queue_free()
	bazel_build_button = null
	
