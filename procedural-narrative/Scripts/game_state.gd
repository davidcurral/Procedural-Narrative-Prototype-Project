extends Node

# IMPORTANT - ❗ GameState should NOT reference Main. Ever.
#region Variables
# -- Static Data ---
var card_database: Array[Cards]
var initial_card_list: Array[Cards]
var max_weight = 1
var max_concurrent_arcs: int
var simple_run: bool


# -- Runtime Data --
var available_cards_list: Dictionary = {} # card_id : card
var cooldown_tracker: Dictionary = {} # card_id : card.cooldown
var arc_cards_list: Array [Cards] = []
var debug_candidates: Array = []


var rng = RandomNumberGenerator.new()
var stored_current_card

# -- World variables --
var world_state: Dictionary = {"Resources": 50,"Security": 50,"Moral": 50,"Progress": 50,"Risk":0} 
var event_memory : Array[Dictionary] = []
var memory_limit : int = 15
var current_turn : int = 0

const LEFT_CHOICE = 0
const RIGHT_CHOICE = 1

# ---- Arcs memory ----
var active_arcs : Dictionary = {}   # arc_name : step
var completed_arcs : Array[String] = []
var locked_arcs : Array[String] = []
var first_print: Array = []


# -- Signals --
signal card_selected (card_resource)
signal choice_made (choice_id)
signal world_change 
signal print_cue (passed_print) 

#endregion 

#region Functions 
# -- Functions --
func _ready():
	choice_made.connect(_on_choice_made)
	
	
# --- Starting Functions ---
func set_static_data(cards: Array[Cards], initial_cards : Array [Cards], max_arcs: int):
	card_database = cards
	initial_card_list = initial_cards
	max_concurrent_arcs = max_arcs
	simple_run = !MainMenu.memory

	
func initialize():		
	available_cards_list.clear()
	arc_cards_list.clear()
	print("Simple Run: ",simple_run)
	
	for card_data in card_database:
		if simple_run == true:	
			if card_data.available == true:
				if card_data.arc == 0:
					available_cards_list[card_data.id] = card_data
		elif simple_run == false:
			if card_data.available == true:
				available_cards_list[card_data.id] = card_data
			if card_data.arc != 0:
				arc_cards_list.append(card_data)

	show_first_card()
	

# --- Running Functions ---
func _on_choice_made(choice_id):
	card_processing(choice_id)	
	
func card_processing(choice_id: int): #Resolve current card → compute weights for all valid cards → select next → set as current → emit
	print_arc_start()
		
	if choice_id == LEFT_CHOICE:
		apply_effects(stored_current_card.left_effects)
	else:
		apply_effects(stored_current_card.right_effects)

	on_card_played_memory_append(stored_current_card, choice_id)
	
	if simple_run == false: 
		process_cooldowns()
		evaluate_arc_unlocks()
		progress_arc(stored_current_card,choice_id)
		
	pick_next_card()

# --- Logic Fucntions ---
func apply_effects(effects_list: Array) -> void:    # Careful with enums, they appear to be strings but are ints, when comparing need to match
	for effect in effects_list:
		match effect["type"]:
			effect.type_options.stat: apply_world_stat(effect)
			#effect.type_options.unlock: apply_world_arcs(effect) 
			#effect.type_options.flag: GameMemory.memory_flags[effect["target"]] = effect["value"] 
			#effect.type_option.countdown: GameMemory.memory_counters[effect["target"]] = effect["value"]

	world_change.emit()
			
func on_card_played_memory_append(card: Cards, choice: int):
	current_turn += 1

	var memory_entry: Dictionary = {
		#"card_id": card.id,
		"card": card,
		"choice": choice,
		"turn": current_turn,
		#"arc": card.arc,
		#"arc_progress": card.arc_progression,
		"left_effects": card.left_effects,
		"right_effects": card.right_effects
		
	}

	event_memory.append(memory_entry)

	if event_memory.size() > memory_limit:
		event_memory.pop_front()
	
	if simple_run == false:
		if card.cooldown > 0:
			cooldown_tracker[card.id] = card.cooldown

