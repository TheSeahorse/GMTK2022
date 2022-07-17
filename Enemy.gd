extends KinematicBody2D

signal died
var move_target
var frozen = true

func _ready():
    $AnimatedSprite.hide()
    $Spawn.show()
    $Spawn.play()
    $Death.hide()

func set_move_target(target: KinematicBody2D):
    move_target = target

func die():
    frozen = true
    $AnimatedSprite.hide()
    $Death.show()
    $Death.play()
    $CollisionShape2D.call_deferred("set_disabled", true)


func _on_Spawn_animation_finished():
    $AnimatedSprite.show()
    $AnimatedSprite.play()
    $Spawn.hide()
    frozen = false


func _on_Death_animation_finished():
    emit_signal("died", position)
    self.queue_free()
