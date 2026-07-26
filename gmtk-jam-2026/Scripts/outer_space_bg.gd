extends Node2D

var followRef: Node2D

func _process(_delta):
	if(followRef):
		global_position = followRef.global_position
	else:
		followRef = get_tree().get_first_node_in_group("Player")
