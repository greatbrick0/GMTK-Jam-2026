extends Node

var prioMessages: Array[String]
var defaultMessages: Array[String]

var fillerMessages: Array[String]

func _ready():
	fillerMessages = GetMessagesFromFile("res://FillerMessages.txt")
	fillerMessages.reverse()
	defaultMessages.append_array(fillerMessages)

func GetNextMessage() -> String:
	var output: String
	if(not prioMessages.is_empty()):
		output = prioMessages.pop_back()
	else:
		if(defaultMessages.is_empty()):
			defaultMessages.append_array(fillerMessages)
			defaultMessages.shuffle()
		output = defaultMessages.pop_back()
	
	return output

func AddNewMessage(newMessage: String, isPrio: bool) -> void:
	if(isPrio): prioMessages.push_back(newMessage)
	else: defaultMessages.push_back(newMessage)

func GetMessagesFromFile(filePath: String) -> Array[String]:
	var file: FileAccess = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var output: Array[String]
	output.assign(content.split(";\n"))
	output.erase("")
	print(output)
	return output
