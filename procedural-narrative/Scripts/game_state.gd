extends Node

'''Cartas que serão instanciadas 1 a 1 como Reigns

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
var stored_current_card

# -- World variables --
var world_state: Dictionary = {"Resources": 50,"Security": 50,"Moral": 50,"Progress": 50,"Risk":0} 
#var memory_flags: Dictionary = {}
#var unlocked_arcs: Array = []
#var card_cooldowns: Dictionary = {}

const LEFT_CHOICE = 0
const RIGHT_CHOICE = 1


# -- Signals --
signal card_selected (card_resource)
signal choice_made (choice_id)
signal world_change 

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
				
	show_first_card()

	
func _on_choice_made(choice_id):
	pick_next_card(choice_id)	

func pick_next_card(choice_id: int): #Resolve current card → compute weights for all valid cards → select next → set as current → emit
	if choice_id == LEFT_CHOICE:
		apply_effects(stored_current_card.left_effects)

	else:
		apply_effects(stored_current_card.right_effects)

	compute_card_probability_of_appearing() # futuro tirar isto do loop e adicionar uma carta que passa sempre se necess~ário
	var 	weight_treshold = rng.randf_range(0,max_weight)

	for card_id in available_cards_list.keys():
		var card_resource = available_cards_list[card_id] 
		if card_resource.weight >= weight_treshold:
			card_selected.emit(card_resource)
			stored_current_card = card_resource
			break
		else:
			weight_treshold = rng.randf_range(0,max_weight)

func apply_effects(effects_list: Array) -> void:    # Careful with enums, they appear to be strings but are ints, when comparing need to match
	for effect in effects_list:
		match effect["type"]:
			effect.type_options.stat: apply_world_stat(effect)
			effect.type_options.flag: GameMemory.memory_flags[effect["target"]] = effect["value"] 
			effect.type_options.unlock: apply_world_arcs(effect) 
			effect.type_option.countdown: GameMemory.memory_counters[effect["target"]] = effect["value"]

	world_change.emit()
	
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
	
func apply_world_stat(effect):
	var key = effect.TARGET_KEYS.get(effect["target"])
	if key == null:
		push_error("Unknown stat target")
		return
	world_state[key] = world_state.get(key, 0) + effect["value"]
	
func apply_world_arcs(effect):
	var key = effect.ARC_KEYS.get(effect["arc"])
	if key == null:
		push_error("Unknown stat target")
		return
		
	if effect.value not in effect.arc_chapter:
		effect.arc_chapter.append(effect.value)
	GameMemory.memory_arcs[key] = effect.arc_chapter
	
	
func show_first_card():
	#var card_picked = rng.randi_range(0,len(initial_card_list))
	#var card_resource = initial_card_list[card_picked] 
	var card_resource = initial_card_list[0]
	stored_current_card = card_resource
	card_selected.emit(card_resource)

	
