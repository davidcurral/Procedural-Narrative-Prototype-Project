extends Control


var button_type = null

var memory: bool = true


func _on_play_pressed() -> void:
	#$GameChoicePanel.show()
	#_on_memory_game_pressed()
	_on_simple_game_pressed()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	button_type = "options"
	$FadeTransition.show()
	$FadeTransition/fade_timer.start()
	$FadeTransition/AnimationPlayer.play("fade_in")
	
	
# -- Play Buttons ----
func _on_memory_game_pressed() -> void:
	MainMenu.memory = true
	button_type = "start"
	$FadeTransition.show()
	$FadeTransition/fade_timer.start()
	$FadeTransition/AnimationPlayer.play("fade_in")

func _on_simple_game_pressed() -> void:
	MainMenu.memory = false
	button_type = "start"
	$FadeTransition.show()
	$FadeTransition/fade_timer.start()
	$FadeTransition/AnimationPlayer.play("fade_in")
	
	# --- Timer ---
func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	elif button_type == "options":
		get_tree().change_scene_to_file("res://Scenes/OptionsMenu.tscn")


func _on_play_exit_pressed() -> void:
	$GameChoicePanel.hide()
