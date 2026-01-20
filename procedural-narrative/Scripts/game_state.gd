extends Node

'''
Cartas que serão instanciadas 1 a 1 como Reigns

When you add memory, GameState becomes both:

A state machine
A story historian
'''

signal card_selected

@export var card_list: Array[Cards]
@export var card_scene = PackedScene


func _ready() -> void: # initialize state and emit first card
	pass
	
