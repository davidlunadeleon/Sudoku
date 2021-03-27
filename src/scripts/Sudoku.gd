extends Node

class_name Sudoku

# Declare member variables here. Examples:
const INITIAL_DOMAIN = [1,2,3,4,5,6,7,8,9]
const SAMPLE_ROW = [0,0,0,0,0,0,0,0,0]
const NROWS = 9
const NCOLS = 9
const SQR_SIZE = 3
var grid
var domains
var constraints
var sorted_cells

func _init():
	grid = []
	sorted_cells = []
	domains = {}
	constraints = {}
	init()
	init_constraints()

func init():
	grid.clear()
	sorted_cells.clear()
	for x in range(NROWS):
		grid.push_back(SAMPLE_ROW)
		for y in range(NCOLS):
			domains[str(x) + str(y)] = INITIAL_DOMAIN

func init_constraints():
	for key in domains.keys():
		constraints[key] = []
		var row = key[0].to_int()
		var col = key[1].to_int()
		for x in range(NCOLS):
			if x != row:
				constraints.get(key).push_back(str(row) + str(x))
		for x in range(NROWS):
			if x != col:
				constraints.get(key).push_back(str(x) + str(col))
		var sqr_row = row / SQR_SIZE
		var sqr_col = col / SQR_SIZE
		for x in range(sqr_row * SQR_SIZE, ((sqr_row + 1) * SQR_SIZE)):
			if x != row:
				for y in range(sqr_col * SQR_SIZE, ((sqr_col + 1) * SQR_SIZE)):
					if y != col:
						constraints.get(key).push_back(str(x) + str(y))

func set_cell(pos, val):
	grid[pos.x][pos.y] = val
	domains[str(pos.x) + str(pos.y)] = [val]
	print(pos)
	print(domains.get(str(pos.x) + str(pos.y)))
	print(constraints.get(str(pos.x) + str(pos.y)))
	print(val)

func clear_cell(pos):
	grid[pos.x][pos.y] = 0
	domains[str(pos.x) + str(pos.y)] = INITIAL_DOMAIN
	print(pos)
