extends CharacterBody2D
class_name Player

@export_category("Movement Values")
@export var speed: float = 45
var speedMult: float = 1.0
@export var drainSpeed: float = 1.0
@export var canMove: int = 1
var distortion: Vector2 = Vector2(2, 1)

var interactList: Array[Interactable]

var countDownRef: CountDown

var resetting: float = 0.0
var resetThreshold

@export_category("Drill Values")
@export var drillDrainSpeed: float = 5.0
@export_range(0, 10, 0.05, "or_greater") var basicDrillSpeed: float = 1.0
@export_range(0, 10, 0.05, "or_greater") var advancedDrillSpeed: float = 3.0

func _ready():
	countDownRef = get_tree().get_first_node_in_group("Countdown")
	countDownRef.outOfSteps.connect(BumpCanMove.bind(false))
	$CameraResults/CanvasLayer2/LightResult.visible = true

func _process(delta):
	if(Input.is_action_pressed("reset") and canMove == 0):
		resetting += 1.0 * delta
		if(resetting >= 0.5):
			Hud.instance.EndLoop()
	else:
		resetting = 0.0
	if(canMove == 0):
		ProcessItems(delta)
		if(Input.is_action_just_pressed("interact") and canMove == 0):
			if(len(interactList) > 0):
				GetClosestInteractable().Interact()

func _physics_process(delta):
	speedMult = 2.5 if(Input.is_action_pressed("sprint")) else 1.0
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(direction and canMove == 0):
		velocity = direction.normalized() * distortion * speed * speedMult
		countDownRef.DrainSteps(speedMult * drainSpeed * delta)
	else:
		velocity = Vector2.ZERO
	if(Input.is_action_just_pressed("noclip") and OS.has_feature("editor")):
		print("noclipping")
		$CollisionPolygon2D.disabled = !$CollisionPolygon2D.disabled
	move_and_slide()

func ProcessItems(delta) -> void:
	for ii in range(0, 2):
		var input: String = "ability_" + str(ii)
		if(Input.is_action_just_pressed(input)):
			print("item " + str(ii) + ": " + countDownRef.GetItemAvailable(ii))
		if(Input.is_action_pressed(input)):
			if(countDownRef.GetItemAvailable(ii) == "Drill-1"):
				countDownRef.DrainSteps(drillDrainSpeed * delta)
				PlayDrillSound()
				SetDrillArea($DrillArea.get_overlapping_areas(), 1.0)
			elif(countDownRef.GetItemAvailable(ii) == "Drill-2"):
				countDownRef.DrainSteps(drillDrainSpeed * delta)
				PlayDrillSound()
				SetDrillArea($DrillArea.get_overlapping_areas(), 3.0)
			else:
				StopDrill()
		if(Input.is_action_just_released(input)):
			if(countDownRef.GetItemAvailable(ii) == "Drill-1"):
				StopDrill()
			if(countDownRef.GetItemAvailable(ii) == "Drill-2"):
				StopDrill()

func StopDrill() -> void:
	SetDrillArea($DrillArea.get_overlapping_areas(), 0.0)
	$DrillAudio.stop()

func PlayDrillSound() -> void:
	if(not $DrillAudio.playing):
		$DrillAudio.play()

func BumpCanMove(newCanMove: bool) -> void:
	canMove += -1 if(newCanMove) else 1
	canMove = max(canMove, 0)

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

func SetDrillArea(areas: Array[Area2D], newValue: float) -> void:
	for ii in areas:
		if(ii.get_parent() is FragileRock):
			ii.get_parent().Drill(newValue)

func _on_drill_area_area_exited(area):
	if(area.get_parent() is FragileRock):
		area.get_parent().Drill(0.0)
