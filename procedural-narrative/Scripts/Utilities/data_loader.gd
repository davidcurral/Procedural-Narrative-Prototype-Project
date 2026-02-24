extends Node

'''
read cards.csv
read effects.csv
build CardData objects
return dictionary of cards
'''
@onready var card_builder_dictionary: Dictionary = {}
@onready var effect_builder_dictionary: Dictionary = {}
var folder_path: = "res://Resources/auto cards"


func _enter_tree():
	load_card()
	load_efect()
	link_effects_to_cards()
	add_cards_to_main()
	print("Done\n")	
	
	
func load_card():
	var path = "res://Assets/Cards CSV/Cards_test.csv"
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
		card.arc = line[5]
		if line[6] == 'true':
			card.available = true
		else:
			card.available = false
		card.weight = float(line[7])
		card.cooldown = int(line[8])
		card_builder_dictionary[card.id] = card

func load_efect():
	var path = "res://Assets/Cards CSV/Effects_test.csv"
	if !FileAccess.file_exists(path):
		push_error("Cards.csv not found")
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	file.get_csv_line(";") # skip header	
	
	while !file.eof_reached():
		var line = file.get_csv_line(";")
		var effect = Effect.new()
		effect.card_id = int(line[0])
		effect.choice = line[1]
		effect.type = line[2]
		effect.target = line[3]
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
		# Save card as a real file
		var path = "res://Resources/auto cards//%s.tres" % card.game_name
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
		print(main_array)
		
		
								
