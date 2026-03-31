@tool
extends Node

@export var database: CardDatabase
@export var build: bool = false:
	set(value):
		if value:
			if Engine.is_editor_hint():
				build_database()
				build = false
			
			
func build_database():
	print("Buidling")
	database.card_list.clear()
	var dir := DirAccess.open("res://Resources/Auto cards/")
	for file in dir.get_files():
		if file.ends_with(".tres"):
			var card = load("res://Resources/Auto cards/" + file)
			print("Cards: ", card)
			database.card_list.append(card)
		
	print("After append:", database.card_list.size())
	ResourceSaver.save(database, "res://Resources/")
	notify_property_list_changed()
