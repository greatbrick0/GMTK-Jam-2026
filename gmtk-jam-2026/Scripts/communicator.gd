extends Node
class_name Communicator

enum InputRequirement {ALL, ANY, NONE}

@export var inputs: Array[Node]
@export var inputRequirement: InputRequirement = InputRequirement.ALL
@export var outputs: Array[Node]

@export var state: bool = false
@export var reset: bool = true

signal changed

func _ready():
	if(reset):
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
	if(inputRequirement == InputRequirement.NONE):
		result = !result
	if(result != state):
		state = result
		ActivateOutputs(state)
		changed.emit()

func ActivateOutputs(newValue: bool) -> void:
	for ii in outputs:
		if(ii is Gate):
			ii.Activate(newValue)
		else:
			pass

func GetInputState(input: Node) -> bool:
	if(input is Lever):
		return input.used
	elif(input is Communicator):
		return input.state
	else:
		return false

func Reset() -> void:
	state = inputRequirement == InputRequirement.NONE
