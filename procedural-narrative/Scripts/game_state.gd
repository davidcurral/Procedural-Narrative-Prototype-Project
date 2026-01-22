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
var rare_mult = 0.75
var epic_mult = 0.5
var max_weight = .7


# -- Runtime Data --
#var card_visibility_state: Dictionary = {}
var available_cards_list: Dictionary = {}
var rng = RandomNumberGenerator.new()

# -- Signals --
signal card_selected (card_resource)
signal choice_made (choice_id)

# -- Func --
func _ready():
	choice_made.connect(_on_choice_made)
	
	
func set_static_data(cards: Array[Cards], initial_cards : Array [Cards]):
	all_card_list = cards
	initial_card_list = initial_cards
	
	
func initialize():
	available_cards_list.clear()
	
	for card_data in all_card_list:
		if card_data.available == true:
			available_cards_list[card_data.id] = card_data
				
	#card_selected.emit(card_id)
	show_first_card()

	
func _on_choice_made(choice_id):
	pick_next_card()	

func pick_next_card(): #Resolve current card → compute weights for all valid cards → select next → set as current → emit
	resolve_current_card()
	compute_card_probability_of_appearing() # futuro tirar isto do loop e adicionar uma carta que passa sempre se necess~ário
	var 	weight_treshold = rng.randf_range(0,max_weight)

	for card_id in available_cards_list.keys():
		var card_resource = available_cards_list[card_id] 
		if card_resource.weight >= weight_treshold:
			print("Card Name: " ,card_resource.name , " Weight: ", card_resource.weight ," >= ","Treshold: ", snapped(weight_treshold, 0.01))
			card_selected.emit(card_resource)
			break
		else:
			weight_treshold = rng.randf_range(0,max_weight)

		
func resolve_current_card():
	pass
	
func compute_card_probability_of_appearing() -> void:
	var total_available_cards = available_cards_list.size()
	for card_id in available_cards_list.keys(): # Get id from card
		var card_resource = available_cards_list[card_id] # returns int no string
		if card_resource.card_rarity == 0:
			card_resource.weight = 1.0/total_available_cards * common_mult
		elif card_resource.card_rarity == 1:
			card_resource.weight = 1.0/total_available_cards * rare_mult
		elif card_resource.card_rarity == 2:
			card_resource.weight = 1.0/total_available_cards * epic_mult

			
	
func show_first_card():
	rng.randi_range(0,len(initial_card_list))
	
