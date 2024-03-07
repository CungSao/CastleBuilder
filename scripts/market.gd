extends HBoxContainer

func _process(delta):
	$VBoxContainer/HBoxContainer/Label/Label2.text = str(GameManager.Food)
	$VBoxContainer/HBoxContainer2/Label/Label2.text = str(GameManager.Iron)
	
	$VBoxContainer2/HBoxContainer/Label/Label2.text = str(GameManager.Stone)
	$VBoxContainer2/HBoxContainer2/Label/Label2.text = str(GameManager.Wood)

func buy(cost:int, amount:int, item) -> int:
	if GameManager.Gold > cost:
		GameManager.Gold -= cost
		return item + amount
	return item

func sell(amount:int, money:int, item) -> int:
	if item > amount:
		GameManager.Gold += money
		return item - amount
	return item
	
func _on_sell_food_button_down():
	GameManager.Food = sell(5, 30, GameManager.Food)
func _on_buy_food_button_down():
	GameManager.Food = buy(25, 5, GameManager.Food)

func _on_sell_iron_button_down():
	GameManager.Iron = sell(5, 30, GameManager.Iron)
func _on_buy_iron_button_down():
	GameManager.Iron = buy(40, 5, GameManager.Iron)

func _on_sell_stone_button_down():
	GameManager.Stone = sell(5, 15, GameManager.Stone)
func _on_buy_stone_button_down():
	GameManager.Stone = buy(20, 5, GameManager.Stone)

func _on_sell_wood_button_down():
	GameManager.Wood = sell(5, 5, GameManager.Wood)
func _on_buy_wood_button_down():
	GameManager.Wood = buy(10, 5, GameManager.Wood)
