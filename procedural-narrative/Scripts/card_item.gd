extends Node

var card_data

@onready var name_label = $Panel/VBoxContainer/Name
@onready var context_label = $Panel/VBoxContainer/Context

@onready var left = $Panel/VBoxContainer/Description/VBoxContainer/Val0
@onready var right = $Panel/VBoxContainer/Description/VBoxContainer/Val1

func setup(_card_data):
	card_data = _card_data
	Update_Card_UI()
	
func Update_Card_UI():
	
	name_label.text = card_data.name
	if card_data.arc != 0:
		context_label.text = translate_arc(card_data.arc) + " - " +card_data.context + "\n"
	else:
		context_label.text = card_data.context
		
	var left_text: String = card_data.left_description + "\n\n"	
	for effect in card_data.left_effects:
		var target_name = enum_to_string(effect.target_options, effect["target"])
		var value = effect["value"]
		left_text += "%s: %+d\n" % [target_name, value] #+ "\n" #+ description
		
	left.text = left_text 
	
	var right_text: String = card_data.right_description + "\n\n"
	for effect in card_data.right_effects:
		var target_name = enum_to_string(effect.target_options, effect["target"])
		var value = effect["value"]
		right_text += "%s: %+d\n" % [target_name, value] #+ "\n" + description

	right.text = right_text


func return_card_ID():
	return card_data.id

func enum_to_string(enum_dict: Dictionary, value: int) -> String:
	return enum_dict.keys()[value]

func translate_arc(arc: int) -> String:
	var arc_map: Dictionary = { 1: "AI Arc",  2: "Alien Arc", 3: "Rebellion Arc"}
	return arc_map[arc]
