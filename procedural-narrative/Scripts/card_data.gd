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

const TARGET_KEYS = {
	target_options.church: "church",
	target_options.people: "people",
	target_options.wealth: "wealth",
	target_options.army: "army"
}

# -- Left Variables --
# -- 1º Effect--
@export_group("Left Group")
@export_subgroup("1º Effect")
@export var left_card_type_1: type_options
@export var left_card_target_1: target_options
@export var left_card_number_value_1: int

# -- 2º Effect--
@export_subgroup("2º Effect")
@export var left_card_type_2: type_options
@export var left_card_target_2: target_options
@export var left_card_number_value_2: int


# -- Right Variables --
# -- 1º Effect--
@export_group("Right Group")
@export_subgroup("1º Effect")
@export var right_card_type_1: type_options
@export var right_card_target_1: target_options
@export var right_card_number_value_1: int

# -- 2º Effect--
@export_subgroup("2º Effect")
@export var right_card_type_2: type_options
@export var right_card_target_2: target_options
@export var right_card_number_value_2: int


func build_effects():
	left_effects = [
	{"type": left_card_type_1, "target": left_card_target_1, "value": left_card_number_value_1},
	{"type": left_card_type_2, "target": left_card_target_2, "value": left_card_number_value_2}
	]

	right_effects = [
	{"type": right_card_type_1, "target": right_card_target_1, "value": right_card_number_value_1 },
	{"type": right_card_type_2, "target": right_card_target_2, "value": right_card_number_value_2 }
	]
