extends CharacterBody2D
class_name Player

@export var speed: float = 45
var speedMult: float = 1.0
@export var drainSpeed: float = 1.0
@export var canMove: bool = false
var distortion: Vector2 = Vector2(2, 1)

var interactList: Array[Interactable]

var countDownRef: CountDown

var resetting: float = 0.0
var resetThreshold

func _ready():
	countDownRef = get_tree().get_first_node_in_group("Countdown")
	countDownRef.outOfSteps.connect(SetCanMove.bind(false))

func _process(delta):
	if(Input.is_action_pressed("reset") and canMove):
		resetting += 1.0 * delta
		if(resetting >= 0.5):
			Hud.instance.EndLoop()
	else:
		resetting = 0.0
	if(Input.is_action_just_pressed("interact") and canMove):
		if(len(interactList) > 0):
			GetClosestInteractable().Interact()

func _physics_process(delta):
	speedMult = 2.5 if(Input.is_action_pressed("sprint")) else 1.0
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(direction and canMove):
		velocity = direction.normalized() * distortion * speed * speedMult
		countDownRef.DrainSteps(speedMult * drainSpeed * delta)
	else:
		velocity = Vector2.ZERO
	if(Input.is_action_just_pressed("noclip") and OS.has_feature("editor")):
		print("noclipping")
		$CollisionPolygon2D.disabled = !$CollisionPolygon2D.disabled
	move_and_slide()

func SetCanMove(newCanMove: bool) -> void:
	canMove = newCanMove

func _on_interact_area_area_entered(area):
	if(area is Interactable):
		interactList.append(area)

func _on_interact_area_area_exited(area):
	if(area is Interactable):
		interactList.erase(area)

func GetClosestInteractable() -> Interactable:
	var closestDistance: float = global_position.distance_squared_to(interactList[0].global_position)
	var closestInteractable: Interactable = interactList[0]
	for ii in interactList:
		if(GetIsoDistanceMetric(global_position, ii.global_position) < closestDistance):
			closestDistance = GetIsoDistanceMetric(global_position, ii.global_position)
			closestInteractable = ii
	return closestInteractable

func GetIsoDistanceMetric(vec1: Vector2, vec2: Vector2) -> float:
	return (pow(vec1.x - vec2.x, 2) * distortion.x) + (pow(vec1.y - vec2.y, 2) * distortion.y)
