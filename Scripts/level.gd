extends Node3D

var tunel_scene = preload("res://Scenes/TunelPiece.tscn")

var difficulty = 4
var GLOBAL_SPEED = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WCSpawnPool.refill(tunel_scene, 50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_timer_timeout() -> void:
	var tunel := await WCSpawnPool.spawn_scene(tunel_scene)
	tunel.position.z = 1200
	tunel.get_node("tunel_z_wiatrakami").get_node("AnimationPlayer").play("PlaneAction_002")
	tunel.show_obstacles(difficulty)
	add_child(tunel)
	GLOBAL_SPEED += 0.01
	if($Timer.wait_time > 0.02):
		$Timer.wait_time -= 0.02
