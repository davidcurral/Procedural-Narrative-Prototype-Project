extends Node
'''
Cartas que serão Mostradas no HUD

Main emits choice made
'''

@export var card_scene: PackedScene
@export var card_list: Array[Cards]
@export var initial_card_list: Array[Cards]

@onready var card_display = $Panel/HBoxContainer/Panel
var current_card = 0
#var i = 0

func _ready():
	GameState.card_selected.connect(createUI)
	GameState.set_static_data(card_list, initial_card_list)	
	GameState.initialize()
	

func updateUI():
	pass

func createUI():
	for card_id in GameState.available_cards_list.keys():
		var card_resource = GameState.available_cards_list[card_id] # retreving the dictionary
		var card_node = card_scene.instantiate()
		card_display.add_child(card_node)
		card_node.setup(card_resource)


func _on_next_card_pressed() -> void:
	GameState.choice_made.emit()
