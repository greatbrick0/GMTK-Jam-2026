extends Camera2D

@export var trackedObject : Node2D

func _process(_delta):
	global_position = trackedObject.global_position
