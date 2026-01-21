extends Node

'''
Cartas que serão instanciadas 1 a 1 como Reigns

When you add memory, GameState becomes both:
A state machine
A story historian

Logic Loop:
	1- Resolve current card
	2 - Select next valid card
	3 - Emit next card
	
	IMPORTANT - ❗ GameState should NOT reference Main. Ever.
	
'''
# -- Static Data ---
var all_card_list: Array [Cards] = []
var initial_card_list: Array[Cards]
var common_mult = 1
var rare_mult = 0.5
var epic_mult = 0.1
var max_weight = 1


# -- Runtime Data --
#var card_visibility_state: Dictionary = {}
var available_cards_list: Dictionary = {}
var rng = RandomNumberGenerator.new()

# -- Signals --
signal card_selected
signal choice_made

# -- Func --
func _ready():
	pass
	
	
func set_static_data(cards: Array[Cards], initial_cards : Array [Cards]):
	all_card_list = cards
	initial_card_list = initial_cards
	
	
func initialize():
	available_cards_list.clear()
	
	for card_data in all_card_list:
		if card_data.available == true:
			available_cards_list[card_data.id] = card_data
				
	card_selected.emit()
	show_first_card()
	#print(all_card_list)
	#print(available_cards_list)
	
func pick_next_card(): #Resolve current card → compute weights for all valid cards → select next → set as current → emit
	var card_not_picked = true
	
	resolve_current_card()
	
	while card_not_picked:
		var card_weight = compute_card_probability_of_appearing() 
		var 	weight_treshold = rng.randf_range(0,max_weight)
		if card_weight >= weight_treshold:
			card_not_picked = false
			card_selected.emit()
		return
	
	
func resolve_current_card():
	pass
	
func compute_card_probability_of_appearing() -> float:
	var total_available_cards = available_cards_list.size()
	var weight: float = 0.0
	for card_data in all_card_list:
		if available_cards_list[card_data.card_rarity] == 'common':
			weight = 1.0/total_available_cards * common_mult
		elif available_cards_list[card_data.card_rarity] == 'rare':
			weight = 1.0/total_available_cards * rare_mult
		elif available_cards_list[card_data.card_rarity] == 'epic':
			weight = 1.0/total_available_cards * epic_mult
	return weight
			
	
func show_first_card():
	rng.randi_range(0,len(initial_card_list))
	
