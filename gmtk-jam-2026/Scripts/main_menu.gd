extends Node2D

@export var levelPath: String = "res://Scenes/open_level.tscn"

func _on_start_button_pressed():
	MusicManager.ChangeTrack(1)
	get_tree().change_scene_to_file(levelPath)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
