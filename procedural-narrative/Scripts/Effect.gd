extends Resource
class_name Effect


# -- Common variables --
enum type_options {stat, flag, unlock}
enum target_options {resources, progress, security, moral, risk}
enum arc_options {no_arc, AI, Aliens, Authoritarian_ruler}

const TARGET_KEYS = {
	target_options.resources: "Resources",
	target_options.progress: "Progress",
	target_options.security: "Security",
	target_options.moral: "Moral",
	target_options.risk: "Risk"

}
const ARC_KEYS = {
	arc_options.AI: "AI Arc",
	arc_options.Aliens: "Alien Life Form",
	arc_options.Authoritarian_ruler: "Authoritarian Ruler",
	#arc_options.Rebellion: "Rebellion"
}

var card_id: int
var choice: String
@export var type: type_options
@export var target: target_options
@export var value: int
@export var arc: arc_options = 0
var arc_chapter: Array = []
#@export var description := ""
