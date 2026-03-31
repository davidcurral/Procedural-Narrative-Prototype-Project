extends Resource
class_name Cards

'''
Types of effects
(type: "stat", target: "church", value: +10)
(type: "flag", target: "angered_church", value: true)
(type: "unlock", target: "inquisition_arc")

'''

enum card_rarity_options {common, rare, epic}
enum arc_options {no_arc, AI, Aliens, Authoritarian_ruler}

const ARC_KEYS = {
	arc_options.AI: "AI Arc",
	arc_options.Aliens: "Alien Life Form",
	arc_options.Authoritarian_ruler: "Authoritarian Ruler",
	#arc_options.Rebellion: "Rebellion"
}

@export var id: int
@export var name: String = ''
var game_name: String = ''
@export var context: String = ''
@export var card_rarity: card_rarity_options
@export var available: bool = true
@export var base_weight: float
var weight: int:
	get:
		return ceil(base_weight / (1 + card_rarity))
		
@export var arc: arc_options 
@export var arc_progression: int = 0
@export var cooldown: int


@export var left_effects: Array[Effect]
@export var left_discription: String = 'Left Discription'
@export var right_effects: Array[Effect]
@export var right_discription: String = 'Right Discription'




#region Rename Resource print
# Override this method to change how the resource prints
func _to_string() -> String:
	return "%d_%s" % [id, name]

#endregion 
