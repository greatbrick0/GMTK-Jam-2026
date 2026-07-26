extends Node2D

var used: bool = false

func _ready() -> void:
	Reset()

func Reset() -> void:
	used = false
	$AnimSprite.frame = 0
	$Timer.start()

func _on_pressure_plate_area_body_entered(body):
	if(not used):
		used = true
		body.BumpCanMove(false)
		$AnimSprite.play("default")
		$Audio2D.play()
		$Audio2D2.play()
		Hud.instance.GetCountDownAmountsForRefill()
		await Hud.instance.PlayRefillAnim()
		body.BumpCanMove(true)

func _on_timer_timeout():
	$PressurePlateArea/CollisionPolygon2D.set_deferred("disabled", false)
