extends Interactable
class_name PickUpPowerUp

@export var pickUpId: String = ""
@export var heldPowerUp: PowerUp
@export var forceReset: bool = false

var used = false

var time: float = 0.0

func _ready():
	$VisualOffset/Sprite2D.texture = heldPowerUp.icon
	if(PowerUpInventory.powerUps.has(pickUpId)):
		visible = false
		used = true

func _process(delta):
	time += 1.0 * delta
	$VisualOffset.position.y = sin(time * 3) * 2
	$VisualOffset.rotation_degrees = cos(time * 1.7) * 6

func Interact() -> bool:
	if(not used):
		Collect()
		return true
	else:
		return false

func Collect() -> void:
	used = true
	$Audio2D.play()
	PowerUpInventory.AddPowerUp(heldPowerUp, pickUpId)
	visible = false
