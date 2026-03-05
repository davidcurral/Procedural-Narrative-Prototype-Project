extends Resource
class_name Effect


# -- Common variables --
enum type_options {stat, flag, unlock}
enum target_options {resources, progress, security, moral, risk}
enum arc_options {no_arc, AI, Aliens, Rebellion}

const TARGET_KEYS = {
	target_options.resources: "Resources",
	target_options.progress: "Progress",
	target_options.security: "Security",
	target_options.moral: "Moral",
	target_options.risk: "Risk"

}


var card_id: int
var choice: String
@export var type: type_options
@export var target: target_options
@export var value: int
#@export var arc: arc_options 
var arc_chapter: Array = []
#@export var description := ""
