class_name FlowsheetNode
extends Resource

enum Type { BOOL, INT, DECIMAL, PERCENTAGE, TEXT, DATETIME }

class DateTime:
	var value: String = "1990-12-31"

@export var id: int
@export var name: String = ""
@export var initial_value = 0
@export var type: Type = Type.INT
@export var accepts_input: bool = true
@export var position: Vector2 = Vector2.ZERO

var value = initial_value


static func default_value(node_type: Type):
	match node_type:
		Type.BOOL:
			return false
		Type.INT:
			return 0
		Type.DECIMAL, Type.PERCENTAGE:
			return 0.0
		Type.TEXT:
			return ""
		Type.DATETIME:
			return DateTime.new()
	push_error("Invalid Type")
	return null


static func to_text(node_value, node_type: Type) -> String:
	match node_type:
		Type.BOOL: # Switch
			var val := node_value as bool
			return "ON" if val else "OFF"
		Type.INT: # Integer
			var val := node_value as int
			return "%d" % val
		Type.DECIMAL: # Decimal
			var val := node_value as float
			return "%.2f" % val
		Type.PERCENTAGE: # Percentage
			var val := node_value as float
			return "%.1f%%" % (val * 100.0)
		Type.TEXT: # Text
			var val := node_value as String
			return "'%s'" % val
		Type.DATETIME:
			var val := node_value as DateTime
			return "%s" % val.value
	push_error("Invalid Type")
	return "???"


static func type_name(node_type: Type) -> String:
	match node_type:
		Type.BOOL: # Switch
			return "Switch"
		Type.INT: # Integer
			return "Integer"
		Type.DECIMAL: # Decimal
			return "Decimal"
		Type.PERCENTAGE: # Percentage
			return "Percentage"
		Type.TEXT: # Text
			return "Text"
		Type.DATETIME:
			return "Datetime"
	push_error("Invalid Type")
	return "???"

