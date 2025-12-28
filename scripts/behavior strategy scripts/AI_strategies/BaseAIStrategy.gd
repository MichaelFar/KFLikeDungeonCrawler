extends Resource

class_name AIStrategy

signal has_finished_executing

var canBeInterrupted : bool = false

var canBeInitiated : bool = true

func populate_values(new_AI_data : InstanceAIData):
	pass
#Potentially, the strategy would be released by this string
#Allows for, say, charge attacks, or blocking as with original functionality
func execute_strategy(): 
	pass
	
func strategy_process(delta : float):
	pass
