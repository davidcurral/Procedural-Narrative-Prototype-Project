extends Node

var card_data

@onready var name_label = $Panel/VBoxContainer/Name
@onready var left = $Panel/VBoxContainer/Description/VBoxContainer/Val0
@onready var right = $Panel/VBoxContainer/Description/VBoxContainer/Val1




func setup(_card_data):
	card_data = _card_data
	Update_Card_UI()
	
func Update_Card_UI():
	name_label.text = card_data.name
	print(card_data.left_effects)
	left.text = "Left Effect: " + str(card_data.left_effects)
	right.text = "Right Effects : " + str(card_data.right_effects)

func return_card_ID():
	return card_data.id
