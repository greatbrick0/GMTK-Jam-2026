extends Node

var atTop: bool = true
var inResetHud: bool = true

var isRaining: bool = false
var timeSinceWeatherChange: float = 0.0

func _ready() -> void:
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
		$AudioStreamPlayer.volume_db = -6.0
	else:
		$AudioStreamPlayer.volume_db = -40.0

func ChangeLevel(newLevel: int) -> void:
	print(newLevel)
	atTop = newLevel == 0

func SetInResetHud(value: bool) -> void:
	inResetHud = value
