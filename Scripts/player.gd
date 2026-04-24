extends Area3D

var projectile = preload("res://Scenes/projectile.tscn")

const LEFT_X = 20.0
const RIGHT_X= -20.0
const CENTER_X = 0.0
const SPEED = 3

var target_x = CENTER_X
var direction
var bullets = 0

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
		if($Control/ProgressBar.value != 0 or bullets == 0):
			return
		var bullet = projectile.instantiate()
		bullet.position = position
		bullet.target_x = target_x
		get_parent().add_child(bullet)
		$Timer.start()
		bullets -= 1
		$Control/Label.text = str(bullets)
		$Control/ProgressBar.value = 100

func _physics_process(delta):
	match(direction):
		LEFT:
			if(position.distance_to(Vector3(target_x,0,0)) > 2.5):
				$Striker.rotation.z = lerp($Striker.rotation.z, deg_to_rad(-30), SPEED * 3 * delta * get_parent().GLOBAL_SPEED)
			else:
				$Striker.rotation.z = lerp($Striker.rotation.z, deg_to_rad(0), SPEED * 3 * delta * get_parent().GLOBAL_SPEED)
		RIGHT:
			if(position.distance_to(Vector3(target_x,0,0)) > 2.5):
				$Striker.rotation.z = lerp($Striker.rotation.z, deg_to_rad(30), SPEED * 3 * delta * get_parent().GLOBAL_SPEED)
			else:
				$Striker.rotation.z = lerp($Striker.rotation.z, deg_to_rad(0), SPEED * 3 * delta * get_parent().GLOBAL_SPEED)
	
	position.x = lerp(position.x, target_x, SPEED * delta  * get_parent().GLOBAL_SPEED)
	
	if($Control/ProgressBar.value != 0):
		$Control/ProgressBar.value -= 3

func _on_area_entered(area: Area3D) -> void:
	print("nn")
	if(area is light_obstacle):
		print("l")
	elif(area is hard_obstacle):
		print("h")
	elif(area is battery):
		bullets += 1
		$Control/Label.text = str(bullets)
		area.visible = false
		print("bbbbbb")
