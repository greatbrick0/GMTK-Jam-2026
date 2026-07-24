extends Interactable

@export var keepLevelData: bool = true
@export var packedLevel: PackedScene
@export var filePathLevel: String
@export var exitPosition: Vector2 = Vector2.ZERO

func _ready():
	pass 

func Interact() -> bool:
	var world: World = get_tree().current_scene
	if(packedLevel != null):
		print(world.name)
		world.SpawnLevelFromPacked(packedLevel)
	else:
		print(world.name)
	MusicManager.PlayGeneral(1)
	get_tree().get_first_node_in_group("Player").global_position = exitPosition
	return true
