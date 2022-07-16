extends Area2D

export var value = 1
export var stat = "health"
var new_value: int
signal updated


func update_value(new_value: int):
    $Value.play(str(new_value))
    value = new_value
    emit_signal("updated")
