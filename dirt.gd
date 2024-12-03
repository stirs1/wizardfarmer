extends StaticBody2D

signal water_state_changed(has_water: bool)

@onready var dirt_sprite = $dirt_sprite
@export var water_level: int = 4:
	set(value):
		var was_watered: bool = water_level > 0
		water_level = clampi(value, 0, 4)
		var is_watered: bool = water_level > 0
		
		if dirt_sprite:
			dirt_sprite.frame = water_level
			
		if was_watered != is_watered:
				water_state_changed.emit(is_watered)
			
func has_water() -> bool:
	return water_level > 0
