extends Node

var card_data

@onready var name_label = $Panel/VBoxContainer/Name
@onready var left = $Panel/VBoxContainer/Description/VBoxContainer/Val0
@onready var right = $Panel/VBoxContainer/Description/VBoxContainer/Val1



func setup(_card_data):
	card_data = _card_data
	card_data.build_effects()
	Update_Card_UI()
	
func Update_Card_UI():
	name_label.text = card_data.name
	
	var left_text := "Left\n"

	for effect in card_data.left_effects:
		var target_name = enum_to_string(card_data.target_options, effect["target"])
		var value = effect["value"]
		left_text += "%s: %+d\n" % [target_name, value]
	left.text = left_text
	
	var right_text := "Right\n"
	for effect in card_data.right_effects:
		var target_name = enum_to_string(card_data.target_options, effect["target"])
		var value = effect["value"]
		right_text += "%s: %+d\n" % [target_name, value]

	right.text = right_text



func return_card_ID():
	return card_data.id

func enum_to_string(enum_dict: Dictionary, value: int) -> String:
	return enum_dict.keys()[value]
