extends CanvasLayer
class_name Hud

static var instance: Hud

signal playerWakeUp
signal playerFullyAsleep

var countdownStartAmount: float = 0.0
var countdownEndAmount: float = 100.0

static var isOnMobile: bool = false

@export var countDownLerpValue: float = 0.0:
	set(value):
		countDownLerpValue = value
		if($CountDown != null):
			$CountDown.SetSteps(lerp(countdownStartAmount, countdownEndAmount, value))

@export var placeableObj: PackedScene = preload("uid://cls1r1pkubkev")

func _ready():
	if(instance == null):
		instance = self
		$CountDown.SetSteps(100.0)
		$Menu/DreamMessage.text = ""
		PowerUpInventory.inventoryChanged.connect(UpdateUpgradeSelectMenu)
		if(OS.has_feature("mobile") or OS.has_feature("web_ios") or OS.has_feature("web_android") or isOnMobile):
			isOnMobile = true
			print("Mobile device detected")
		else:
			$MobileControls.queue_free()
	else:
		queue_free()

func EndLoop() -> void:
	GetCountDownAmountsForRefill()
	UpdateDreamMessage()
	WeatherManager.SetInResetHud(true)
	$WakeUpPlayer.play("FallAsleep")

func UpdateDreamMessage() -> void:
	$Menu/DreamMessage.text = DreamMessageManager.GetNextMessage()
	print("new message: " + $Menu/DreamMessage.text)

func _on_wake_up_button_pressed():
	WeatherManager.SetInResetHud(false)
	if(isOnMobile):
		$MobileControls.visible = true
	$WakeUpPlayer.play("Awaken")

func AllowPlayerMovement() -> void:
	playerWakeUp.emit()

func _on_count_down_out_of_steps():
	EndLoop()

func GetCountDownAmountsForRefill() -> void:
	countdownStartAmount = $CountDown.stepsRemaining
	countdownEndAmount = 100.0

func ScreenBlackenedOut() -> void:
	if(isOnMobile):
		$MobileControls.visible = false
	playerFullyAsleep.emit()

func Transition() -> void:
	$TransitionPlayer.play("FadeBlackIn")
	await $TransitionPlayer.animation_finished
	$TransitionPlayer.play("FadeBlackOut")

func PlayRefillAnim() -> void:
	$RefillPlayer.play("Refill")
	await $RefillPlayer.animation_finished

func UpdateUpgradeSelectMenu() -> void:
	for ii in $Menu/Placeables.get_children():
		ii.queue_free()
	for ii in range(len(PowerUpInventory.powerUps)):
		var placeableRef: PowerUpPlaceable = placeableObj.instantiate()
		$Menu/Placeables.add_child(placeableRef)
		placeableRef.position.y = ii * 160
		placeableRef.Initialize(PowerUpInventory.powerUps.values()[ii])
