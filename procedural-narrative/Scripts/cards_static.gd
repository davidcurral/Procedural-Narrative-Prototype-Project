extends Node

#@export var initial_card_list: Array[Cards]
@onready var database = load("res://Resources/card_database.tres")
@export var max_concurrent_arcs: int = 2
