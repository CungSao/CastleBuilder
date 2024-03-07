extends Control

@onready var vbox = $Control/VBoxContainer
@onready var vbox2 = $Control/VBoxContainer2

func _process(_delta):
	vbox.get_node("Wood/Label").text = str(GameManager.Wood)
	vbox.get_node("Stone/Label").text = str(GameManager.Stone)
	vbox.get_node("Food/Label").text = str(GameManager.Food)
	vbox.get_node("Gold/Label").text = str(GameManager.Gold)
	vbox2.get_node("Pop/Label").text = str(GameManager.AlvPopulation) + " / " + str(GameManager.MaxPopulation)
	vbox2.get_node("Hap/Label").text = str(GameManager.Happiness)
	$TabContainer/Enconogy/HBoxContainer/TaxRate/Label2.text = str(GameManager.TaxRate) + "%"

func _on_area_2d_area_entered(_area):
	BuildManager.buildable = false

func _on_area_2d_area_exited(_area):
	BuildManager.buildable = true
	
func _on_build_stockpile_button_down():
	BuildManager.spawn_stockpile()

func _on_build_wood_cutter_button_down():
	BuildManager.spawn_wood_cutter()

func _on_build_stone_cutter_button_down():
	BuildManager.spawn_stone_cutter()

func _on_granery_button_down():
	BuildManager.spawn_granery()

func _on_orchard_button_down():
	BuildManager.spawn_orchard()

func _on_build_house_button_down():
	BuildManager.spawn_house()

func _on_build_wall_narrow_button_down():
	BuildManager.spawn_wall_narrow()

func _on_destroy_pressed():
	print('click')
	GameManager.CurrentState = GameManager.State.Destroying

func _on_IncreateTaxes_button_down():
	GameManager.TaxRate += 2

func _on_DecreaseTaxes_button_down():
	GameManager.TaxRate -= 2
