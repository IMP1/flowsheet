class_name FlowsheetFormula
extends RefCounted

# TODO: Make this its own thing D:

var _expr: Expression = Expression.new()


func parse(code: String) -> Error:
	return _expr.parse(code, ["IN", "OUT"])


func execute(args: Array):
	var context := FlowsheetFormulaContext.new() # TODO: Can this be put in this class somehow?
	return _expr.execute(args, context)


func get_error_text() -> String:
	return _expr.get_error_text()


func has_execute_failed() -> bool:
	return _expr.has_execute_failed()
