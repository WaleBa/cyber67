@tool class_name WCSpawnPoolPlugin
extends EditorPlugin
const projectsettings_prefix := "addons/wc_spawn_pool/"
static var max_waiting := 16

func _enter_tree() -> void:
	add_autoload_singleton("WCSpawnPool","res://addons/worstconcept-spawnpool/WCSpawnPool.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("WCSpawnPool")

static func _static_init() -> void:
	if not ProjectSettings.has_setting(projectsettings_prefix+"max_waiting"):
		ProjectSettings.set_setting(projectsettings_prefix+"max_waiting", 16)
	ProjectSettings.set_initial_value(projectsettings_prefix+"max_waiting", 16)
	max_waiting = ProjectSettings.get_setting_with_override(projectsettings_prefix+"max_waiting")
