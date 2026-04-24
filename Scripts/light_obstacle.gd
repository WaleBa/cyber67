extends Area3D

class_name light_obstacle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	rotate_x(delta)
	rotate_y(delta)
	rotate_z(delta)

func destroy():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
