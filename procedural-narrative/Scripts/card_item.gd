extends Node

var card_data

@onready var name_label = $Panel/VBoxContainer/Name
@onready var context_label = $Panel/VBoxContainer/Card_Description

@onready var left_button = $Panel/VBoxContainer/Buttons/VBoxContainer/Left_Button
@onready var right_button = $Panel/VBoxContainer/Buttons/VBoxContainer/Right_Button

@onready var left_button_effect_text = $Panel/VBoxContainer/Buttons/VBoxContainer/Left_Button/EffectsLeftTextUI/LB_Text
@onready var right_button_effect_text = $Panel/VBoxContainer/Buttons/VBoxContainer/Right_Button/EffectsRightTextUI/RB_Text
@onready var left_effects_panel_UI = $Panel/VBoxContainer/Buttons/VBoxContainer/Left_Button/EffectsLeftTextUI
@onready var right_effects_panel_UI = $Panel/VBoxContainer/Buttons/VBoxContainer/Right_Button/EffectsRightTextUI

const LEFT_CHOICE = 0
const RIGHT_CHOICE = 1


func setup(_card_data):
	card_data = _card_data
	Update_Card_UI()
	
func Update_Card_UI():
	
	name_label.text = card_data.name
	if card_data.arc != 0:
		context_label.text = translate_arc(card_data.arc) + " - " + card_data.context + "\n"
	else:
		context_label.text = card_data.context
		
	left_button.text = card_data.left_description
	right_button.text = card_data.right_description
	show_card_effects_on_button_hover()
	

func show_card_effects_on_button_hover():
	var left_effects_text: String = ""
	for effect in card_data.left_effects:
		var target_name = enum_to_string(effect.target_options, effect["target"])
		var value = effect["value"]
		if effect.type == 0:
			if value > 0:
				left_effects_text += "  %s          ⬆︎\n" % [target_name]
			else:
				left_effects_text += "  %s          ⬇︎\n" % [target_name]

	left_button_effect_text.text = "\n"+left_effects_text 
	
	var right_effects_text: String = ""
	for effect in card_data.right_effects:
		var target_name = enum_to_string(effect.target_options, effect["target"])
		var value = effect["value"]
		if effect.type == 0:
			if value > 0:
				right_effects_text += "  %s          ⬆︎\n" % [target_name]
			else:
				right_effects_text += "  %s          ⬇︎\n" % [target_name]

	right_button_effect_text.text = "\n"+right_effects_text

func return_card_ID():
	return card_data.id

func enum_to_string(enum_dict: Dictionary, value: int) -> String:
	return enum_dict.keys()[value]

func translate_arc(arc: int) -> String:
	var arc_map: Dictionary = { 1: "AI Arc",  2: "Alien Arc", 3: "Rebellion Arc"}
	return arc_map[arc]

#region Buttons

func _on_left_button_mouse_entered() -> void:
	left_effects_panel_UI.visible = true
	$Sound/Reveal.play()
	
func _on_left_button_mouse_exited() -> void:
	left_effects_panel_UI.visible = false


func _on_right_button_mouse_entered() -> void:
	right_effects_panel_UI.visible = true
	$Sound/Reveal.play()


func _on_right_button_mouse_exited() -> void:
	right_effects_panel_UI.visible = false


func _on_left_button_pressed() -> void:
	$Sound/SelectEffect.play()
	#$AnimationPlayer.play("Card_Left")
	GameState.choice_made.emit(LEFT_CHOICE)
	#$AnimationPlayer.play("RESET")



func _on_right_button_pressed() -> void:
	$Sound/SelectEffect.play()
	#$AnimationPlayer.play("Card_Right")
	GameState.choice_made.emit(RIGHT_CHOICE)
	#$AnimationPlayer.play("RESET")


#endregion 
