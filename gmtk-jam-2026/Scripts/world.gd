extends Node2D

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
	$Level.add_child(newLevel)
	levelRef = newLevel
	SpawnPlayer()

func SpawnPlayer() -> void:
	if(not playerRef):
		playerRef = playerObj.instantiate()
	levelRef.playerLayer.add_child(playerRef)
