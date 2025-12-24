extends Resource

class_name Strategy

signal has_finished_executing

var canBeInterrupted : bool = false

var canBeInitiated : bool = true

func populate_values(new_weapon_data : InstanceWeaponData):
	pass
#Potentially, the strategy would be released by this string
#Allows for, say, charge attacks, or blocking as with original functionality
func execute_strategy(release_input_string : String): 
	pass
	
func strategy_process(delta : float):
	pass
