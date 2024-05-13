class_name FlowsheetFormulaContext
extends Object

# Flow

func IF(cond, then_val, else_val):
	if cond:
		return then_val
	else:
		return else_val

# Arithmetic

func ROUND_DOWN(val):
	return floor(val)

func ROUND_UP(val):
	return ceil(val)

func ROUND(val):
	return round(val)

func POW(base, exponent):
	return pow(base, exponent)

func HIGHEST(val_1, val_2): # If varargs get introduced, this would be a good candidate for it.
	return max(val_1, val_2)

func LOWEST(val_1, val_2): # If varargs get introduced, this would be a good candidate for it.
	return min(val_1, val_2)

func AND(val_1, val_2): # If varargs get introduced, this would be a good candidate for it.
	return val_1 and val_2

func OR(val_1, val_2): # If varargs get introduced, this would be a good candidate for it.
	return val_1 or val_2

func NOT(val_1):
	return not val_1

# String Functions

func LENGTH(obj):
	return str(obj).length()

# Type Conversions

func TEXT(obj):
	return str(obj)

# TODO: Text functions (Count substrings in string, strip, take first/last/mid X chars)

# TODO: Rethink the formula language. Is it currently GD script?
#       Do I need to implement my own formula language?

# TODO: Define FlowSheet functions here
#       SUM(), etc?
