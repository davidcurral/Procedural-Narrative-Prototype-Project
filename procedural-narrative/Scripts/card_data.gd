extends Resource
class_name Cards

'''
Types of effects

(type: "stat", target: "church", value: +10)
(type: "flag", target: "angered_church", value: true)
(type: "unlock", target: "inquisition_arc")

'''

enum card_rarity_options {common, rare, epic}
@export var card_rarity: card_rarity_options

@export var name: String = ''
@export var id: int

@export var available: bool = true
@export var weight: float

var left_effects: Array = []
var right_effects: Array = []


# -- Common variables --
enum type_options {stat, flag, unlock}
enum target_options {church, people, wealth, army}

# -- Left Variables --
@export_group("Left Group")
@export var left_card_type: type_options
@export var left_card_target: target_options
@export var left_card_number_value: int

#enum value_options {int, bool}  # ask if it is possible to choose
#@export var card_value: value_options


# -- Right Variables --
@export_group("Right Group")
@export var right_card_type: type_options
@export var right_card_target: target_options
@export var right_card_number_value: int

func _init():
	left_effects = [
	#{ card_type: "stat", card_target: "wealth", card_value : card_number_value },
	{"type": left_card_type, "target": left_card_target, "value": left_card_number_value }#,
	#{ card_type: "flag", card_target: "angered_church", card_value : true}
	]

	right_effects = [
	#{ card_type: "stat", card_target: "army", "value": card_number_value }
	{"type": right_card_type, "target": right_card_target, "value": right_card_number_value }]
