extends CanvasLayer

# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	$QuitButton.connect("pressed", self, "_on_QuitButton_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_QuitButton_pressed():
	get_tree().quit()
