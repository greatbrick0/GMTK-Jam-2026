extends Node2D
class_name Level

@export var floorLayer: TileMapLayer
@export var playerLayer: TileMapLayer

func _ready() -> void:
	for ii in floorLayer.get_used_cells():
		if(floorLayer.get_cell_source_id(ii) != -1):
			for jj in floorLayer.get_surrounding_cells(ii):
				if(floorLayer.get_cell_source_id(jj) == -1):
					floorLayer.set_cell(jj, 0, Vector2i(2, 1))

func RemovePlayer(player: Player) -> void:
	playerLayer.remove_child(player)
