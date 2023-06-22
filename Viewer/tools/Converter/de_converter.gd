extends Node


## Map block: {"original text":["", ""], "info":{"code":0, "indent":0} "cells":[{"text":[], "cell_name":""}]}


##--------------------------------------------------------##

func id_looper(entry_array: Array, entry_handler: Callable) -> Array:
	
	var converted_data = []
	
	for entry in entry_array:
		if entry != null:
			converted_data.append(entry_handler.call(entry))
	
	return converted_data

##--------------------------------------------------------##
## Handlers ##
