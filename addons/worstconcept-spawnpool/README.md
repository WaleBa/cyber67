# overview

## Why?

essentially, creating lots of objects can be really slow/inefficient. this does that beforehand, so you have some "waiting" when you need them.

# instructions

- installation:
  - copy "addons" folder to your project (dont rename anything, put right in `res://`, no subfolders, merge if already one there)
  - go to ProjectSettings -> Plugins and enable
  - optionally: go to ProjectSettings -> General -> Addons -> WCSpawnPool and set the "max_waiting" limit for refilled/despawned instances
- usage:
  - to spawn a scene, call `await WCSpawnPool.spawn_scene(PackedScene)->Node`
  - to despawn one, call `WCSpawnPool.despawn(Node)`
  - to ensure an amount available in the future, call `WCSpawnPool.refill(PackedScene, int)`
  - to see how many are available (from refills or despawns), call `WCSpawnPool.available(PackedScene)->int`

For example:

```gdscript
@export var some_packed_scene : PackedScene # or use `load` or whatever

# spawn an instance:
var the_node := await WCSpawnPool.spawn_scene(some_packed_scene)
some_parent_node.add_child(the_node)

# despawn an instance:
WCSpawnPool.despawn(the_node)

# prepare 3 instances for future spawns:
WCSpawnPool.refill(some_packed_scene, 3)

# print how many are available in the pool to be reused from the despawn and refill:
print(WCSpawnPool.available(some_packed_scene))
```
