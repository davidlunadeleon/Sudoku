extends Node2D

# Declare member variables here.
const INITIAL_DOMAIN = [1,2,3,4,5,6,7,8,9]
const NROWS = 9
const NCOLS = 9
var tmap_transform
var grid
var selected_tile

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = []
	tmap_transform = $Grid_TileMap.get_transform()
	selected_tile = Vector2()
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
		if event.button_index == BUTTON_LEFT && event.pressed:
			clear_select()
			var mouse_pos = get_viewport().get_mouse_position()
			var tile_pos = pos_to_cell_index(mouse_pos)
			if(tile_pos.x >= 0 && tile_pos.y >= 0):
				$Grid_TileMap.set_cell(tile_pos.x, tile_pos.y, 9)
				selected_tile = tile_pos

func pos_to_cell_index(mouse_pos):
	if mouse_pos.x < 1024 && mouse_pos.y < 1024:
		mouse_pos.x = mouse_pos.x / tmap_transform.x.x
		mouse_pos.y = mouse_pos.y / tmap_transform.y.y
		var cell_pos = $Grid_TileMap.world_to_map(mouse_pos)
		return Vector2(cell_pos.x, cell_pos.y)
	else:
		return Vector2(-1.0, -1.0)

func clear_select():
	$Grid_TileMap.set_cell(selected_tile.x, selected_tile.y, -1)
	selected_tile = Vector2()
