extends Node2D

@export var levelPath: String = "res://scenes/open_level.tscn"

func _on_start_button_pressed():
	MusicManager.ChangeTrack(1)
	MusicManager.PlayGeneral(1)
	get_tree().change_scene_to_file(levelPath)

func _process(delta):
	if(Input.is_action_just_pressed("think")):
		Hud.isOnMobile = true
