extends Interactable

@export var returnUp: bool = false
@export var packedLevel: PackedScene
@export var filePathLevel: String
@export var exitPosition: Vector2 = Vector2.ZERO

func Interact() -> bool:
	UsePortal()
	return true

func UsePortal() -> void:
	var world: World = get_tree().current_scene
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.canMove = false
	MusicManager.PlayGeneral(1)
	await Hud.instance.Transition()
	if(returnUp):
		world.ReturnUpLevelStack()
	else:
		if(packedLevel != null): world.SpawnLevelFromPacked(packedLevel, true)
		else: world.SpawnLevelFromPath(filePathLevel, true)
	player.global_position = exitPosition
	player.canMove = true
