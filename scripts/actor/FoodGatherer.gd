extends CharacterBody3D

enum Task {
	GettingFood,
	Searching,
	Delivering,
	Walking
}

var CurrentTask = Task.Searching
@export var walk_speed = 6
@export var resource_generataion_amount = 0

var Hut = null
var held_resource_amount = 0
var runOnce = true

var FoodProducers:Array
var FoodIndex:int

@onready var navagent = $NavigationAgent3D

func _ready():
	FoodProducers = Hut.get_node("Resources").get_children()
	
func _process(_delta):
	match CurrentTask:
		Task.GettingFood:
			if runOnce:
				runOnce = false
				await get_tree().create_timer(2).timeout
				runOnce = true
				held_resource_amount += resource_generataion_amount
				CurrentTask = Task.Searching
				
				if FoodIndex >= FoodProducers.size():
					CurrentTask = Task.Delivering
					
		Task.Searching:
			navagent.set_target_position(FoodProducers[FoodIndex].global_position)
			CurrentTask = Task.Walking
			
		Task.Delivering:
			var granerys = get_tree().get_nodes_in_group("Granery")
			if (granerys.size() > 0):
				var nearest_granery = granerys[0]
				for i in granerys:
					if !i.spawned: continue
					if i.position.distance_to(position) < nearest_granery.position.distance_to(position):
						nearest_granery = i
				navagent.set_target_position(nearest_granery.get_node("SpawnPoint").global_position)
				CurrentTask = Task.Walking
				
		Task.Walking:
			if navagent.is_navigation_finished():
				if FoodIndex != FoodProducers.size():
					CurrentTask = Task.GettingFood
					FoodIndex += 1
				else:
					GameManager.Food += held_resource_amount
					FoodIndex = 0
					held_resource_amount = 0
					CurrentTask = Task.Searching
				return
				
			var target_pos = navagent.get_next_path_position()
			var direction = global_position.direction_to(target_pos)
			velocity = direction * walk_speed
			move_and_slide()


	$Label3D.text = str(CurrentTask)
