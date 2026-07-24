extends Node2D
class_name World

@export var playerObj: PackedScene = preload("res://scenes/player.tscn")
var playerRef: Player
var levelRef: Level

func _ready() -> void:
	SpawnLevelFromPath("res://scenes/open_level.tscn")

func SpawnLevelFromPacked(newLevel: PackedScene) -> void:
	InitializeLevel(newLevel.instantiate())

func SpawnLevelFromPath(newLevel: String) -> void:
	InitializeLevel(load(newLevel).instantiate())

func InitializeLevel(newLevel: Level) -> void:
	if($Level.get_child_count() > 0):
		levelRef.RemovePlayer(playerRef)
		levelRef.queue_free()
	$Level.add_child(newLevel)
	levelRef = newLevel
	SpawnPlayer()

func SpawnPlayer() -> void:
	if(not playerRef):
		playerRef = playerObj.instantiate()
	levelRef.playerLayer.add_child(playerRef)

func ResetWorld() -> void:
	playerRef.global_position = Vector2.ZERO
	SpawnLevelFromPath("res://scenes/open_level.tscn")
	for ii in get_tree().get_nodes_in_group("Resetable"):
		ii.Reset()

func _on_hud_player_wake_up():
	playerRef.SetCanMove(true)

func _on_hud_player_fully_asleep():
	ResetWorld()
