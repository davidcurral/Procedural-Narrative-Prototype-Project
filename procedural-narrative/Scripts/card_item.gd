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
	context_label.text = card_data.context
	
	var left_text: String = card_data.left_description + "\n\n"
	
	for effect in card_data.left_effects:
		var target_name = enum_to_string(effect.target_options, effect["target"])
		var value = effect["value"]
		#var description = effect["description"]
		#var arc = effect["arc"]
		if card_data.arc == 0:
			left_text += "%s: %+d\n" % [target_name, value] #+ "\n" #+ description
		else:
			left_text += enum_to_string(effect.arc_options, effect["arc"]) + "\n" #+ description

	left.text = left_text 
	
	var right_text: String = card_data.right_description + "\n\n"
	for effect in card_data.right_effects:
		var target_name = enum_to_string(effect.target_options, effect["target"])
		var value = effect["value"]
		#var description = effect["description"]
		#var arc = effect["arc"]
		if card_data.arc == 0:
			right_text += "%s: %+d\n" % [target_name, value] #+ "\n" + description
		else:
			right_text += enum_to_string(effect.arc_options, effect["arc"]) + "\n" #+ description

	right.text = right_text

func return_card_ID():
	return card_data.id

func enum_to_string(enum_dict: Dictionary, value: int) -> String:
	return enum_dict.keys()[value]
