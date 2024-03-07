extends Node3D

var min_distance_x = 200
var min_distance_y = 50
#var cam_speed = 0.2
#var zoom_speed = 1
		
func _process(_delta):
	var viewportSize = get_viewport().size
	var mousePos = get_viewport().get_mouse_position()
	if mousePos.x < min_distance_x:
		global_position -= global_basis.x
	elif mousePos.x > viewportSize.x - min_distance_x:
		global_position += global_basis.x
	if mousePos.y < min_distance_y:
		global_position -= global_basis.z
	elif mousePos.y > viewportSize.y - min_distance_y:
		global_position += global_basis.z
	
	#if Input.is_action_just_released("MiddleMouseButton"):
		#rotation_degrees += Vector3(0,90,0)
	if Input.is_action_just_released("MouseWheelUp"):
		if $Camera3D.global_position.distance_to(global_position) > 10:
			$Camera3D.global_position -= $Camera3D.global_basis.z
	if Input.is_action_just_released("MouseWheelDown"):
		if $Camera3D.global_position.distance_to(global_position) < 50:
			$Camera3D.global_position += $Camera3D.global_basis.z
