extends Node3D

func _unhandled_input(event):
	if event is InputEventKey && event.pressed:
		if  event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode == KEY_R:
			get_tree().change_scene_to_file("res://test_scene.tscn")
			GameManager.start()
