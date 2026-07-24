extends CanvasLayer
class_name Hud

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
	$CountDown.SetSteps(100.0)

func EndLoop() -> void:
	$WakeUpPlayer.play("FallAsleep")

func _on_wake_up_button_pressed():
	$WakeUpPlayer.play("Awaken")

func AllowPlayerMovement() -> void:
	playerWakeUp.emit()

func _on_count_down_out_of_steps():
	EndLoop()

func SetCountDownAmountsForFallAsleep() -> void:
	countdownStartAmount = $CountDown.stepsRemaining
	countdownEndAmount = 100.0

func ScreenBlackenedOut() -> void:
	playerFullyAsleep.emit()
