
extends Node
'''
Cartas que serão Mostradas no HUD

Main emits choice made
'''

#@export var card_scene: PackedScene
#@export var card_list: Array[Cards] = []
@export var initial_card_list: Array[Cards]
@export var database: CardDatabase

@onready var card_display = $Panel/HBoxContainer/Panel
@onready var card_node = $Panel/HBoxContainer/Panel/VBoxContainer/Cards

#var choice_id
var right_choice
var left_choice
const LEFT_CHOICE = 0
const RIGHT_CHOICE = 1


#-- World Variables -- 
@onready var world_val1 = $Panel/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Control1
@onready var world_val2 = $Panel/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Control2
@onready var world_val3 = $Panel/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Control3
@onready var world_val4 = $Panel/HBoxContainer/Panel/VBoxContainer/HBoxContainer/Control4

func _ready():
	GameState.card_selected.connect(updateUI)
	GameState.set_static_data(database.card_list, initial_card_list)	
	GameState.world_change.connect(world_UI)
	GameState.initialize()


func updateUI(card_resource):
		card_node.setup(card_resource)
		world_UI()
		world_progress_bar()

func world_UI():
	world_val1.get_child(0).text = "Resources: " + str(GameState.world_state.get("Resources"))
	world_val2.get_child(0).text = "Security:  " + str(GameState.world_state.get("Security"))
	world_val3.get_child(0).text = "Moral:  " + str(GameState.world_state.get("Moral"))
	world_val4.get_child(0).text = "Progress:  " + str(GameState.world_state.get("Progress"))

func world_progress_bar():
	world_val1.get_child(1).value = GameState.world_state.get("Resources")
	world_val2.get_child(1).value = GameState.world_state.get("Security")
	world_val3.get_child(1).value = GameState.world_state.get("Moral")
	world_val4.get_child(1).value = GameState.world_state.get("Progress")


func _on_next_card_pressed(choice_id) -> void:
	GameState.choice_made.emit(choice_id)

func _on_right_choice_pressed() -> void:
	_on_next_card_pressed(RIGHT_CHOICE)

func _on_left_choice_pressed() -> void:
	_on_next_card_pressed(LEFT_CHOICE)


func _on_memory_print() -> void:
	print(GameMemory.memory_arcs)
