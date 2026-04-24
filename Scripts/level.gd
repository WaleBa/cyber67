extends Node3D

var tunel_scene = preload("res://Scenes/TunelPiece.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WCSpawnPool.refill(tunel_scene, 50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_timer_timeout() -> void:
	var tunel := await WCSpawnPool.spawn_scene(tunel_scene)
	tunel.position.z = 300
	add_child(tunel)
