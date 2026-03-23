extends Node

@export var runs: int = 100
@export var turns_per_run: int = 100
@export var use_memory: bool = true   # Toggle A/B test

var rng = RandomNumberGenerator.new()

# Logs
var log_rows: Array[String] = []
var summary_rows: Array[String] = []
var card_frequency_rows: Array[String] = []


func _ready():
	run_experiments()
	save_csv()
	print("Simulation complete.")


#region MAIN LOOP
func run_experiments():
	
	# CSV headers
	log_rows.append("run,turn,card_id,choice,wealth,morale,stability,progress")
	summary_rows.append("run,unique_cards,repetitions,final_wealth,final_morale,final_stability,final_progress")
	card_frequency_rows.append("run,card_id,card_frequency")

	for run_id in range(runs):
		var game_state = GameStateSimulation.new()
		game_state.initialize()
		
		var last_cards: Array = []
		var card_diversity: Array = []
		var repetition_score: int = 0
		var distribution_cards: Dictionary = {}
		
		for turn in range(turns_per_run):
			var card = game_state.pick_next_card()
		
			if card == null:
				break
			
			var choice = simulate_choice()
			
			distribution_cards[card.id] += 1
			
			# Track repetition (last 10 turns)
			if last_cards.has(card.id):
				repetition_score += 1
			
			last_cards.append(card.id)
			if last_cards.size() > 10:
				last_cards.pop_front()
			
			# Track unique cards
			if not card_diversity.has(card.id):
				card_diversity.append(card.id)
			
			# Apply effects
			#game.play_card(card, choice)
			game_state.process_card(choice)
			
			# Log turn
			log_rows.append("%d,%d,%d,%s,%d,%d,%d,%d" % [
				run_id,
				turn,
				card.id,
				choice,
				game_state.world_state.get("wealth", 0),
				game_state.world_state.get("morale", 0),
				game_state.world_state.get("stability", 0),
				game_state.world_state.get("progress", 0)
			])
		
		# Summary per run
		summary_rows.append("%d,%d,%d,%d,%d,%d,%d" % [
			run_id,
			card_diversity.size(),
			repetition_score,
			game_state.world_state.get("wealth", 0),
			game_state.world_state.get("morale", 0),
			game_state.world_state.get("stability", 0),
			game_state.world_state.get("progress", 0)
		])
		print("Run: ", run_id)


#endregion

func simulate_choice():
	return [0, 1].pick_random()

#region SAVE CSV
func save_csv():
	
	var log_file = FileAccess.open("user://Data/simulation_log.csv", FileAccess.WRITE)
	for row in log_rows:
		log_file.store_line(row)
	
	var summary_file = FileAccess.open("user://Data/simulation_summary.csv", FileAccess.WRITE)
	for row in summary_rows:
		summary_file.store_line(row)
		
	var frequency_file = FileAccess.open("user://Data/simulation_card_frequency.csv", FileAccess.WRITE)
	for row in card_frequency_rows:
		frequency_file.store_line(row)
	
#endregion


func _on_button_pressed() -> void:
	pass # Replace with function body.
