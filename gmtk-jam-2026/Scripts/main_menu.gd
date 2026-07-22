extends Node2D

@export var levelPath: String = "res://Scenes/open_level.tscn"

func _on_start_button_pressed():
	get_tree().change_scene_to_file(levelPath)
