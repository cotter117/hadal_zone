extends ProgressBar

func _ready():
	if XpManager:
		XpManager.xp_changed.connect(_on_xp_changed)
		_on_xp_changed(XpManager.current_xp, XpManager.xp_needed)

func _on_xp_changed(current_xp: int, xp_needed: int):
	max_value = xp_needed
	value = current_xp
