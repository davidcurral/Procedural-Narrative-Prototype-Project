
extends Node
'''
Cartas que serão Mostradas no HUD

Main emits choice made
'''

#@export var card_scene: PackedScene
#@export var card_list: Array[Cards] = []
@export var initial_card_list: Array[Cards]
@export var database: CardDatabase
@export var max_concurrent_arcs: int = 2


@onready var card_node = $ScenePanel/Cards

#var choice_id
var right_choice
var left_choice
const LEFT_CHOICE = 0
const RIGHT_CHOICE = 1


#-- World Variables -- 
@onready var world_val1 = $ScenePanel/Panel/VBoxContainer/Control1
@onready var world_val2 = $ScenePanel/Panel/VBoxContainer/Control2
@onready var world_val3 = $ScenePanel/Panel/VBoxContainer/Control3
@onready var world_val4 = $ScenePanel/Panel/VBoxContainer/Control4
@onready var turns = $ScenePanel/Turns
@onready var fade_anim = $FadeTransition/AnimationPlayer

func _ready():
	if $FadeTransition.visible == true:
		$FadeTransition/fade_timer.start()
		$FadeTransition.show()
		fade_anim.play("fade_out")

	GameState.card_selected.connect(updateUI)
	GameState.set_static_data(database.card_list, initial_card_list, max_concurrent_arcs)	
	GameState.world_change.connect(world_UI)
	GameState.initialize()


func updateUI(card_resource):
		card_node.setup(card_resource)
		world_UI()
		world_progress_bar()

func world_UI():
	world_val1.get_child(0).text = "Resources: " + str(GameState.world_state.get("Resources"))
	world_val2.get_child(0).text = "Security:  " + str(GameState.world_state.get("Security"))
	world_val3.get_child(0).text = "Moral:  " + str(GameState.world_state.get("Moral"))
	world_val4.get_child(0).text = "Progress:  " + str(GameState.world_state.get("Progress"))

	turns.text = str(GameState.current_turn)

func world_progress_bar():
	world_val1.get_child(1).value = GameState.world_state.get("Resources")
	world_val2.get_child(1).value = GameState.world_state.get("Security")
	world_val3.get_child(1).value = GameState.world_state.get("Moral")
	world_val4.get_child(1).value = GameState.world_state.get("Progress")


func _on_next_card_pressed(choice_id) -> void:
	GameState.choice_made.emit(choice_id)

func _on_right_choice_pressed() -> void:
	_on_next_card_pressed(RIGHT_CHOICE)

func _on_left_choice_pressed() -> void:
	_on_next_card_pressed(LEFT_CHOICE)


func _on_memory_print() -> void:
	print("Event Memory: ", GameState.event_memory)


func _on_check_arcs_pressed() -> void:
	print("\n","Active Arcs: ", GameState.active_arcs)
	print("Locked Arcs: ", GameState.locked_arcs)
	print("Completed Arcs: ", GameState.completed_arcs,"\n")


func _on_available_cards_pressed() -> void:
	print("Available Cards: ",GameState.available_cards_list,"\n")


func _on_arc_cards_list_pressed() -> void:
	print("Arc Lis: ", GameState.arc_cards_list, "\n")


func _on_fade_timer_timeout() -> void:
	$FadeTransition.hide()
