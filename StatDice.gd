extends Area2D

signal updated

export var value = 1
export var stat = "health"
var new_max_value: int
var extra_rolls = 0


func update_value(max_val: int):
    new_max_value = max_val 
    extra_rolls = 6
    extra_roll()
    

func extra_roll():
    if extra_rolls == 0:
        emit_signal("signal")
        value = randi() % new_max_value + 1
        $Value.play(str(value))
        $ColorRect.show()
        $ColorTimer.start()
    else:
        var new = randi() % new_max_value + 1
        while new == int($Value.get_animation()):
            new = randi() % new_max_value + 1
        $Value.play(str(new))
        extra_rolls -= 1
        $ExtraRollTimer.start(0.05 * (7 - extra_rolls))


func _on_ColorTimer_timeout():
    $ColorRect.hide() 
