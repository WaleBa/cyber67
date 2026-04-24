class_name WCSpawnPoolAutoload extends Node
## Pool and instantiation Thread for spawning/despawning scenes. [br]
## Do not instantiate this class, it is available as a global autoload as `WCSpawnPool`.


var _instantiate_queue := Queue.new()
var _instantiate_semaphore := Semaphore.new()

var _done_queue := Queue.new()
var _done_semaphore := Semaphore.new()

var _despawn_container : Dictionary[String,Array]
var _refills : Dictionary[String,int]

var _quitting := false
var _thread := Thread.new()

## spawns an instance of `scene` and returns it async.
## it takes the instance from the pool if available, otherwise it gets `instantiate`d on a separate Thread.
func spawn_scene(scene: PackedScene)->Node:
	var sanitized_name := ResourceUID.ensure_path(scene.resource_path)
	if _despawn_container.has(sanitized_name):
		var container := _despawn_container[sanitized_name]
		if container.size()>0:
			var node := container.pop_back() as Node
			#print("returning existing spawnee: "+node.name)
			return node
	return await _push_scene(scene)

## returns how many instances of `scene` are currently pooled
func available(scene: PackedScene)->int:
	var sanitized_name := ResourceUID.ensure_path(scene.resource_path)
	if _despawn_container.has(sanitized_name):
		var container := _despawn_container[sanitized_name]
		return container.size()
	return -1

## ensures `amount` instances of `scene` will be available in the pool in the future
func refill(scene: PackedScene, amount: int)->void:
	assert(amount < WCSpawnPoolPlugin.max_waiting, "refill amount more than allowed by max_waiting!")
	var sanitized_name := ResourceUID.ensure_path(scene.resource_path)
	if not _refills.has(sanitized_name):
		@warning_ignore("return_value_discarded")
		_refills.set(sanitized_name,0)
	if _refills[sanitized_name] > 0:
		amount -= _refills[sanitized_name]
	var av := maxi(0,available(scene))
	if av < amount and amount > 0:
		_refills[sanitized_name] += amount - av
		for i in (amount - av):
			_refill_scene(scene)

## returns a `node` to the pool to be reused by `spawn_scene` or deleted later if there are more than allowed in the Project Settings
func despawn(node: Node)->void:
	var sanitized_name := ResourceUID.ensure_path(node.scene_file_path)
	if not _despawn_container.has(sanitized_name):
		@warning_ignore("return_value_discarded")
		_despawn_container.set(sanitized_name,[])
	var container := _despawn_container[sanitized_name]
	if node.is_inside_tree():
		node.get_parent().remove_child(node)
	container.push_back(node)

func _refill_scene(scene: PackedScene)->void:
	var sanitized_name := ResourceUID.ensure_path(scene.resource_path)
	despawn(await _push_scene(scene) as Node)
	_refills[sanitized_name] -= 1

func _push_scene(scene: PackedScene)->Signal:
	#print("pushing spawn scene: "+ResourceUID.ensure_path(scene.resource_path))
	var job := Job.new()
	job.scene = scene
	_instantiate_queue.push(job)
	_instantiate_semaphore.post()
	return job.done

func _scene_instantiation()->void:
	while not _quitting:
		_instantiate_semaphore.wait()
		if _quitting: break
		var job := _instantiate_queue.pop()
		#print("instantiating spawn scene: "+ResourceUID.ensure_path(job.scene.resource_path))
		job.instance = job.scene.instantiate()
		_done_queue.push(job)
		_done_semaphore.post()

func _ready() -> void:
	assert(get_parent() == get_tree().root and self != get_tree().current_scene, "WCSpawnPoolAutoload should not be manually instantiated!")
	process_mode = Node.PROCESS_MODE_ALWAYS
	process_thread_group = Node.PROCESS_THREAD_GROUP_MAIN_THREAD
	process_thread_group_order = 0
	@warning_ignore("return_value_discarded")
	_thread.start(_scene_instantiation)
	#print("Hi From WCSpawnPoolAutoload")

func _process(_delta: float) -> void:
	while _done_semaphore.try_wait():
		var job := _done_queue.pop()
		job._emit_done()
	for container in _despawn_container:
		var count := _despawn_container[container].size()
		for _i in (count - WCSpawnPoolPlugin.max_waiting):
			(_despawn_container[container].pop_back() as Node).queue_free()

func _exit_tree() -> void:
	_quitting = true
	_instantiate_semaphore.post()
	_thread.wait_to_finish()
	for container in _despawn_container:
		for node: Node in _despawn_container[container] as Array[Node]:
			node.queue_free()

class Job extends RefCounted:
	var scene: PackedScene
	var instance: Node
	signal done(node: Node)
	func _emit_done()->void: done.emit(instance)

class Queue extends Mutex:
	var _data : Array[Job]
	func push(what: Job)->void:
		lock()
		_data.push_back(what)
		unlock()
	func size()->int:
		lock()
		var num := _data.size()
		unlock()
		return num
	func pop()->Job:
		lock()
		var what : Job = _data.pop_front()
		unlock()
		return what
