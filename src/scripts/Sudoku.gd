extends Node

class_name Sudoku

const INITIAL_DOMAIN = [1,2,3,4,5,6,7,8,9]
const SAMPLE_ROW = [0,0,0,0,0,0,0,0,0]
const NROWS = 9
const NCOLS = 9
const SQR_SIZE = 3
var grid
var domains
var constraints
var sorted_cells
var rng

func _init():
	randomize()
	rng = RandomNumberGenerator.new()
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
		grid.push_back(SAMPLE_ROW.duplicate())
		for y in range(NCOLS):
			domains[str(x) + str(y)] = INITIAL_DOMAIN.duplicate()

func init_constraints():
	for key in domains.keys():
		constraints[key] = []
		var row = key[0].to_int()
		var col = key[1].to_int()
		for x in range(NCOLS):
			if x != col:
				constraints.get(key).push_back(str(row) + str(x))
		for x in range(NROWS):
			if x != row:
				constraints.get(key).push_back(str(x) + str(col))
		var sqr_row = row / SQR_SIZE
		var sqr_col = col / SQR_SIZE
		for x in range(sqr_row * SQR_SIZE, ((sqr_row + 1) * SQR_SIZE)):
			if x != row:
				for y in range(sqr_col * SQR_SIZE, ((sqr_col + 1) * SQR_SIZE)):
					if y != col:
						constraints.get(key).push_back(str(x) + str(y))

func set_cell(pos, val):
	var key = str(pos.x) + str(pos.y)
	domains[key] = [val]
	if is_var_consistent(key):
		grid[pos.x][pos.y] = val
		return true
	else:
		clear_cell(pos)
		return false

func clear_cell(pos):
	grid[pos.x][pos.y] = 0
	domains[str(pos.x) + str(pos.y)] = INITIAL_DOMAIN.duplicate()

func get_grid():
	return grid

func remove_inconsistencies(key1, key2):
	var domain2 = domains.get(key2)
	for x in domains.get(key1):
		if domain2.size() == 1 && domain2.has(x):
			domains.get(key1).erase(x)
			return true
	return false

func ac3_algorithm():
	var key_queue = []
	for key in domains.keys():
		for neighbor in constraints.get(key):
			key_queue.push_back([key, neighbor])
	while !key_queue.empty():
		var key_arr = key_queue.pop_back()
		var key1 = key_arr[0]
		var key2 = key_arr[1]
		if remove_inconsistencies(key1, key2):
			for neighbor in constraints.get(key1):
				key_queue.push_back([neighbor, key1])
	for domain in domains.values():
		if domain.empty():
			return false
	return true

class Sorter:
	static func sort_mrv(x, y):
		var dom_x_size = x.values().front().size()
		var dom_y_size = y.values().front().size()
		return dom_x_size < dom_y_size

func sort_cells():
	var cells = []
	for key in domains.keys():
		cells.push_back({key: domains.get(key)})
	cells.sort_custom(Sorter, "sort_mrv")
	for cell in cells:
		if cell.values().front().size() > 1:
			sorted_cells.push_back(cell.keys().front())

func is_var_consistent(key):
	if domains.get(key).size() > 1:
		return false
	var val = domains.get(key).front()
	for neighbor in constraints.get(key):
		var domain = domains.get(neighbor)
		if domain.empty() || (domain.size() == 1 && domain.has(val)):
			return false
	return true

func backtrack(depth):
	if depth >= sorted_cells.size():
		return true;
	var key = sorted_cells[depth]
	var domain = domains.get(key).duplicate()
	for val in domain:
		domains[key] = [val]
		var wasErased = []
		for neighbor in constraints.get(key):
			if domains.get(neighbor).has(val):
				domains.get(neighbor).erase(val)
				wasErased.push_back(true)
			else:
				wasErased.push_back(false)
		if is_var_consistent(key) && backtrack(depth + 1):
			return true
		var i = 0
		for neighbor in constraints.get(key):
			if wasErased[i]:
				domains.get(neighbor).push_back(val)
			i = i + 1
	domains[key] = domain
	return false

func solve():
	var temp_domains = domains.duplicate()
	if ac3_algorithm():
		sort_cells()
		if backtrack(0):
			for key in domains.keys():
				var x = key[0].to_int()
				var y = key[1].to_int()
				grid[x][y] = domains.get(key).front()
			sorted_cells.clear()
			return true
	sorted_cells.clear()
	domains = temp_domains
	return false

func clear_grid():
	for x in range(NROWS):
		for y in range(NCOLS):
			clear_cell(Vector2(x, y))

func verify_rows(rows):
	for i in range(NCOLS):
		var row = rows[i]
		var key = str(row) + str(i)
		if !is_var_consistent(key):
			return false
	return true

func gen(difficulty):
	var randNum = (randi() % 9) + 1
	var rows = range(9)
	var verified = false
	while !verified:
		clear_grid()
		rows.shuffle()
		for x in range(NCOLS):
			var row = rows[x]
			grid[row][x] = randNum
			domains[str(row) + str(x)] = [randNum]
		verified = verify_rows(rows)
	solve()
	var keys_to_del = domains.keys().duplicate()
	keys_to_del.shuffle()
	var n_to_del
	if difficulty == 0:
		 n_to_del = rng.randi_range(15, 25)
	elif difficulty == 1:
		 n_to_del = rng.randi_range(30, 45)
	else:
		 n_to_del = rng.randi_range(50, 60)
	keys_to_del.resize(n_to_del)
	while !keys_to_del.empty():
		var key = keys_to_del.pop_back()
		var x = key[0].to_int()
		var y = key[1].to_int()
		clear_cell(Vector2(x, y))
