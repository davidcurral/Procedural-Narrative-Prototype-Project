extends Node

'''
Cartas que serão instanciadas 1 a 1 como Reigns

When you add memory, GameState becomes both:

A state machine
A story historian
'''
# -- Static Data ---
var card_list: Array [Cards] = []


# -- Runtime Data --
var card_state: Dictionary = {}

# -- Signals --
signal card_selected
#signal updtae_UI


	
func set_static_data(cards: Array[Cards]):
	card_list = cards
	card_selected.emit()
	
func initialize():
	card_state.clear()
	
	
