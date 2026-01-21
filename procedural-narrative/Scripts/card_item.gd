extends Node

var card_data

@onready var name_label = $Panel/VBoxContainer/Name
@onready var val0 = $Panel/VBoxContainer/Description/VBoxContainer/Val0
@onready var val1 = $Panel/VBoxContainer/Description/VBoxContainer/Val1
@onready var val2 = $Panel/VBoxContainer/Description/VBoxContainer/Val2



func setup(_card_data):
	card_data = _card_data
	Update_Card_UI()
	
func Update_Card_UI():
	name_label.text = card_data.name
	val0.text = "Value 0 : " + str(card_data.value0)
	val1.text = "Value 1 : " + str(card_data.value1)
	val2.text = "Value 2 : " + str(card_data.value2)
