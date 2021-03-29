extends CanvasLayer

signal solve
signal new_game(difficulty)
signal new_solver

# Declare member variables here.

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_hud()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reset_hud():
	$SolveButton.set_disabled(false)
	$SolveButton.visible = true
	$NewGameButton.visible = true
	$SolverButton.visible = false
	$EasyButton.visible = false
	$MediumButton.visible = false
	$HardButton.visible = false

func _on_Game_is_unsolved():
	reset_hud()

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_SolveButton_pressed():
	$SolveButton.set_disabled(true)
	emit_signal("solve")

func _on_Game_is_solved():
	$SolveButton.set_disabled(true)

func _on_NewGameButton_pressed():
	$SolveButton.visible = false
	$NewGameButton.visible = false
	$SolverButton.visible = true
	$EasyButton.visible = true
	$MediumButton.visible = true
	$HardButton.visible = true

func _on_Difficulty_pressed(difficulty):
	emit_signal("new_game", difficulty)
	reset_hud()

func _on_SolverButton_pressed():
	emit_signal("new_solver")
	reset_hud()

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
