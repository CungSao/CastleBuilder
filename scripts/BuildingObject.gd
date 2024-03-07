extends StaticBody3D

@export var WoodCost:int
@export var StoneCost:int
@export var GoldCost:int
@export var PopulationCost:int
@export var IncreasePopCap = false
@export var IncreaseCapAmount:int = 5

@export var spawn_actor = true
@export var Actor:PackedScene
var current_actor
var spawned:bool

func run_spawn():
	if spawn_actor:
		var actor = Actor.instantiate()
		current_actor = actor
		get_tree().root.add_child(actor)
		actor.global_position = $SpawnPoint.global_position
	if IncreasePopCap:
		GameManager.MaxPopulation += IncreaseCapAmount

func run_despawn():
	if spawn_actor:
		current_actor.queue_free()
	GameManager.Population -= PopulationCost
	if IncreasePopCap:
		GameManager.Population -= IncreaseCapAmount
	queue_free()

func set_disabled(disabled:bool):
	$CollisionShape.disabled = disabled
	
func _on_Area_area_entered(_area):
	BuildManager.buildable = false

#func _on_Area_area_exited(_area):
	#BuildManager.buildable = true
