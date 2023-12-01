extends Node2D

signal game_data_ready
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var allTricks = [Ollie, Kickflip]
enum {L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L20,L21,L22,L23,L24,L25}

var Ollie = {
	"name": "Ollie",
	"animation_name": "Ollie",
	"level": 1,
	"next_xp_threshold": 250,
	"current_xp": 0,
	"unlocked": true,
	"successChance" : 10,
	"popLocation" : "Tail"
}

var Kickflip = {
	"name": "Kickflip",
	"animation_name": "Kickflip",
	"level": 1,
	"next_xp_threshold": 250,
	"current_xp": 0,
	"unlocked": true,
	"successChance" : 10,
	"popLocation" : "Tail"
}

var Nollie = {
	"name": "Nollie",
	"animation_name": "Nollie",
	"level": 1,
	"next_xp_threshold": 250,
	"current_xp": 0,
	"unlocked": true,
	"successChance" : 10,
	"popLocation" : "Nose"
}

var PopShoveIt = {
	"name": "PopShoveIt",
	"animation_name": "PopShoveIt",
	"level": 1,
	"next_xp_threshold": 250,
	"current_xp": 0,
	"unlocked": true,
	"successChance" : 10,
	"popLocation" : "Tail"
}

var game_data = {
	"total_clicks": 0,
	"total_tricks_attempted": 0,
	"total_tricks_succeeded": 0,
	"total_tricks_failed": 0,
	"currency": 0,
	"equippedTricks": [Ollie, Kickflip],
	"unlockedTricks": [Ollie, Kickflip, Nollie, PopShoveIt],
	"last_played": "2023-03-15T12:00:00",  # ISO 8601 format
	"player_preferences": {
		"sound_on": true,
		"graphics_quality": "high"
	},
	"achievements": {
		"first_trick": false,
		"master_trick": false
	}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("game_data_ready", game_data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func saveGame():
#	saveUnlockedTricks()
#	var saveFile = File.new()
#	saveFile.open("user://ClickFlip_Save.json", File.WRITE)
#	saveFile.store_string(game_data)
#	saveFile.close()

#func loadGame():
#	var loadFile = File.new()
#	if loadFile.file_exists("user://ClickFlip_Save.json"):
#		loadFile.open("user://ClickFlip_Save.json", File.READ)
#		var loadData = loadFile.get_as_text()
#		loadFile.close()
#		var test_json_conv = JSON.new()
#		test_json_conv.parse(loadData)
#		var data = test_json_conv.get_data()
#		game_data = data

func saveUnlockedTricks():
	for trick in allTricks:
		if trick["unlocked"] == true and !game_data["unlockedTricks"].has(trick):
			game_data["unlockedTricks"].append(trick)

func _on_Player_SyncGameData(data):
	game_data = data

func _on_SkillsHUD_SyncGameData(data):
	game_data = data
