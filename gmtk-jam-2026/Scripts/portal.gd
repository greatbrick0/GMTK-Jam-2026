extends Interactable

@export var returnUp: bool = false
@export var packedLevel: PackedScene
@export var filePathLevel: String
@export var exitPosition: Vector2 = Vector2.ZERO

func _ready():
	pass 

func Interact() -> bool:
	var world: World = get_tree().current_scene
	if(returnUp):
		world.ReturnUpLevelStack()
	else:
		if(packedLevel != null): world.SpawnLevelFromPacked(packedLevel, true)
		else: world.SpawnLevelFromPath(filePathLevel, true)
	MusicManager.PlayGeneral(1)
	get_tree().get_first_node_in_group("Player").global_position = exitPosition
	return true
