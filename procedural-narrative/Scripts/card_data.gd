extends Resource
class_name Cards

'''
Types of effects
(type: "stat", target: "church", value: +10)
(type: "flag", target: "angered_church", value: true)
(type: "unlock", target: "inquisition_arc")

'''

enum card_rarity_options {common, rare, epic}

@export var id: int
@export var name: String = ''
var game_name: String = ''
@export var context: String = ''
@export var card_rarity: card_rarity_options
@export var available: bool = true
var weight: float
var arc: float
var cooldown: float


@export var left_effects: Array[Effect]
@export var left_description: String = ''
@export var right_effects: Array[Effect]
@export var right_description: String = ''

var left_effect: Array = []
var right_effect: Array = []

'''
# -- Left Variables --
# -- 1º Effect--
@export_group("Left Group")
@export_subgroup("1º Effect")
@export var left_card_type_1: type_options
@export var left_card_target_1: target_options
@export var left_card_number_value_1: int
@export var card_discription_left_1: String = ''

# -- 2º Effect--
@export_subgroup("2º Effect")
@export var left_card_type_2: type_options
@export var left_card_target_2: target_options
@export var left_card_number_value_2: int
@export var card_discription_left_2: String = ''

# -- Right Variables --
# -- 1º Effect--
@export_group("Right Group")
@export_subgroup("1º Effect")
@export var right_card_type_1: type_options
@export var right_card_target_1: target_options
@export var right_card_number_value_1: int
@export var card_discription_right_1: String = ''

# -- 2º Effect--
@export_subgroup("2º Effect")
@export var right_card_type_2: type_options
@export var right_card_target_2: target_options
@export var right_card_number_value_2: int
@export var card_discription_right_2: String = ''



func build_effects():

	left_effects = [
	{"type": left_card_type_1, "target": left_card_target_1, "value": left_card_number_value_1,"Description": card_discription_left_1},
	{"type": left_card_type_2, "target": left_card_target_2, "value": left_card_number_value_2,"Description": card_discription_left_2}
	]

	right_effects = [
	{"type": right_card_type_1, "target": right_card_target_1, "value": right_card_number_value_1,"Description": card_discription_right_1},
	{"type": right_card_type_2, "target": right_card_target_2, "value": right_card_number_value_2,"Description": card_discription_right_2}
	]
'''
