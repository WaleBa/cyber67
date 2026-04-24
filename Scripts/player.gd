extends Area3D

var projectile = preload("res://Scenes/projectile.tscn")

const LEFT_X = 20.0
const RIGHT_X= -20.0
const CENTER_X = 0.0
const SPEED = 3

var target_x = CENTER_X
var direction

enum {
	RIGHT,
	LEFT
}

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	get_input(delta)
	
func get_input(delta):
	if Input.is_action_just_released("left"):
		if(target_x == CENTER_X):
			target_x = LEFT_X
		elif(target_x == RIGHT_X):
			target_x = CENTER_X
		direction = LEFT
			
	if Input.is_action_just_released("right"):
		if(target_x == CENTER_X):
			target_x = RIGHT_X
		elif(target_x == LEFT_X):
			target_x = CENTER_X
		direction = RIGHT
		
	if Input.is_action_just_pressed("shoot"):
		if(!$Timer.is_stopped()):
			return
		var bullet = projectile.instantiate()
		bullet.position = position
		get_tree().root.add_child(bullet)
		$Timer.start()

func _physics_process(delta):
	match(direction):
		LEFT:
			if(position.distance_to(Vector3(target_x,0,0)) > 2.5):
				$Striker.rotation.z = lerp($Striker.rotation.z, deg_to_rad(-30), SPEED * 3 * delta)
			else:
				$Striker.rotation.z = lerp($Striker.rotation.z, deg_to_rad(0), SPEED * 3 * delta)
		RIGHT:
			if(position.distance_to(Vector3(target_x,0,0)) > 2.5):
				$Striker.rotation.z = lerp($Striker.rotation.z, deg_to_rad(30), SPEED * 3 * delta)
			else:
				$Striker.rotation.z = lerp($Striker.rotation.z, deg_to_rad(0), SPEED * 3 * delta)
	
	position.x = lerp(position.x, target_x, SPEED * delta)
