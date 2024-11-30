extends TileMapLayer

var f_dtag = ("FOREST: ")
var c_check: Vector2 = Vector2(22, 7)

func _ready() -> void:
	
	# DEBUG: 
	var ForestInfo = get_cell_atlas_coords(c_check)
	var ForestInfo2 = get_cell_source_id(c_check)
	var ForestInfo3 = get_cell_tile_data(c_check)
	
	print(f_dtag, "atlas coords = ", ForestInfo)
	print(f_dtag, "source id = ", ForestInfo2)
	print(f_dtag, "cell tile data = ", ForestInfo3)
	
	# TODO: implement this as part of larger feature
	if is_tile_water(c_check):
		print(f_dtag, "there is water at ", c_check)
	else:
		print(f_dtag, "can't find water at ", c_check)
		
func _process(delta: float) -> void:
	pass

func is_tile_water(coords: Vector2i) -> bool:
	var ForestInfo4 = get_cell_tile_data(coords)
	if ForestInfo4 == null:
		return false
	return ForestInfo4.get_custom_data("is_water")
			
