extends CharacterBody2D
class_name Player

@export var speed: float = 45
var speedMult: float = 1.0
@export var drainSpeed: float = 1.0
@export var canMove: bool = false
var distortion: Vector2 = Vector2(2, 1)

var countDownRef: CountDown

func _ready():
	countDownRef = get_tree().get_first_node_in_group("Countdown")
	countDownRef.outOfSteps.connect(SetCanMove.bind(false))

func _physics_process(delta):
	speedMult = 2.5 if(Input.is_action_pressed("sprint")) else 1.0
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(direction and canMove):
		velocity = direction.normalized() * distortion * speed * speedMult
		countDownRef.DrainSteps(speedMult * drainSpeed * delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func SetCanMove(newCanMove: bool) -> void:
	canMove = newCanMove

func _on_interact_area_area_entered(area):
	pass # Replace with function body.
