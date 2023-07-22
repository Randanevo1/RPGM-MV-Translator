extends Tree
class_name Table

@onready var table: Tree = $"."
var root: TreeItem
var attributes = false
var set_columns = false

var column_names = {}

func _ready():
	root = create_item()
	setup_table(FileEnum.contents, FileEnum.file.Map, false)


func setup_table(contents: Array, file: FileEnum.file, has_attributes=false):
	
	if has_attributes == true:
		add_column("Key", 0)
		table.columns += 1
		attributes = true
	
	add_column("Original Text", table.columns - 1)
	column_names["Original Text"] = table.columns - 1
	
	create_headers(contents[0]["pages"][0]["list"][1][0], file)
	
	var txt = self.create_item(root, 0)
	txt.set_text(0, "text")
	
	for shard in contents:
		
		if file == FileEnum.file.Other:
			pass
			#Todo Later
		elif file == FileEnum.file.System:
			pass
			#Todo later
		else:
			#create_row(shard, file)
			pass


#----#

#Done
func create_headers(chunk: Dictionary, file: FileEnum.file):
	
	var column_tracker = 1
	
	if file == FileEnum.file.Map or file == FileEnum.file.CommonEvents:
		
		table.columns = len(chunk["cells"]) + 1
		
		for cell in chunk["cells"]:
			add_column(cell["cell name"], column_tracker)
			column_names[cell["cell name"]] = column_tracker
			column_tracker += 1
	
	elif file == FileEnum.file.Other:
		
		
		column_tracker = 2
		
		for key in chunk:
			
			if key == "id" or key == "":
				continue
			
			if set_columns == false:
				table.columns = len(chunk[key]["cells"]) + 2
				set_columns = true
			
			for cell in chunk[key]["cells"]:
				add_column(cell["cell_name"], column_tracker)
				column_names[cell["cell_name"]] = column_tracker
				column_tracker += 1
			
			break


func create_row(tl_shard: Dictionary, file: FileEnum.file, attribute=""):
	
	var og_txt: TreeItem = table.create_item(root, column_names["Original Text"])
	
	if typeof(tl_shard["original text"]) == TYPE_ARRAY:
		og_txt.set_text(column_names["Original Text"], tl_shard["original text"])
	else:
		og_txt.set_text(column_names["Original Text"], tl_shard["original text"])
	
	


#----#


func add_column(header_name: String, column: int):
	
	if header_name == "":
		header_name = "test" + str(table.columns)
	
	table.set_column_title(column, header_name)


#----#


func combine_lines(lines: Array):
	
	var combined = ""
	
	for line in lines:
		combined += line
	
	return combined
