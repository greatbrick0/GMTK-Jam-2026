extends Interactable
class_name PickUpPowerUp

@export var pickUpId: String = ""
@export var heldPowerUp: PowerUp
@export var forceReset: bool = false
@export var dreamMessages: Array[String] = []

var used = false

var time: float = 0.0

func _ready():
	$VisualOffset/Sprite2D.texture = heldPowerUp.icon
	if(PowerUpInventory.powerUps.has(pickUpId)):
		$VisualOffset.visible = false
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
	$CPUParticles2D.emitting = true
	for ii in dreamMessages:
		DreamMessageManager.AddNewMessage(ii, true)
	PowerUpInventory.AddPowerUp(heldPowerUp, pickUpId)
	$VisualOffset.visible = false
	if(forceReset):
		get_tree().get_first_node_in_group("Player").BumpCanMove(false)
		$Timer.start()

func _on_timer_timeout():
	get_tree().get_first_node_in_group("Player").BumpCanMove(true)
	Hud.instance.EndLoop()
