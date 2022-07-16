extends Area2D

export var value = 1
export var stat = "health"
var new_value: int


func update_value(new_value: int):
    $Value.play(str(new_value))
    value = new_value


