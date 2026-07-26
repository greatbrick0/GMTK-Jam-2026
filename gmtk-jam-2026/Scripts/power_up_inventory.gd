extends Node

@export var powerUps: Dictionary[String, PowerUp]

func AddPowerUp(newPowerUp: PowerUp, pickUpId: String) -> void:
	powerUps[pickUpId] = newPowerUp
