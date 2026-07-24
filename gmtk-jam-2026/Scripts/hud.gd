extends CanvasLayer
class_name Hud

static var instance: Hud

signal playerWakeUp
signal playerFullyAsleep

var countdownStartAmount: float = 0.0
var countdownEndAmount: float = 100.0
@export var countDownLerpValue: float = 0.0:
	set(value):
		countDownLerpValue = value
		if($CountDown != null):
			$CountDown.SetSteps(lerp(countdownStartAmount, countdownEndAmount, value))

func _ready():
	if(instance == null):
		instance = self
	else:
		queue_free()
	$CountDown.SetSteps(100.0)

func EndLoop() -> void:
	GetCountDownAmountsForFallAsleep()
	$WakeUpPlayer.play("FallAsleep")

func _on_wake_up_button_pressed():
	$WakeUpPlayer.play("Awaken")

func AllowPlayerMovement() -> void:
	playerWakeUp.emit()

func _on_count_down_out_of_steps():
	EndLoop()

func GetCountDownAmountsForFallAsleep() -> void:
	countdownStartAmount = $CountDown.stepsRemaining
	countdownEndAmount = 100.0

func ScreenBlackenedOut() -> void:
	playerFullyAsleep.emit()

func Transition() -> void:
	$TransitionPlayer.play("FadeBlackIn")
	await $TransitionPlayer.animation_finished
	$TransitionPlayer.play("FadeBlackOut")
