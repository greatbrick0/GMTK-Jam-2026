extends Node2D
class_name Gate

@export var spriteIndex: int = 0
var spriteRef: AnimatedSprite2D
@export var inverted: bool = false

func _ready():
	for ii in range($Sprites.get_child_count()):
		$Sprites.get_child(ii).visible = ii == spriteIndex
	spriteRef = $Sprites.get_child(spriteIndex)
	spriteRef.frame_changed.connect(FrameChanged)
	Reset()

func Activate(newValue: bool) -> void:
	if(not inverted and newValue):
		spriteRef.play("default")
	else:
		spriteRef.play_backwards("default")

func FrameChanged() -> void:
	var result: bool = spriteRef.frame == spriteRef.sprite_frames.get_frame_count("default") - 1
	if(result != $StaticBody2D/CollisionPolygon2D.disabled):
		$StaticBody2D/CollisionPolygon2D.set_deferred("disabled", result)
		$Sprites.z_index = int(result) * -1

func Reset():
	if(not inverted):
		spriteRef.frame = 0
	else:
		spriteRef.frame = spriteRef.sprite_frames.get_frame_count("default") - 1
