extends "res://Enemy.gd"

signal shake

var speed = 300
var seeking = true
var falling = false
var rising = false


func _ready():
    $Shadow.play("seeking")

func _physics_process(_delta):
    if seeking:
        if position.distance_to(move_target.position) < 5:
            seeking = false
            $SeekingTimer.stop()
            fall()
        else:
            var velocity = position.direction_to(move_target.position) * speed
            velocity = move_and_slide(velocity)
    else:
        move_and_slide(Vector2.ZERO)


func fall():
    $Tween.interpolate_property($AnimatedSprite, "position", null, $Shadow.position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
    $Tween.start()
    $AnimatedSprite.play("falling")
    $Shadow.play("falling")
    falling = true


func land():
    $CollisionShape2D.call_deferred("set_disabled", false)
    $AnimatedSprite.play("landing")
    $Shadow.play("landing")
    $LandTimer.start()
    emit_signal("shake", 500)
    

func seek():
    seeking = true


func rise():
    $CollisionShape2D.call_deferred("set_disabled", true)
    $Tween.interpolate_property($AnimatedSprite, "position", null, Vector2(0,-1400), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
    $Tween.start()
    $AnimatedSprite.play("rising")
    $Shadow.play("rising")
    rising = true


func _on_Tween_tween_all_completed():
    if falling:
        falling = false
        land()
    if rising:
        rising = false
        seek()


func _on_LandTimer_timeout():
    rise()


func _on_SeekingTimer_timeout():
    seeking = false
    fall()
