extends Node

@export var runs: int
@export var turns_per_run: int
@export var use_memory: bool   # Toggle A/B test

var rng = RandomNumberGenerator.new()

# Logs
var log_rows: Array[String] = []
var summary_rows: Array[String] = []
var card_frequency_rows: Array[String] = []


func _ready():
	var dir = DirAccess.open("res://Data/")
	for file in dir.get_files():
		dir.remove(file)
		
	run_experiments()
	if use_memory == true:
		with_memory_save_csv()
	else:
		no_memory_save_csv()
		
	print("Simulation complete.")


#region MAIN LOOP
func run_experiments():
	
	# CSV headers
	log_rows.append("run,turn,card_id,choice,resources,security,moral,progress")
	summary_rows.append("run,unique_cards,repetitions,final_resources,final_security,final_moral,final_progress")
	card_frequency_rows.append("run,card_id,card_frequency")

	for run_id in range(runs):
		var game_state = GameStateSimulation.new() # This Game state cannot be an autoload to work
		game_state.set_static_data(use_memory)
		game_state.initialize()
		
		var last_cards: Array = []
		var card_diversity: Array = []
		var repetition_score: int = 0
		var distribution_cards: Dictionary = {}
		print("Run: ", run_id,)
		
		for turn in range(turns_per_run):
			var card = game_state.pick_next_card()
			
			if card == null:
				break
			
			var choice = simulate_choice()
			
			if not distribution_cards.has(card.id):
				distribution_cards[card.id] = 1
			else:
				distribution_cards[card.id] += 1
			
			# Track repetition (last 100 turns)
			if last_cards.has(card.id):
				repetition_score += 1
			
			last_cards.append(card.id)
			if last_cards.size() > 100:
				last_cards.pop_front()
			
			# Track unique cards
			if not card_diversity.has(card.id):
				card_diversity.append(card.id)
			
			# Apply effects
			#game.play_card(card, choice)
			game_state.card_processing(choice)
			
			# Log turn
			log_rows.append("%d,%d,%d,%s,%d,%d,%d,%d" % [
				run_id,
				turn,
				card.id,
				choice,
				game_state.world_state.get("Resources", 0),
				game_state.world_state.get("Security", 0),
				game_state.world_state.get("Moral", 0),
				game_state.world_state.get("Progress", 0)
			])
			
		#Card frequency
		for card_id in distribution_cards:
			var count = distribution_cards[card_id]
			card_frequency_rows.append("%d,%s,%d" % [run_id, card_id, count])
		
		# Summary per run
		summary_rows.append("%d,%d,%d,%d,%d,%d,%d" % [
			run_id,
			card_diversity.size(),
			repetition_score,
			game_state.world_state.get("Resources", 0),
			game_state.world_state.get("Security", 0),
			game_state.world_state.get("Moral", 0),
			game_state.world_state.get("Progress", 0)
		])
		
		

#endregion

func simulate_choice():
	return [0, 1].pick_random()

#region SAVE CSV
func no_memory_save_csv():
	
	var log_file = FileAccess.open("res://Data/no_memory_sim_log.txt", FileAccess.WRITE)	
	for row in log_rows:
		log_file.store_line(row) #writes a string followed by a newline character (\n)
	
	var frequency_file = FileAccess.open("res://Data/no_memory_sim_card_frequency.txt", FileAccess.WRITE)
	for row in card_frequency_rows:
		frequency_file.store_line(row)
		
	var summary_file = FileAccess.open("res://Data/no_memory_sim_summary.txt", FileAccess.WRITE)
	for row in summary_rows:
		summary_file.store_line(row)

func with_memory_save_csv():
	
	var log_file = FileAccess.open("res://Data/with_memory_sim_log.txt", FileAccess.WRITE)	
	for row in log_rows:
		log_file.store_line(row) #writes a string followed by a newline character (\n)
	
	var frequency_file = FileAccess.open("res://Data/with_memory_sim_card_frequency.txt", FileAccess.WRITE)
	for row in card_frequency_rows:
		frequency_file.store_line(row)
		
	var summary_file = FileAccess.open("res://Data/with_memory_sim_summary.txt", FileAccess.WRITE)
	for row in summary_rows:
		summary_file.store_line(row)
#endregion


func _on_button_pressed() -> void:
	pass # Replace with function body.
