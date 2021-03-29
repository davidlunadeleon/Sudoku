extends CanvasLayer

signal solve
signal new_game

# Declare member variables here.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_SolveButton_pressed():
	emit_signal("solve")

func _on_NewGameButton_pressed():
	emit_signal("new_game")

func _on_Game_message(message):
	$Message.text = message
	yield(get_tree().create_timer(2), "timeout")
	$Message.text = ""

func _on_Game_error(message):
	$Message.text = message
	$Message.add_color_override("font_color", Color(1,0,0,1))
	yield(get_tree().create_timer(2), "timeout")
	$Message.add_color_override("font_color", Color(1,1,1,1))
	$Message.text = ""
