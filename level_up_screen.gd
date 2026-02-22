extends Control

@onready var card_container = $CardContainer
@onready var level_label = $LevelLabel

var upgrade_cards = [
	{"name": "Fire Rate +", "description": "Shoot faster", "type": "fire_rate"},
	{"name": "Speed +", "description": "Move faster", "type": "speed"},
	{"name": "Health +", "description": "Increase max health", "type": "health"},
	{"name": "Magnet +", "description": "Larger XP pickup range", "type": "magnet"}
]

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	if XpManager:
		XpManager.level_up.connect(_on_level_up)

func _on_level_up(new_level: int):
	show_level_up_screen(new_level)

func show_level_up_screen(level: int):
	get_tree().paused = true
	visible = true
	level_label.text = "LEVEL " + str(level)
	
	# Clear previous cards
	for child in card_container.get_children():
		child.queue_free()
	
	# Show 3 random upgrade cards
	var available_upgrades = upgrade_cards.duplicate()
	available_upgrades.shuffle()
	
	for i in range(3):
		create_upgrade_card(available_upgrades[i], i)

func create_upgrade_card(upgrade_data: Dictionary, index: int):
	var card = Button.new()
	card.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	card.text = upgrade_data.name + "\n" + upgrade_data.description
	card.custom_minimum_size = Vector2(200, 100)
	card.pressed.connect(_on_card_selected.bind(upgrade_data))
	card_container.add_child(card)

func _on_card_selected(upgrade_data: Dictionary):
	apply_upgrade(upgrade_data)
	hide_level_up_screen()

func apply_upgrade(upgrade_data: Dictionary):
	UpgradeManager.apply_upgrade(upgrade_data.type)

func hide_level_up_screen():
	visible = false
	get_tree().paused = false
