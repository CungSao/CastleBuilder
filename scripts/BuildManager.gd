extends Node3D

var WoodCuttersHut:PackedScene = ResourceLoader.load("res://assets/WoodCutters.tscn")
var StoneCutterHut:PackedScene = ResourceLoader.load("res://assets/StoneMasons.tscn")
var Stockpile:PackedScene = ResourceLoader.load("res://assets/Stockpile.tscn")
var Granery:PackedScene = ResourceLoader.load("res://assets/Granery.tscn")
var House:PackedScene = ResourceLoader.load("res://assets/House.tscn")
var Wall:PackedScene = ResourceLoader.load("res://assets/wallNarrow.tscn")
var Orchard:PackedScene = ResourceLoader.load("res://assets/Orchard.tscn")

var CurrentSpawnable:StaticBody3D
var buildable:bool = true

func _process(_delta):
	if GameManager.CurrentState == GameManager.State.Building:
		var camera = get_viewport().get_camera_3d()
		if camera:
			var from = camera.project_ray_origin(get_viewport().get_mouse_position())
			var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
			var cursor_pos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
			
			if !CurrentSpawnable: return
			CurrentSpawnable.global_position = Vector3(round(cursor_pos.x), cursor_pos.y, round(cursor_pos.z))
				
		if buildable && can_afford(CurrentSpawnable) && GameManager.AlvPopulation >= CurrentSpawnable.PopulationCost:
			if Input.is_action_just_released("LeftMouseDown"):
				spawn_location()
				
		if Input.is_action_just_released("RightMouseDown"):
			CurrentSpawnable.queue_free()
			CurrentSpawnable = null
			GameManager.CurrentState = GameManager.State.Play

		if Input.is_action_just_released("MiddleMouseButton"):
			CurrentSpawnable.rotation_degrees += Vector3(0,90,0)
		
	if GameManager.CurrentState == GameManager.State.Destroying:
		if is_instance_valid(CurrentSpawnable):
			CurrentSpawnable.queue_free()
			CurrentSpawnable = null
			
		if Input.is_action_just_released("LeftMouseDown"):
			var camera = get_viewport().get_camera_3d()
			var from = camera.project_ray_origin(get_viewport().get_mouse_position())
			var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
			
			var space_state = get_world_3d().direct_space_state
			var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
			if !result: return
			if result.collider.is_in_group("building"):
				result.collider.run_despawn()
	
func spawn_location():
	var navMesh = get_tree().get_nodes_in_group("NavMesh")[0]
	var obj = CurrentSpawnable.duplicate()
	obj.position = CurrentSpawnable.position
	navMesh.add_child(obj)
	obj.run_spawn()
	GameManager.remove_citizen(obj.PopulationCost)
	obj.spawned = true
	obj.add_to_group("Stockpile")
	charge_object(obj)
	obj.set_disabled(false)
	navMesh.bake_navigation_mesh()
	
func can_afford(obj) -> bool:
	var resources = ["Wood", "Stone", "Gold"]

	for resource in resources:
		if GameManager.get(resource) < obj.get(resource + "Cost"):
			return false
	return true

func charge_object(obj):
	GameManager.Wood -= obj.WoodCost
	GameManager.Stone -= obj.StoneCost
	GameManager.Gold -= obj.GoldCost

func spawn_wood_cutter():
	spawn_obj(WoodCuttersHut)
	
func spawn_stockpile():
	spawn_obj(Stockpile)

func spawn_stone_cutter():
	spawn_obj(StoneCutterHut)

func spawn_granery():
	spawn_obj(Granery)
func spawn_orchard():
	spawn_obj(Orchard)
func spawn_house():
	spawn_obj(House)
func spawn_wall_narrow():
	spawn_obj(Wall)

func spawn_obj(obj):
	if CurrentSpawnable:
		CurrentSpawnable.queue_free()
	CurrentSpawnable = obj.instantiate()
	CurrentSpawnable.set_disabled(true)
	get_tree().root.add_child(CurrentSpawnable)
	GameManager.CurrentState = GameManager.State.Building
