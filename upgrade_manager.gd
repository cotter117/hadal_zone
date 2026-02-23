extends Node

signal upgrade_applied(upgrade_type: String)

var player_stats = {
	"damage_multiplier": 1.0,
	"fire_rate_multiplier": 1.0,
	"speed_multiplier": 1.0,
	"max_health_bonus": 0,
	"magnet_range_bonus": 0,
	"weapon_speed_multiplier": 1.0
}

func apply_upgrade(upgrade_type: String):
	match upgrade_type:
		"damage":
			player_stats.damage_multiplier += 0.2
		"fire_rate":
			player_stats.fire_rate_multiplier += 0.3
		"speed":
			player_stats.speed_multiplier += 0.15
		"health":
			player_stats.max_health_bonus += 20
		"magnet":
			player_stats.magnet_range_bonus += 15
		"weapon":
			player_stats.weapon_speed_multiplier += 5
	
	upgrade_applied.emit(upgrade_type)

func get_stat(stat_name: String):
	if player_stats.has(stat_name):
		return player_stats[stat_name]
	else:
		# Return default values for missing keys
		match stat_name:
			"fire_rate_multiplier", "speed_multiplier", "weapons_speed_multiplier", "damage_multiplier":
				return 1.0
			"max_health_bonus", "magnet_range_bonus":
				return 0
			_:
				return 1.0

func reset_stats():
	player_stats.clear()
	player_stats = {
		"damage_multiplier": 1.0,
		"fire_rate_multiplier": 1.0,
		"speed_multiplier": 1.0,
		"max_health_bonus": 0,
		"magnet_range_bonus": 0,
		"weapon_speed_multipler": 1.0
	}
