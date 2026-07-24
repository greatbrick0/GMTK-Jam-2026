extends Node
class_name Communicator

enum InputRequirement {ALL, ANY}

@export var inputs: Array[Node]
@export var inputRequirement: InputRequirement = InputRequirement.ALL
@export var outputs: Array[Node]

@export var state: bool = false

func _ready():
	add_to_group("Resetable")
	for ii in inputs:
		if ii.has_signal("changed"):
			ii.changed.connect(InputsChanged)

func InputsChanged() -> void:
	var result: bool = inputRequirement == InputRequirement.ALL
	for ii in inputs:
		if(inputRequirement == InputRequirement.ALL):
			result = result and GetInputState(ii)
		else:
			result = result or GetInputState(ii)
	if(result != state):
		state = result
		ActivateOutputs(state)

func ActivateOutputs(newValue: bool) -> void:
	for ii in outputs:
		if(ii is Gate):
			ii.Activate(newValue)
		else:
			pass

func GetInputState(input: Node) -> bool:
	if(input is Lever):
		return input.used
	else:
		return false

func Reset() -> void:
	state = false
