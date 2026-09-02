extends Node2D
class_name World

@export var levelStack: Array[Level] = []
@export var playerObj: PackedScene = preload("res://scenes/player.tscn")
var playerRef: Player
var levelRef: Level

@export var startLevel: String = "res://scenes/Levels/open_level.tscn"

func _ready() -> void:
	SpawnLevelFromPath(startLevel, false)

func SpawnLevelFromPacked(newLevel: PackedScene, appended: bool) -> void:
	InitializeLevel(newLevel.instantiate(), appended)

func SpawnLevelFromPath(newLevel: String, appended: bool) -> void:
	InitializeLevel(load(newLevel).instantiate(), appended)

func InitializeLevel(newLevel: Level, appended: bool) -> void:
	if(levelRef != null):
		levelRef.RemovePlayer(playerRef)
		if(appended):
			levelStack.append(levelRef)
		else:
			levelRef.queue_free()
			ClearLevelStack()
	$Level.add_child(newLevel, true)
	levelRef = newLevel
	levelRef.global_position = levelRef.levelOffset
	levelRef.MoveLights()
	SpawnPlayer(!appended)
	WeatherManager.ChangeLevel(len(levelStack))

func ReturnUpLevelStack() -> void:
	levelRef.RemovePlayer(playerRef)
	levelRef.queue_free()
	levelRef = levelStack.pop_back()
	SpawnPlayer(false)
	WeatherManager.ChangeLevel(len(levelStack))

func SpawnPlayer(resetPos: bool) -> void:
	if(not playerRef):
		playerRef = playerObj.instantiate()
	levelRef.playerLayer.add_child(playerRef)
	if(resetPos):
		playerRef.global_position = Vector2.ZERO

func ResetWorld() -> void:
	playerRef.global_position = Vector2.ZERO
	SpawnLevelFromPath(startLevel, false)
	for ii in get_tree().get_nodes_in_group("Resetable"):
		ii.Reset()

func ClearLevelStack() -> void:
	for ii in range(len(levelStack)):
		levelStack.pop_back().queue_free()

func _on_hud_player_wake_up():
	playerRef.BumpCanMove(true)

func _on_hud_player_fully_asleep():
	ResetWorld()
