extends Node

@export var powerUps: Dictionary[String, PowerUp]

signal inventoryChanged

func AddPowerUp(newPowerUp: PowerUp, pickUpId: String) -> void:
	powerUps[pickUpId] = newPowerUp
	inventoryChanged.emit()
