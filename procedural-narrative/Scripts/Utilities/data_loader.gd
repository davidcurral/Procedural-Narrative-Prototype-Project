@tool
extends Node

@export var build: bool = false:
	set(value):
		if value:
			if Engine.is_editor_hint():
				run()
				build = false

@onready var card_builder_dictionary: Dictionary = {}
@onready var effect_builder_dictionary: Dictionary = {}
var folder_path: = "res://Resources/Auto cards"



func run():
	var dir = DirAccess.open("res://Resources/Auto cards")
	for file in dir.get_files():
		dir.remove(file)
	
	card_builder_dictionary.clear()
	effect_builder_dictionary.clear()
	load_card()
	load_efect()
	link_effects_to_cards()
	#add_cards_to_main()
	print("Done\n")	
	
	
func load_card():
	var path = "res://Assets/Cards CSV/Cards.csv"
	if !FileAccess.file_exists(path):
		push_error("Cards.csv not found")
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	file.get_csv_line(";") # skip header

	while !file.eof_reached():
		var line = file.get_csv_line(";")
		var card = Cards.new()
		
		card.id = int(line[0])
		card.name = line[1]
		card.game_name = line[2]
		card.context = line[3]
		card.card_rarity = line[4]
		card.arc = arc_to_enum(line[5])
		if line[6] == 'TRUE' or line[6] == "true":
			card.available = true
		else:
			card.available = false
		card.base_weight = float(line[7])
		card.cooldown = int(line[8])
		card.arc_progression = int(line[9])
		card.left_discription = line[10]
		card.right_discription = line[11]

		card_builder_dictionary[card.id] = card

func load_efect():
	var path = "res://Assets/Cards CSV/Effects.csv"
	if !FileAccess.file_exists(path):
		push_error("Effects.csv not found")
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	file.get_csv_line(";") # skip header	
	
	while !file.eof_reached():
		var line = file.get_csv_line(";")
		var effect = Effect.new()
		effect.card_id = int(line[0])
		effect.choice = line[1]
		effect.type = type_to_enum(line[2])
		effect.target = target_to_enum(line[3])
		effect.value = float(line[4])
		#effect.extra = line[5]
		if effect.card_id not in effect_builder_dictionary:
			effect_builder_dictionary[effect.card_id] = []

		effect_builder_dictionary[effect.card_id].append(effect)

func link_effects_to_cards():
	for card in card_builder_dictionary.values():
		if card.id in effect_builder_dictionary:
			
			for effect in effect_builder_dictionary[card.id]:	
				if effect.card_id == card.id:
					match effect.choice:
						"left": 
							card.left_effects.append(effect)
						"right":
							card.right_effects.append(effect)
						"both":
							card.left_effects.append(effect)
							card.right_effects.append(effect)
						"_":
							pass
		# Save card as a real file
		var path = "res://Resources/Auto cards//%s.tres" % card.game_name
		#var formated_path = path % [card.id,card.game_name]
		ResourceSaver.save(card, path)
						
func add_cards_to_main():
	# This "open" method returns an instance for accessing your dir
	var dir := DirAccess.open(folder_path)
	var files := dir.get_files()
	
	var main_array = get_parent().card_list
	
	for file_name in files:
		# Optional: ignore non-tres files
		if not file_name.ends_with(".tres"):
			continue
		
		var full_path = folder_path + "/" + file_name
		var card_resource = load(full_path)
		main_array.append(card_resource)
		

static func type_to_enum(value: String) -> int:
	if value == "stat":
		return 0
	elif value == "flag":
		return 1
	elif value == "unlock":
		return 2
	elif value == "countdown":
		return 3
	return 0	
	
static func target_to_enum(value: String) -> int:
	if value == "resources":
		return 0
	elif value == "progress":
		return 1
	elif value == "security":
		return 2
	elif value == "moral":
		return 3
	elif value == "risk":
		return 4	
	elif value == "influence":
		return 5	
	return 6

static func arc_to_enum(value: String) -> int:
	if value == "no_arc":
		return 0
	elif value == "ai_arc":
		return 1
	elif value == "alien_arc":
		return 2
	elif value == "power_arc":
		return 3	
	return 0									
