extends Node2D

@export var spriteIndex: int = 0
var spriteRef: AnimatedSprite2D
@export var maxStability: float = 3.0
var stability: float = 1.0
var drillRate: float = 0.0
var broken: bool = false

func _ready() -> void:
	stability = maxStability
	for ii in range($Sprites/ShakeOffset.get_child_count()):
		$Sprites/ShakeOffset.get_child(ii).visible = ii == spriteIndex
	spriteRef = $Sprites/ShakeOffset.get_child(spriteIndex)

func _process(delta) -> void:
	if(Input.is_action_just_pressed("ability_0")):
		Drill(1.0)
	if(not broken):
		if(drillRate > 0.0):
			stability -= drillRate * delta
			$Sprites/ShakeOffset.position.x = sin(stability * 5) * 0.2
			$Sprites/ShakeOffset.position.y = cos(stability * 25 + global_position.x) * 0.3
			if(stability <= 0.0):
				Break()
		else:
			if(!spriteRef.is_playing()):
				spriteRef.play("default")

func Reset() -> void:
	stability = maxStability
	broken = false
	$Sprites.visible = true
	Drill(0.0)
	$StaticBody2D/CollisionPolygon2D.set_deferred("disabled", false)

func Drill(newRate: float) -> void:
	drillRate = newRate
	if(drillRate == 0.0):
		$Sprites/ShakeOffset.position = Vector2.ZERO
	else:
		spriteRef.stop()

func Break() -> void:
	broken = true
	$Sprites.visible = false
	$Crumble2D.play()
	$StaticBody2D/CollisionPolygon2D.set_deferred("disabled", true)
