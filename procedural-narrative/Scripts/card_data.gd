extends Resource

class_name Cards

enum card_rarity_options {common, rare, epic}
@export var card_rarity: card_rarity_options

@export var name: String = ''
@export var id: int

@export var available: bool = true
@export var visible: bool = true

#@export var weight: float


@export var value0: float
@export var value1: float
@export var value2: float