func process_cooldowns():
	var to_remove: Array = []
	for id in cooldown_tracker:
		cooldown_tracker[id] -= 1
		if cooldown_tracker[id] <= 0:
			to_remove.append(id)
	for id in to_remove:
		cooldown_tracker.erase(id)

func pick_next_card() -> Cards: 
	var candidates: Array = []
	debug_candidates = candidates

	for card in available_cards_list.values():
		if simple_run == false:
			if cooldown_tracker.has(card.id):
				continue
			candidates.append(card)
		else:
			candidates.append(card)
		
	if candidates.is_empty():
		return
	
	arc_amount_limit(candidates)
	debug_candidates = candidates

	var total_weight = 0
	for card in candidates:
		total_weight += card.weight # Single value sum of all weights
		
	var roll = rng.randi_range(0, total_weight - 1)
	var cumulative = 0
	for card in candidates:
		cumulative += card.weight # compares with intervals (probabilities)
		if roll < cumulative:
			card_selected.emit(card)
			stored_current_card = card
			return	stored_current_card
	return


# --- Utilities Functions ---	
func apply_world_stat(effect) -> void:
	var key = effect.TARGET_KEYS.get(effect["target"])
	if key == null:
		push_error("Unknown stat target")
		return
	world_state[key] = world_state.get(key, 0) + effect["value"]
	
	
func show_first_card() -> void: 
	var card_resource = initial_card_list[0]
	stored_current_card = card_resource
	card_selected.emit(card_resource)
	#var card_picked = rng.randi_range(0,len(initial_card_list))
	#var card_resource = initial_card_list[card_picked]
	
func get_effects_in_memory(target)-> int:
	var target_map: Dictionary = {"Resources": 0, "Progress": 1, "Security": 2,"Moral": 3}
	if not target_map.has(target): return 0
	
	var target_id = target_map[target]
	var count: int = 0
	
	for entry in event_memory:
		if entry.get("choice") == 0:
			for effect in entry.get("left_effects"):
				#print("Left - ","Effect accurate target: ", effect.target, " Target ID: ", target_id)
				if effect.target == target_id:
					count += 1 if effect.value > 0 else 0
		elif entry.get("choice") == 1:
			for effect in entry.get("right_effects"):
				#print("Right - ","Effect accurate target: ", effect.target, " Target ID: ", target_id)

				if effect.target == target_id:
					count += 1 if effect.value > 0 else 0 # ver se é preciso por a 0 ao invés de -1
		#print("ID: ", target_id, "     Count: ", count,"\n")
	return count

# ----- Arc  Functions ----
func evaluate_arc_unlocks()-> void:
	check_ai_arc_unlock()
	check_alien_arc_unlock()
	check_rebellion_unlock()
	#check_terraform_unlock()

func progress_arc(current_card: Cards, choice_id: int)-> void: # ver quando chamar isto e o que fazer- > mudar as cartas antigas para "lixo" e mudar weight de p´roxima carta na seq
	var arc_map: Dictionary = { 1: "AI_Uprising",  2: "Aliens", 3: "Rebellion"}
	if current_card.arc == 0:
		return
		
	if choice_id == 0:
		for effect in current_card.left_effects:
			if effect.type == 1:				# Unlock to finish arc
				complete_arc(arc_map[current_card.arc])		
				available_cards_list.erase(current_card.id)
				return
				
	elif choice_id == 1:
		for effect in current_card.right_effects:
			if effect.type == 1:
				complete_arc(arc_map[current_card.arc])		
				available_cards_list.erase(current_card.id)
				return # return stops function to continue to next steps -> no cards added
					
	for cards in arc_cards_list: #adiciona a próxima carta à lista de disponíveis
		if cards.arc == current_card.arc:
			if cards.arc_progression == current_card.arc_progression + 1:	
				available_cards_list[cards.id] = cards
				available_cards_list.erase(current_card.id)
	
	active_arcs[arc_map[current_card.arc]] = current_card.arc_progression

