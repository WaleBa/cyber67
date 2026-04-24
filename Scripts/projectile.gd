extends Area3D

const SPEED = 100

var target_x 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position.z += SPEED * delta * get_parent().GLOBAL_SPEED
	position.x = lerp(position.x, target_x, 5 * delta * get_parent().GLOBAL_SPEED)

func _on_area_entered(area: Area3D) -> void:
	print("nn")
	if(area is light_obstacle):
		print("d")
		area.destroy()
		get_parent().get_node("Player").points += 250
		get_parent().get_node("Player").get_node("AudioStreamPlayer3D").stream = preload("res://Assets/sounds/trrrt3.wav")
		get_parent().get_node("Player").get_node("AudioStreamPlayer3D").play()
		queue_free()
	elif(area is hard_obstacle):
		get_parent().get_node("Player").get_node("AudioStreamPlayer3D").stream = preload("res://Assets/sounds/trrrt3.wav")
		get_parent().get_node("Player").get_node("AudioStreamPlayer3D").play()
		queue_free()
