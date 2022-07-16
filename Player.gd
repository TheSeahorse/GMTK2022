extends KinematicBody2D

signal enemy_detected

var move_speed: = 300
var velocity = Vector2.ZERO
var friction: float

var can_attack = true
var is_attacking = false
var enemies_in_range = []

var pushed = false

func _ready():
    friction = float(move_speed)/5000


func _process(delta):
    if can_attack == false:
        update_cooldown()


func _physics_process(_delta):
    calculate_movement()
    rotate_player_towards_mouse()


func _input(event):
    if event.is_action_pressed("attack") and can_attack:
        attack()


func calculate_movement():
    var direction = get_direction()
    if direction.length() > 1.0:
        direction = direction.normalized()
    var target_velocity = direction * move_speed
    velocity += (target_velocity - velocity) * friction
    if velocity.length() > move_speed:
        if not pushed:
            velocity *= move_speed/velocity.length()
    else:
        pushed = false
    move_and_slide(velocity)


func get_direction() -> Vector2:
    var direction = Vector2.ZERO
    direction.x = Input.get_axis("move_left", "move_right")
    direction.y = Input.get_axis("move_up", "move_down")
    return direction


func push(direction: Vector2, push_speed):
    pushed = true
    velocity = direction * move_speed * push_speed


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
    rotate_weapon(aim_rotation)
    if velocity.length() <= 20:
        if aim_rotation < 45 or aim_rotation >= 315:
            $Sprite.play("idle_right")
        elif aim_rotation < 135 and aim_rotation >= 45:
            $Sprite.play("idle_down")
        elif aim_rotation < 225 and aim_rotation >= 135:
            $Sprite.play("idle_left")
        elif aim_rotation < 315 and aim_rotation >= 225:
            $Sprite.play("idle_up")
    elif aim_rotation < 45 or aim_rotation >= 315:
        $Sprite.play("move_right")
    elif aim_rotation < 135 and aim_rotation >= 45:
        $Sprite.play("move_down")
    elif aim_rotation < 225 and aim_rotation >= 135:
        $Sprite.play("move_left")
    elif aim_rotation < 315 and aim_rotation >= 225:
        $Sprite.play("move_up")


func rotate_weapon(dir):
    if not is_attacking:
        $Weapon.rotation_degrees = dir

func attack():
    $Weapon.show()
    $Weapon/AttackLength.start()
    $Cooldown/AttackCooldown.start()
    can_attack = false
    is_attacking = true
    for enemy in enemies_in_range:
        enemy.die()

func update_cooldown():
    var total_time = $Cooldown/AttackCooldown.get_wait_time()
    var time_left = $Cooldown/AttackCooldown.get_time_left()
    var percentage = float(time_left/total_time)
    $Cooldown.value = percentage * 100


func _on_EnemyDetector_body_entered(body):
    emit_signal("enemy_detected", body)


func _on_AttackCooldown_timeout():
    can_attack = true

func _on_AttackLength_timeout():
    is_attacking = false
    $Weapon.hide()


func _on_Weapon_body_entered(body):
    enemies_in_range.append(body)


func _on_Weapon_body_exited(body):
    enemies_in_range.remove(enemies_in_range.find(body))
