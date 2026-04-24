extends Node3D

const SPEED = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position.z -= SPEED * delta * get_parent().GLOBAL_SPEED
	if(position.z < -500):
		WCSpawnPool.despawn(self)
		
func show_obstacles(number_of : int):
	hide_obstacles()
	
	var n = number_of
	while n > 0:
		var child = get_node("obstacles") \
					.get_child(randi_range(0,2)) \
					.get_child(randi_range(0,2)) 
					#.get_child(randi_range(0,1))
		if(child.visible == false):
			child.visible = true
			child = child.get_child(randi_range(0,1))
			child.visible = true
			child.process_mode = Node.PROCESS_MODE_ALWAYS
			n -= 1
	
func hide_obstacles():
	for child in get_node("obstacles").get_children():
		for child2 in child.get_children():
			for child3 in child2.get_children():
				child3.visible = false
				child3.process_mode = Node.PROCESS_MODE_DISABLED
			child2.visible = false
					
			
	
