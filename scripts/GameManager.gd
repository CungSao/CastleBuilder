extends Node

enum State{
	Play,
	Building,
	Destroying,
}

var CurrentState = State.Play

var Wood = 20
var Stone = 20
var Gold = 100
var Food = 4

var Population:int = 0
var AlvPopulation:int = 0
var MaxPopulation:int = 4
var Happiness = 1
var spawnReady = true
var food_bool = true
var TaxRate = 2

var occupied_fire_pit_spaces:Array
@onready var fire_pit_spaces:Array = get_tree().get_nodes_in_group("citizen_spawn_point")
@onready var Citizen:PackedScene = ResourceLoader.load("res://Scenes/citizen.tscn")

func start():
	Wood = 20
	Stone = 20
	Gold = 100
	Food = 20

func _process(_delta):
	if !spawnReady: return
	if Population < MaxPopulation && Happiness > 0 && fire_pit_spaces.size() > 0:
		await_ready()
		
		var citizen = Citizen.instantiate()
		fire_pit_spaces[0].add_child(citizen)
		citizen.fire_pit_pos = fire_pit_spaces[0]
		citizen.spawn_setup()
		occupied_fire_pit_spaces.append(
			fire_pit_spaces.pop_front())
		
		Population += 1
		AlvPopulation += 1
	elif Happiness < 0:
		await_ready()
		if AlvPopulation > 0:
			remove_citizen(1)

	if food_bool:
		food_bool = false
		await get_tree().create_timer(6).timeout
		Food -= Population
		if Food < 0:
			Food = 0
		food_bool = true
		Gold += round(Population * TaxRate)
		var happiness_value = 1
		if Food > 0:
			happiness_value += 1
		else:
			happiness_value -= 10
		
		if TaxRate > 0:
			happiness_value -= round(TaxRate / 2)
		elif TaxRate < 0:
			happiness_value += round(TaxRate / 2)
			
		Happiness += happiness_value
		if Happiness >= 2:
			Happiness = 2
		elif Happiness <= -2:
			Happiness = -2
		
func remove_citizen(Cost:int):
	for i in range(0, Cost):
		fire_pit_spaces.append(occupied_fire_pit_spaces[0])
		delete_children(occupied_fire_pit_spaces[0])
		occupied_fire_pit_spaces.remove_at(0)
		AlvPopulation -= 1
		Population -= 1
		
func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func await_ready():
	spawnReady = false
	await get_tree().create_timer(3).timeout
	spawnReady = true
