extends StaticBody2D

signal water_state_changed(has_water: bool)

@onready var dirt_sprite = $dirt_sprite

var water_level: int = 4
	
func set_water_level(new_value: int) -> void:
		var was_watered: bool = water_level > 0
		water_level = clampi(new_value, 0, 4)
		var is_watered: bool = water_level > 0
		
		dirt_sprite.frame = water_level
		
		if was_watered != is_watered:
			water_state_changed.emit(is_watered)
			
func has_water() -> bool:
	return water_level > 0
