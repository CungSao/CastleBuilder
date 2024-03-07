extends CharacterBody3D

@export var walk_speed = 3

enum Task{
	Walking,
	Sitting
}

var CurrentTask = Task.Walking
var fire_pit_pos

@onready var navagent = $NavigationAgent3D
	
func spawn_setup():
	navagent.set_target_position(fire_pit_pos.global_position)

func _process(_delta):
	match CurrentTask:
		Task.Sitting:
			pass
		Task.Walking:
			if navagent.is_navigation_finished():
				CurrentTask = Task.Sitting
				return
				
			var target_pos = navagent.get_next_path_position()
			var direction = global_position.direction_to(target_pos)
			velocity = direction * walk_speed
			move_and_slide()