func complete_arc(arc_name: String)-> void:
	active_arcs.erase(arc_name)
	completed_arcs.append(arc_name)
	print(arc_name + " completed")
	print_cue.emit(arc_name + " completed")

func arc_amount_limit(candidates: Array)-> void:		
	var arc_map: Dictionary = { 1: "AI_Uprising",  2: "Aliens", 3: "Rebellion"}
	if active_arcs.size() >= max_concurrent_arcs:
		for cards in candidates:
			if cards.arc != 0:
				if not active_arcs.has(arc_map[cards.arc]):
					candidates.erase(cards)

func print_arc_start() -> void:
	var arc_map: Dictionary = { 1: "AI_Uprising",  2: "Aliens", 3: "Rebellion"}
	
	if not active_arcs.has(stored_current_card.arc):
		if stored_current_card.arc_progression == 1:
			match stored_current_card.arc:
				1: 
					if not "AI" in first_print:
						active_arcs[arc_map[stored_current_card.arc]] = 1
						print("AI Uprising has Started")
						print_cue.emit("AI Uprising has Started")
						first_print.append("AI")
				2:
					if not "Alien" in first_print:
						active_arcs[arc_map[stored_current_card.arc]] = 1
						print("Alien Life Found")
						print_cue.emit("Alien Life Found")
						first_print.append("Alien")


				3:
					if not "Rebellion" in first_print:
						active_arcs[arc_map[stored_current_card.arc]] = 1
						print("Rebellion has Started")
						print_cue.emit("Rebellion has Started")
						first_print.append("Rebellion")


			
#region Arc Condition Functions ---- Show first card of arc?
func check_ai_arc_unlock() -> void: # Too much automation + low morale = AI becomes dominant.
	
	if active_arcs.has("AI_Uprising"):
		return
	if completed_arcs.has("AI_Uprising"):
		return

	if get_effects_in_memory("Progress") >= 30 and world_state.get("Moral") < -50:  
		active_arcs["AI_Uprising"] = 0 			# 0 = unlocked but has not appear yet
		for elements in available_cards_list:
			var card: Cards =  available_cards_list.get(elements)
			if card.arc == 1 and card.arc_progression == 1:
				card.weight = 24
				print("AI Uprising is coming")
				print_cue.emit("AI Uprising is coming")


func check_alien_arc_unlock() -> void: # Too much automation + low morale = AI becomes dominant.
	if active_arcs.has("Alien"):
		return
	if completed_arcs.has("Aien"):
		return

	if get_effects_in_memory("Progress") >= 75 and world_state.get("Resources") > 50:  
		active_arcs["Aliens"] = 0
		for elements in available_cards_list:
			var card: Cards =  available_cards_list.get(elements)
			if card.arc == 2 and card.arc_progression == 1:
				card.weight = 24
				print("Alien Lifeforms is coming")
				print_cue.emit("Alien Lifeforms is coming")

func check_rebellion_unlock() -> void: 
	if active_arcs.has("Rebellion"):
		return
	if completed_arcs.has("Rebellion"):
		return
		
	if get_effects_in_memory("Resources") <= 0  and world_state.get("Moral") < 0:	
		active_arcs["Rebellion"] = 0
		for elements in available_cards_list:
			var card: Cards =  available_cards_list.get(elements)
			if card.arc == 3 and card.arc_progression == 1:
				card.weight = 24
				print("Rebellion Arc is coming")	
				print_cue.emit("Rebellion Arc is coming")

func check_terraform_unlock() -> void:
	if active_arcs.has("Terraforming"):
		return
	if completed_arcs.has("Terraforming"):
		return

	if get_effects_in_memory("Progress") > 4 and world_state.get("Progress") > 60:
		active_arcs["Terraforming"] = 0
		print("Terraforming Arc Started")
#endregion

#endregion  
