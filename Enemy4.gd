extends "res://Enemy.gd"

signal shoot
var rotational_position: String

func _ready():
    if randi() % 2 == 0:
        rotational_position = "diagonal"
        $AnimatedSprite.play("diagonal_idle")
    else:
        rotational_position = "vertical"
        $AnimatedSprite.play("vertical_idle")


func _on_ShootTimer_timeout():
    $AnimatedSprite.play(rotational_position + "_shoot")
    $ChargeTimer.start()


func _on_ChargeTimer_timeout():
    if frozen:
        return
    $Laser.play()
    var counter = 1
    if rotational_position == "vertical":
        for pos in $Vertical.get_children():
            var direction
            match counter:
                1:
                    direction = Vector2(1,0)
                2:
                    direction = Vector2(0,1)
                3:
                    direction = Vector2(-1,0)
                4:
                    direction = Vector2(0,-1)
            emit_signal("shoot", self.position + pos.position, direction)
            counter += 1
    else:
        for pos in $Diagonal.get_children():
            var direction
            match counter:
                1:
                    direction = Vector2(1,1).normalized()
                2:
                    direction = Vector2(-1,1).normalized()
                3:
                    direction = Vector2(-1,-1).normalized()
                4:
                    direction = Vector2(1,-1).normalized()
            emit_signal("shoot", self.position + pos.position, direction)
            counter += 1
    $AnimatedSprite.play(rotational_position + "_idle")
    $SpinTimer.start()
    $ShootTimer.start(randi() % 2 + 2)


func _on_SpinTimer_timeout():
    if rotational_position == "diagonal":
        rotational_position = "vertical"
    else:
        rotational_position = "diagonal"
    $AnimatedSprite.play("spin_" + rotational_position)


func _on_AnimatedSprite_animation_finished():
    if $AnimatedSprite.animation == "spin_vertical":
        $AnimatedSprite.play("vertical_idle")
    elif $AnimatedSprite.animation == "spin_diagonal":
        $AnimatedSprite.play("diagonal_idle")
