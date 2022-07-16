extends KinematicBody2D

signal died
var move_target

func _ready():
    $AnimatedSprite.play()

func set_move_target(target: KinematicBody2D):
    move_target = target

func die():
    emit_signal("died", position)
    self.queue_free()
