extends TileMapLayer

func _ready() -> void:
	
	# DEBUG: 
	var ForestInfo = get_cell_atlas_coords(Vector2(22, 7))
	var ForestInfo2 = get_cell_source_id(Vector2(22, 7))
	print("TILEMAPLAYER: atlas coords = ", ForestInfo)
	print("TILEMAPLAYER: source id = ", ForestInfo2)
	
func _process(delta: float) -> void:
	pass
