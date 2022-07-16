extends KinematicBody2D

signal enemy_detected

var move_speed: = 300

var velocity = Vector2.ZERO
var friction: float


func _ready():
    friction = float(move_speed)/5000


func _physics_process(_delta):
    calculate_movement()
    rotate_player_towards_move()


func calculate_movement():
    var direction = get_direction()
    if direction.length() > 1.0:
        direction = direction.normalized()
    var target_velocity = direction * move_speed
    velocity += (target_velocity - velocity) * friction
    if velocity.length() > move_speed:
        velocity *= move_speed/velocity.length()
    move_and_slide(velocity)


func get_direction() -> Vector2:
    var direction = Vector2.ZERO
    direction.x = Input.get_axis("move_left", "move_right")
    direction.y = Input.get_axis("move_up", "move_down")
    return direction

#for rotating towards the direction you're moving
func rotate_player_towards_move():
    var move_direction = velocity.normalized()
    var move_rotation = rad2deg(move_direction.angle())
    move_rotation = wrapf(move_rotation, 0, 360)
    if velocity.length() <= 20:
        if $Sprite.get_animation() == "move_right":
            $Sprite.play("idle_right")
        elif $Sprite.get_animation() == "move_left":
            $Sprite.play("idle_left")
        elif $Sprite.get_animation() == "move_up":
            $Sprite.play("idle_up")
        elif $Sprite.get_animation() == "move_down":
            $Sprite.play("idle_down")
    elif move_rotation < 45 or move_rotation >= 315:
        $Sprite.play("move_right")
    elif move_rotation < 135 and move_rotation >= 45:
        $Sprite.play("move_down")
    elif move_rotation < 225 and move_rotation >= 135:
        $Sprite.play("move_left")
    elif move_rotation < 315 and move_rotation >= 225:
        $Sprite.play("move_up")

#for rotating the player relative to the mouse
func rotate_player_towards_mouse():
    var aim_direction: Vector2
    aim_direction = position.direction_to(get_viewport().get_mouse_position()).normalized()
    var aim_rotation = rad2deg(aim_direction.angle())
    aim_rotation = wrapf(aim_rotation, 0, 360)
    if velocity.length() <= 10:
        $Sprite.play("idle")
    elif aim_rotation < 45 or aim_rotation >= 315:
        $Sprite.play("move_right")
    elif aim_rotation < 135 and aim_rotation >= 45:
        $Sprite.play("move_down")
    elif aim_rotation < 225 and aim_rotation >= 135:
        $Sprite.play("move_left")
    elif aim_rotation < 315 and aim_rotation >= 225:
        $Sprite.play("move_up")

func _on_EnemyDetector_body_entered(body):
    print("Player detected enemy")
    emit_signal("enemy_detected", body)
