extends Node2D

# Declare member variables here.
const INITIAL_DOMAIN = [1,2,3,4,5,6,7,8,9]
const NROWS = 9
const NCOLS = 9
var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = []
	clear_grid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func clear_grid():
	var tempRow = []
	grid.clear()
	for _x in range(NCOLS):
		tempRow.push_back(INITIAL_DOMAIN)
	for _x in range(NROWS):
		grid.push_back(tempRow)

	for x in range(NROWS):
		for y in range(NCOLS):
			$Grid_TileMap.set_cell(x, y, -1)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			var mouse_pos = get_viewport().get_mouse_position()
			pos_to_cell_index(mouse_pos)

func pos_to_cell_index(mouse_pos):
	if mouse_pos.x < 1024 && mouse_pos.y < 1024:
		print (mouse_pos)
