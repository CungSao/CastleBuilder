extends CharacterBody3D

enum Task {
	GettingResources,
	Searching,
	Delivering,
	Walking
}

var CurrentTask = Task.Searching
@export var walk_speed = 6
@export var resource_generataion_amount = 0
@export_enum("stone", "tree") var resource_name:String

var Hut = null
var held_resource_amount = 0
var runOnce = true

@onready var navagent = $NavigationAgent3D

func _process(_delta):
	match CurrentTask:
		Task.GettingResources:
			if runOnce:
				runOnce = false
				await get_tree().create_timer(2).timeout
				runOnce = true
				held_resource_amount = resource_generataion_amount
				CurrentTask = Task.Delivering
		Task.Searching:
			var resources = get_tree().get_nodes_in_group(resource_name)
			var nearest_resource = resources[0]
			for i in resources:
				if i.position.distance_to(position) < nearest_resource.position.distance_to(position):
					nearest_resource = i
			navagent.set_target_position(nearest_resource.global_position)
			CurrentTask = Task.Walking
		Task.Delivering:
			var stockpiles = get_tree().get_nodes_in_group("Stockpile")
			if (stockpiles.size() > 0):
				var nearest_stockpile = stockpiles[0]
				for i in stockpiles:
					if !i.spawned: continue
					if i.position.distance_to(position) < nearest_stockpile.position.distance_to(position):
						nearest_stockpile = i
				navagent.set_target_position(nearest_stockpile.get_node("SpawnPoint").global_position)
				CurrentTask = Task.Walking
		Task.Walking:
			if navagent.is_navigation_finished():
				if held_resource_amount == 0:
					CurrentTask = Task.GettingResources
				else:
					match resource_name:
						"tree":
							GameManager.Wood += held_resource_amount
						"stone":
							GameManager.Stone += held_resource_amount
					held_resource_amount = 0
					CurrentTask = Task.Searching
				return
				
			var target_pos = navagent.get_next_path_position()
			var direction = global_position.direction_to(target_pos)
			velocity = direction * walk_speed
			move_and_slide()


	$Label3D.text = str(CurrentTask)
