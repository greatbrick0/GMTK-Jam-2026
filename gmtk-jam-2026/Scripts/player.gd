extends CharacterBody2D

@export var speed: float = 45
@export var canMove: bool = false
var distortion: Vector2 = Vector2(2, 1)

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(direction and canMove):
		velocity = direction.normalized() * distortion * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
