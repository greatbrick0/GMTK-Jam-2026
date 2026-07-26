extends AnimatedSprite2D




func _on_train_win_area_body_entered(body):
	print("hello")
	get_tree().change_scene_to_file("res://scenes/win_scene_1.tscn")
