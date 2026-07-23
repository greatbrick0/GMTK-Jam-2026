extends Node

var prevTrackIndex: int = -1
var currentTrackIndex: int = 0
var timeSinceTrackChange: float = 0.0
var changingTracks: bool = false

@export var trackTransitionTime: float = 2.0
@export var trackSilentVolume: float = -25
var trackFullVolumes: Array[float] = []

func _ready() -> void:
	for ii in get_children():
		if(ii is AudioStreamPlayer):
			trackFullVolumes.append(ii.volume_db)

func _process(delta):
	if(changingTracks):
		timeSinceTrackChange += (1.0 / trackTransitionTime) * delta
		timeSinceTrackChange = min(timeSinceTrackChange, 1)
		get_child(prevTrackIndex).volume_db = lerp(trackFullVolumes[prevTrackIndex], trackSilentVolume, timeSinceTrackChange)
		get_child(currentTrackIndex).volume_db = lerp(trackSilentVolume, trackFullVolumes[currentTrackIndex], timeSinceTrackChange)
		if(timeSinceTrackChange >= 1.0):
			get_child(prevTrackIndex).stop()

func ChangeTrack(newTrack: int) -> void:
	if(newTrack == currentTrackIndex): return
	timeSinceTrackChange = 0
	prevTrackIndex = currentTrackIndex
	currentTrackIndex = newTrack
	changingTracks = prevTrackIndex != currentTrackIndex
	if(changingTracks):
		get_child(currentTrackIndex).play()

func OnTrackFinished(trackIndex: int) -> void:
	if(trackIndex == currentTrackIndex):
		get_child(currentTrackIndex).play()

func PlayGeneral(index: int):
	$GeneralEffects.get_child(index).play()

func PlayGeneralByName(nodeName: String):
	$GeneralEffects.get_node(nodeName).play()
