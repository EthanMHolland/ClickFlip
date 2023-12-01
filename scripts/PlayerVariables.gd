extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal SyncGameData
var moving = true
onready var settings_node = get_node("SkillsHUD/Settings")
var game_data
var next_trick

var successXP = 25
var failureXP = 10

enum {Ollie, Kickflip, Nollie, Heelflip, NollieHeelflip, NollieKickflip}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_Button_button_down():
	$Button.disabled = true
	AttemptTrick()

func getTrickPercentage(trick_name):
	for trick in game_data["equippedTricks"]:
		if trick["name"] == trick_name["name"]:
			return trick["successChance"]
	return -1  # Return -1 or any other indicator that the trick was not found



func addXPtoTrick(trick, result):
	if result == true:
		trick["current_xp"] += successXP * trick["level"]
	else:
		trick["current_xp"] += failureXP  * trick["level"]
	emit_signal("SyncGameData", game_data)
	

func AttemptTrick():
	if moving:
		# Check if the trick succeeds based on the current trickCompletionChance
		randomize()
		var randomValue = randi() % 100  # Generate a random integer between 0 and 99
		print(randomValue)
		if randomValue <= getTrickPercentage(next_trick):
			# Trick succeeded, return true
			print("Trick succeeded!")
			addXPtoTrick(next_trick, true)
			$Skateboard.stop()
			$Skateboard.play(next_trick["animation_name"])
			prepareNextTrick()
		else:
			print("Trick failed.")
			addXPtoTrick(next_trick, false)
			setMoving(false, next_trick)
	else:
		setMoving(true, next_trick)


func setMoving(boolean, _trick):
	if boolean == true:
		moving = boolean
		$CityBackground.play("Moving")
		$Skateboard.play("Riding")
	else:
		moving = boolean
		$CityBackground.stop()
		if next_trick["popLocation"] == "Tail":
			$Skateboard.play("Failed Ollie")
		if next_trick["popLocation"] == "Nose":
			$Skateboard.play("Failed Nollie")

func prepareNextTrick():
	next_trick = pickRandomTrick()
	updateNextTrickLabels()

func updateNextTrickLabels():
	$NextTrickDynamicLabel.text = next_trick["name"]
	$NextTrickChanceLabel.text = str(next_trick["successChance"]) + "%"

func pickRandomTrick():
	var equippedTricks = game_data["equippedTricks"].duplicate()
	equippedTricks.shuffle()
	return equippedTricks[0]

func _on_Skateboard_animation_finished():
	$Button.disabled = false
	if moving:
		$Skateboard.play("Riding")



func _on_Settings_game_data_ready(recievedData):
	game_data = recievedData
	emit_signal("SyncGameData", game_data)
	prepareNextTrick()


func _on_SkillsHUD_SyncGameData(data):
	game_data = data
	updateNextTrickLabels()
