extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal SyncGameData
enum {Ollie, Kickflip, Nollie, Heelflip, NollieHeelflip, NollieKickflip}
var game_data
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var xpThresholdPerLevel = {
	"L1": 230,
	"L2": 484,
	"L3": 762,
	"L4": 1052,
	"L5": 1375,
	"L6": 1722,
	"L7": 2093,
	"L8": 2464,
	"L9": 2880,
	"L10": 3500,
	"L11": 3916,
	"L12": 4308,
	"L13": 4745,
	"L14": 5194,
	"L15": 5610,
	"L16": 6080,
	"L17": 6562,
	"L18": 7002,
	"L19": 7505,
	"L20": 8500,
	"L21": 9177,
	"L22": 9878,
	"L23": 10534,
	"L24": 11280,
	"L25": 12500
}


var levelTrickPercentage = {
	"L1": 10,
	"L2": 14,
	"L3": 18,
	"L4": 21,
	"L5": 25,
	"L6": 29,
	"L7": 33,
	"L8": 36,
	"L9": 40,
	"L10": 50,
	"L11": 52,
	"L12": 53,
	"L13": 55,
	"L14": 57,
	"L15": 58,
	"L16": 60,
	"L17": 62,
	"L18": 63,
	"L19": 65,
	"L20": 75,
	"L21": 79,
	"L22": 83,
	"L23": 86,
	"L24": 90,
	"L25": 100
}


func getNewTrickPercentage(trick):
	trick["successChance"] = levelTrickPercentage["L" + str(trick["level"])]

func getNextXpThreshold(trick):
	trick["next_xp_threshold"] = xpThresholdPerLevel["L" + str(trick["level"])]

func levelUpMedal(trick, index):
	if trick["level"] < 26:
		var medal = get_node("LevelMedal" + str(index))
		medal.play("Medal" + str(trick["level"]))

func levelUpTrick(trick):
	trick["level"] += 1
	trick["current_xp"] = 0
	getNextXpThreshold(trick)
	getNewTrickPercentage(trick)
	emit_signal("SyncGameData", game_data)
	#Play Level up animation?

func update_progress_bars():
	for i in range(1, 7):
		var progressBar = get_node("EquippedProgress" + str(i))
		var medal = get_node("LevelMedal" + str(i))
		var label = get_node("EquippedTrickLabel" + str(i))
		progressBar.visible = false
		medal.visible = false
		label.visible = false
		
		
	var index = 1
	for trick in game_data["equippedTricks"]:
		if index > 6:
			break
		
		if trick["current_xp"] >= trick["next_xp_threshold"]:
			levelUpTrick(trick)
			levelUpMedal(trick, index)
		
		var progressBar = get_node("EquippedProgress" + str(index))
		progressBar.visible = true
		progressBar.max_value = trick["next_xp_threshold"]
		progressBar.value = trick["current_xp"]
		var medal = get_node("LevelMedal" + str(index))
		medal.visible = true
		var label = get_node("EquippedTrickLabel" + str(index))
		label.text = trick["name"]
		label.visible = true
		
		index += 1



func _on_Player_SyncGameData(data):
	game_data = data
	update_progress_bars()
