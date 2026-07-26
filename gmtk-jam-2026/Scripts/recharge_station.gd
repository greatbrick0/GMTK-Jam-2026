extends Node2D

var used: bool = false

func _ready() -> void:
	Reset()

func Reset() -> void:
	used = false

func _on_pressure_plate_area_body_entered(body):
	$AnimSprite.play("default")
	print("player detected")
