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

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = []
	domains = {}
	constraints = {}
	init()
	init_constraints()

func init():
	grid.clear()
	for x in range(NROWS):
		grid.push_back(SAMPLE_ROW)
		for y in range(NCOLS):
			domains[str(x) + str(y)] = INITIAL_DOMAIN

func init_constraints():
	for key in domains.keys():
		constraints[key] = []
		var row = key[0]
		var col = key[1]
		for x in range(NCOLS):
			if x != row:
				constraints.get(key).push_back(str(row) + str(x))
		for x in range(NROWS):
			if x != col:
				constraints.get(key).push_back(str(x) + str(col))
		var sqr_row = row / SQR_SIZE
		var sqr_col = col / SQR_SIZE
		for x in range(sqr_row * SQR_SIZE, ((sqr_row + 1) * SQR_SIZE) - 1):
			if x != row:
				for y in range(sqr_col * SQR_SIZE, ((sqr_col + 1) * SQR_SIZE) - 1):
					if y != col:
						constraints.get(key).push_back(str(x) + str(y))
