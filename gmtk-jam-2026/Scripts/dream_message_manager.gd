extends Node

var prioMessages: Array[String]
var defaultMessages: Array[String]

var fillerMessages: Array[String]

func _ready():
	fillerMessages = GetMessagesFromFile("res://FillerMessages.txt")
	fillerMessages.reverse()
	for ii in range(len(fillerMessages)):
		fillerMessages[ii] = CharacterizeMessage(fillerMessages[ii])
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
	newMessage = CharacterizeMessage(newMessage)
	if(isPrio): prioMessages.push_back(newMessage)
	else: defaultMessages.push_back(newMessage)

func GetMessagesFromFile(filePath: String) -> Array[String]:
	var file: FileAccess = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var output: Array[String]
	output.assign(content.split(";\n"))
	output = output.filter(func(ii): return ii != "")
	return output

func CharacterizeMessage(msg: String) -> String:
	if(msg.contains("[@chip]")):
		msg = msg.replace("[@chip]", "")
		msg = "[color=#d9f050]"+msg+"[/color]"
	if(msg.contains("[@child]")):
		msg = msg.replace("[@child]", "")
		msg = "[color=#a59372]"+msg+"[/color]"
	if(msg.contains("[@outside]")):
		msg = msg.replace("[@outside]", "")
		msg = "[color=#b86d86]"+msg+"[/color]"
	if(msg.contains("[@real]")):
		msg = msg.replace("[@real]", "")
		msg = "[color=#009797]"+msg+"[/color]"
	return msg
