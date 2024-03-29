extends Camera2D

var shake_amount = 0
onready var default_offset = offset


func _ready():
    set_process(false)


func _process(delta):
    offset = Vector2(rand_range(-shake_amount, shake_amount), rand_range(-shake_amount, shake_amount)) * delta + default_offset


func shake(new_shake, shake_time=0.6, shake_limit=1000):
    shake_amount += new_shake
    if shake_amount > shake_limit:
        shake_amount = shake_limit
    $Timer.wait_time = shake_time
    $Tween.stop_all()
    set_process(true)
    $Timer.start()


func _on_Timer_timeout():
    shake_amount = 0
    set_process(false)
    $Tween.interpolate_property(self, "offset", offset, default_offset, 0.1, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
    $Tween.start()
