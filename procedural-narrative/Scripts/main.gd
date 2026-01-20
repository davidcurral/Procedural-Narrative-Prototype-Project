extends Node
'''
Cartas que serão Mostradas no HUD

@export var card_scene = PackedScene


func _ready():
	GameState.create_card.connect(updateUI(cards))


func updateUI(cards):
	cards.visible
	card_scene.visible = true

'''
