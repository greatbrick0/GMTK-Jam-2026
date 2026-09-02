extends Node

var atTop: bool = true
var inResetHud: bool = true

var isRaining: bool = false
var timeSinceWeatherChange: float = 10.0

@export var fadeSpeedMult: float = 3.0
@export var rainOnVolume: float = 0.3
@export var rainOffVolume: float = 0.0

func _ready() -> void:
	$AudioStreamPlayer.volume_linear = 0.0
	$AudioStreamPlayer.playing = true

func _process(delta):
	timeSinceWeatherChange += 1.0 * delta
	
	if(atTop and not inResetHud):
		if(not isRaining):
			isRaining = true
			timeSinceWeatherChange = 0.0
	else:
		if(isRaining):
			isRaining = false
			timeSinceWeatherChange = 0.0
	
	if(isRaining):
		$AudioStreamPlayer.volume_linear = lerpf(rainOffVolume, rainOnVolume, min(1.0, timeSinceWeatherChange * fadeSpeedMult))
	else:
		$AudioStreamPlayer.volume_linear = lerpf(rainOnVolume, rainOffVolume, min(1.0, timeSinceWeatherChange * fadeSpeedMult))

func ChangeLevel(newLevel: int) -> void:
	print(newLevel)
	atTop = newLevel == 0

func SetInResetHud(value: bool) -> void:
	inResetHud = value
