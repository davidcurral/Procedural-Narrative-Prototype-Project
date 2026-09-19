extends Resource
class_name Effect


# -- Common variables --
enum type_options {stat, unlock, flag}
enum target_options {resources, progress, security, moral, risk, influence, none}
enum arc_options {no_arc, AI, Aliens, Rebellion}

const TARGET_KEYS = {
	target_options.resources: "Resources",
	target_options.progress: "Progress",
	target_options.security: "Security",
	target_options.moral: "Moral",
	target_options.risk: "Risk",
	target_options.influence: "Influence",
	target_options.none : " "

}


var card_id: int
var choice: String
@export var type: type_options
@export var target: target_options
@export var value: int
@export var arc: arc_options 
var arc_chapter: Array = []
#@export var description := ""



#region Rename Resource print
# Override this method to change how the resource prints
func _to_string() -> String:
	return "%s_%s_%d" % [type_options.keys()[type],target_options.keys()[target],value]

#endregion 
