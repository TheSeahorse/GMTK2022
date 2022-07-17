extends KinematicBody2D

signal died
var move_target
var frozen = true

func _ready():
    $AnimatedSprite.hide()
    $Spawn.show()
    $Spawn.play()
    $Death.hide()
    var timer = Timer.new()
    timer.one_shot = true
    timer.wait_time = 0.83
    timer.connect("timeout",self,"_on_SpawnTimer_timeout")
    add_child(timer)
    timer.start()

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


func _on_SpawnTimer_timeout():
    $AnimatedSprite.show()
