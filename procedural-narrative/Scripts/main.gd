extends Node
'''
Cartas que serão Mostradas no HUD
'''

@export var card_scene: PackedScene
@export var card_list: Array[Cards]

@onready var card_display = $Panel/HBoxContainer/Panel

func _ready():
	GameState.card_selected.connect(updateUI)
	GameState.set_static_data(card_list)	

func updateUI():
	#for cards in GameState.card_list:
	var card = card_scene.instantiate()
	card_display.add_child(card)
#		card.setup(cards)

func nextCard():
	card_display.queue_free()
	updateUI()


func _on_next_card_pressed() -> void:
	pass # Replace with function body.
