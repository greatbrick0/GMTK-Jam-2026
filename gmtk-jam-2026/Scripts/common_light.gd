extends Sprite2D
class_name CommonLight

@export var visibleOnReady: bool = true
@export var followTarget: Node2D
@export var followOffset: Vector2 = Vector2.ZERO
var doesFollowTarget: bool = false

func _ready():
	if(visibleOnReady):
		visible = true
	doesFollowTarget = followTarget != null

func _process(delta):
	if(doesFollowTarget):
		global_position = followTarget.global_position + followOffset
	$ChildSprites.rotate(0.3 * delta)
