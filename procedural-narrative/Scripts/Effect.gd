extends Resource
class_name Effect


# -- Common variables --
enum type_options {stat, flag, unlock}
enum target_options {church, people, wealth, army}
enum arc_options {no_arc, Empowered_Church, People_Famine, Dragon_Gold, Rebellion}

const TARGET_KEYS = {
	target_options.church: "church",
	target_options.people: "people",
	target_options.wealth: "wealth",
	target_options.army: "army"
}
const ARC_KEYS = {
	arc_options.Empowered_Church: "Empowered Church",
	arc_options.People_Famine: "People Famine",
	arc_options.Dragon_Gold: "Dragon Gold",
	arc_options.Rebellion: "Rebellion"
}


@export var type: type_options
@export var target: target_options
@export var value: int
@export var arc: arc_options = 0
var arc_chapter: Array = []
@export var description := ""
