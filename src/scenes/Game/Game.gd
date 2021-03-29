extends Node2D

signal message(message)
signal error(message)
signal is_solved

# Declare member variables here.
const NROWS = 9
const NCOLS = 9
const INVALID_TILE = Vector2(-1.0, -1.0)
var tmap_transform
var selected_tile
var sudoku
var can_click
var placed_tiles

# Called when the node enters the scene tree for the first time.
func _ready():
	tmap_transform = $Grid_TileMap.get_transform()
	selected_tile = INVALID_TILE
	sudoku = Sudoku.new()
	can_click = true
	placed_tiles = 0
	clear_grid()

func clear_grid():
	can_click = true
	placed_tiles = 0
	for x in range(NROWS):
		for y in range(NCOLS):
			selected_tile = Vector2(x, y)
			clear_select()

func _on_HUD_new_game(difficulty):
	clear_grid()
	sudoku.gen(difficulty)
	read_grid()
	emit_signal("message", "Starting new game")

func _on_HUD_new_solver():
	clear_grid()
	emit_signal("message", "Starting new game")

func check_completed():
	if placed_tiles == 81:
		can_click = false
		emit_signal("message", "Sudoku solved! Good game")
		emit_signal("is_solved")

func _input(event):
	if can_click:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT && event.pressed:
				clear_select()
				var mouse_pos = get_viewport().get_mouse_position()
				var tile_pos = pos_to_cell_index(mouse_pos)
				if is_tile_valid(tile_pos):
					$Grid_TileMap.set_cell(tile_pos.x, tile_pos.y, 9)
					selected_tile = tile_pos
		elif event is InputEventKey && is_tile_valid(selected_tile):
			place_number(event)
			check_completed()

func place_number(event):
	if event.get_scancode() == KEY_1:
		set_select(0)
	elif event.get_scancode() == KEY_2:
		set_select(1)
	elif event.get_scancode() == KEY_3:
		set_select(2)
	elif event.get_scancode() == KEY_4:
		set_select(3)
	elif event.get_scancode() == KEY_5:
		set_select(4)
	elif event.get_scancode() == KEY_6:
		set_select(5)
	elif event.get_scancode() == KEY_7:
		set_select(6)
	elif event.get_scancode() == KEY_8:
		set_select(7)
	elif event.get_scancode() == KEY_9:
		set_select(8)
	else:
		set_select(-1)

func pos_to_cell_index(mouse_pos):
	if mouse_pos.x < 1024 && mouse_pos.y < 1024:
		mouse_pos.x = mouse_pos.x / tmap_transform.x.x
		mouse_pos.y = mouse_pos.y / tmap_transform.y.y
		var cell_pos = $Grid_TileMap.world_to_map(mouse_pos)
		return Vector2(cell_pos.x, cell_pos.y)
	else:
		return INVALID_TILE

func clear_select():
	if is_tile_valid(selected_tile):
		sudoku.clear_cell(Vector2(selected_tile.y, selected_tile.x)) # Invert x and y to match matrix indexing
		$Grid_TileMap.set_cell(selected_tile.x, selected_tile.y, -1)
	selected_tile = INVALID_TILE

func set_select(tile):
	if tile >= 0 && tile <= 8:
		if !sudoku.set_cell(Vector2(selected_tile.y, selected_tile.x), tile + 1): # Invert x and y to match matrix indexing
			emit_signal("error", "Number not valid. Try another one.")
			tile = -1
		else:
			placed_tiles = placed_tiles + 1
	else:
		placed_tiles = placed_tiles - 1
	$Grid_TileMap.set_cell(selected_tile.x, selected_tile.y, tile)
	selected_tile = INVALID_TILE

func is_tile_valid(tile):
	return tile.x >= 0 && tile.x <= 9 && tile.y >= 0 && tile.y <= 9

func _on_HUD_solve():
	if sudoku.solve():
		var grid = sudoku.get_grid()
		for x in range(NROWS):
			for y in range(NCOLS):
				if $Grid_TileMap.get_cell(x, y) == -1:
					selected_tile = Vector2(x, y)
					set_select(grid[y][x] + 9)
		emit_signal("message", "Puzzle solved!")
		can_click = false
	else:
		emit_signal("error", "Puzzle is unsolvable. Try another one.")

func read_grid():
	var grid = sudoku.get_grid()
	for x in range(NROWS):
		for y in range(NCOLS):
			if $Grid_TileMap.get_cell(x, y) == -1:
				selected_tile = Vector2(x, y)
				if grid[y][x] == 0:
					clear_select()
				else:
					set_select(grid[y][x] + 9)
					placed_tiles = placed_tiles + 2
