extends GridContainer
class_name Table

@onready var table: GridContainer = self
@onready var title_label          = preload("res://src/title/title.tscn")
@onready var cell_edit            = preload("res://src/cell edit/cell_edit.tscn")
@onready var choice_cell          = preload("res://src/choice cell/choice_cell.tscn")


func setup_table(chunk, type: FileType.type):
	
	var headers = []
	
	if typeof(chunk) == TYPE_DICTIONARY:
		headers.append("Key")
	
	headers.append("OG Text")
	
	var cell_headers = get_headers(chunk, type)
	
	headers.append_array(cell_headers)
	
	create_headers(headers)
	
	create_rows(chunk, type)

#----#

func get_headers(chunk, type: FileType.type):
	
	var headers = []
	
	if type == FileType.type.Other:
		
		for key in chunk.keys():
			
			if key == "id":
				continue
			
			for cell in chunk[key]["cells"]:
				
				headers.append(cell["cell_name"])
			
			return headers
	
	elif type == FileType.type.System:
		
		if typeof(chunk) == TYPE_ARRAY:
			
			for cell in chunk[0]["cells"]:
				
				headers.append(cell["cell_name"])
			return headers
		
		else:
			
			for key in chunk.keys():
				
				if "original text" in chunk.keys():
					headers.append(chunk["cells"][0]["cell name"])
					return headers
				
				for cell in chunk[key]["cells"]:
					
					headers.append(cell["cell_name"])
				
				return headers
	
	else:
		
		for shard in chunk:
			
			if len(shard) > 0:
				
				for cell in shard[0]["cells"]:
					
					headers.append(cell["cell name"])
				return headers


func get_data(shard, type: FileType.type):
	
	var data = []
	
	if type == FileType.type.Other:
		
		for key in shard.keys():
			
			if key == "id":
				continue
			
			var row_data = {}
			row_data["original text"] = shard[key]["original text"]
			row_data["Key"]           = key
			row_data["cells"]         = shard[key]["cells"]
			
			data.append(row_data)
	
	else:
		
		if typeof(shard) == TYPE_ARRAY:
			
			for entry in shard:
				
				var row_data = {}
				row_data["original text"] = entry["original text"]
				row_data["cells"]         = entry["cells"]
				
				data.append(row_data)
		
		else:
			
			for key in shard.keys():
				
				var row_data = {}
				row_data["original text"] = shard[key]["original text"]
				row_data["Key"]           = key
				row_data["cells"]         = shard[key]["cells"]
				
				data.append(row_data)
	
	return data


#----#


func create_headers(headers: Array) -> void:
	
	table.columns = len(headers)
	
	for header in headers:
		
		
		var title = title_label.instantiate()
		table.add_child(title)
		title.text = header


func create_rows(row_data, type: FileType.type) -> void:
	
	
	if type == FileType.type.Other or type == FileType.type.System:
		
		if typeof(row_data) == TYPE_DICTIONARY:
			
			for key in row_data.keys():
				
				var is_game_title = false
				
				if key == "id":
					continue
				
				var atr:    CellEdit = cell_edit.instantiate()
				var og_txt: CellEdit = cell_edit.instantiate()
				
				table.add_child(atr)
				table.add_child(og_txt)
				
				if "original text" in row_data.keys():
					atr.text    = "GameTitle"
					og_txt.text = row_data["original text"]
					is_game_title = true
				else:
					atr.text    = key
					og_txt.text = row_data[key]["original text"]
				
				atr.editable    = false
				og_txt.editable = false
				
				
				if is_game_title == false:
					create_cells(row_data[key]["cells"], type)
				else:
					create_cells(row_data["cells"], type)
					break
		
		else:
			
			for shard in row_data:
				
				var og_txt: CellEdit = cell_edit.instantiate()
				og_txt.editable = false
				table.add_child(og_txt)
				if shard["original text"] == null:
					og_txt.text = ""
				else:
					og_txt.text = shard["original text"]
				
				create_cells(shard["cells"], type)
		
	else:
		
		for shard in row_data:
			
			if len(shard) != 0:
				
				if shard[0]["original text"][0] == "" and len(shard[0]["original text"]) == 1:
					continue
				
				if shard[0]["info"]["code"] == 102:
					
					var og_txt: ChoiceCell = choice_cell.instantiate()
					table.add_child(og_txt)
					og_txt.create_choices(shard[0])
					
					var cell_index := 0
					
					for cell in shard[0]["cells"]:
						
						var new_cell: ChoiceCell = choice_cell.instantiate()
						table.add_child(new_cell)
						new_cell.create_choices(shard[0], cell_index)
						cell_index += 1
				
				else:
					
					var og_txt: CellEdit = cell_edit.instantiate()
					og_txt.editable = false
					table.add_child(og_txt)
					insert_lines(shard[0]["original text"], og_txt)
					
					create_cells(shard[0]["cells"], type)


func create_cells(cells: Array, type: FileType.type) -> void:
	
	for cell in cells:
				
				var new_cell: CellEdit = cell_edit.instantiate()
				
				table.add_child(new_cell)
				
				if type == FileType.type.Other or type == FileType.type.System:
					
					if cell["text"] == null:
						new_cell.text = ""
					else:
						new_cell.text      = cell["text"].c_escape()
					new_cell.cell_data = cell
					new_cell.type      = type
				
				else:
					
					if cell["text"][0] == null:
						new_cell.text = ""
					else:
						insert_lines(cell["text"], new_cell)
					new_cell.cell_data = cell
					new_cell.type      = type


func insert_lines(lines: Array, cell: TextEdit) -> void:
	
	var line_track = 0
	
	for line in lines:
		
		cell.insert_line_at(line_track, line.c_escape())
		line_track += 1
