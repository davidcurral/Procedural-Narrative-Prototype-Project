extends Node
'''
Cartas que serão Mostradas no HUD

Main emits choice made
'''

@export var card_scene: PackedScene
@export var card_list: Array[Cards]
@export var initial_card_list: Array[Cards]

@onready var card_display = $Panel/HBoxContainer/Panel
@onready var card_node = $Panel/HBoxContainer/Panel/VBoxContainer/Cards

#var choice_id
var right_choice
var left_choice
const LEFT_CHOICE = 0
const RIGHT_CHOICE = 1


#-- World Variables -- 
@onready var world_val1 = $Panel/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Label
@onready var world_val2 = $Panel/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Label2
@onready var world_val3 = $Panel/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Label3
@onready var world_val4 = $Panel/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Label4

func _ready():
	GameState.card_selected.connect(updateUI)
	GameState.set_static_data(card_list, initial_card_list)	
	GameState.world_change.connect(world_UI)
	GameState.initialize()


func updateUI(card_resource):
		card_node.setup(card_resource)
		world_UI()

func world_UI():
	#print("Changing Game World Variables")
	world_val1.text = "Church: " + str(GameState.world_state.get("church"))
	world_val2.text = "Wealth:  " + str(GameState.world_state.get("wealth"))
	world_val3.text = "Army:  " + str(GameState.world_state.get("army"))
	world_val4.text = "People::  " + str(GameState.world_state.get("people"))


func _on_next_card_pressed(choice_id) -> void:
	GameState.choice_made.emit(choice_id)

func _on_right_choice_pressed() -> void:
	_on_next_card_pressed(RIGHT_CHOICE)

func _on_left_choice_pressed() -> void:
	_on_next_card_pressed(LEFT_CHOICE)


func _on_memory_print() -> void:
	print(GameMemory.memory_arcs)
