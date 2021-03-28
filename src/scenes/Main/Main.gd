extends Node

# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.connect("solve", $Game, "solve")
	$Game.connect("message", $HUD, "write_message")
	$Game.connect("error", $HUD, "write_error")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
