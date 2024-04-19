class_name FlowsheetFormulaContext
extends Object

# TODO: Define FlowSheet functions here
#       SUM(), etc?

func IF(cond, then_val, else_val):
	if cond:
		return then_val
	else:
		return else_val


func LENGTH(obj):
	return String(obj).length()


func TEXT(obj):
	return String(obj)

# TODO: Text functions (Count substrings in string, strip, take first/last/mid X chars)

# TODO: Rethink the formula language. Is it currently GD script?
#       Do I need to implement my own formula language?
