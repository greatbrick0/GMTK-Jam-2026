extends Node

@export var powerUps: Dictionary[String, PowerUp]

func AddPowerUp(newPowerUp: PowerUp, objectId: String) -> void:
	powerUps[objectId] = newPowerUp
