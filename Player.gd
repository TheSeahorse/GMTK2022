extends KinematicBody2D

signal enemy_detected
signal death_animation_finished

var move_speed: = 200
var move_speed_modifier: = 0
var attack_cooldown: float = 2.1
var attack_modifier = 0
var velocity = Vector2.ZERO
var friction: float

var can_attack = true
var is_attacking = false
var is_damaged: bool = false
var enemies_in_range = []
var enemies_on_player = []

var pushed = false
var alive = true

func _ready():
    friction = float(move_speed)/5000
    $Weapon.hide()


func _process(_delta):
    if can_attack == false:
        update_cooldown()


func _physics_process(_delta):
    calculate_movement()
    rotate_player_towards_mouse()
    is_player_attacked()
    check_raycast()


func _input(event):
    if event.is_action_pressed("attack") and can_attack:
        attack()


func calculate_movement():
    if not alive:
        return
    var current_move_speed = move_speed + 60 * move_speed_modifier
    var direction = get_direction()
    if direction.length() > 1.0:
        direction = direction.normalized()
    var target_velocity = direction * current_move_speed
    velocity += (target_velocity - velocity) * friction
    if velocity.length() > current_move_speed:
        if not pushed:
            velocity *= current_move_speed/velocity.length()
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
    if not alive:
        return
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
    if not alive:
        return
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
    if not alive:
        return
    $Weapon.show()
    $Weapon/AttackLength.start()
    $Cooldown/AttackCooldown.start()
    $Weapon/AnimationPlayer.play("swing")
    $AttackStream.play(0.25)
    can_attack = false
    is_attacking = true
    for enemy in enemies_in_range:
        enemy.die()

func update_cooldown():
    if not alive:
        $Cooldown.value = 0
        return

    var total_time = $Cooldown/AttackCooldown.get_wait_time()
    var time_left = $Cooldown/AttackCooldown.get_time_left()
    var percentage = float(time_left/total_time)
    $Cooldown.value = percentage * 100


func is_player_attacked():
    if not is_damaged:
        if not enemies_on_player.empty():
            is_damaged = true
            $DamagedTimer.start()
            $DamagedAnimation.play("damaged")
            emit_signal("enemy_detected", enemies_on_player.front())
            $DamageTakenStream.play(0.2)

func check_raycast():
    if is_attacking:
        $Weapon/WeaponArea/RayCast2D.force_raycast_update()
        if $Weapon/WeaponArea/RayCast2D.is_colliding():
            var collider = $Weapon/WeaponArea/RayCast2D.get_collider()
            collider.die()

func _on_EnemyDetector_body_entered(body):
    enemies_on_player.append(body)

func _on_EnemyDetector_body_exited(body):
    enemies_on_player.erase(body)

func set_attack_modifier(mod):
    attack_modifier = mod
    $Weapon.scale = Vector2(1 + 0.3 * mod, 1 + 0.3 * mod)

func set_movement_modifier(mod):
    move_speed_modifier = mod

func play_death_animation():
    alive = false
    $Sprite.play("death")

func _on_AttackCooldown_timeout():
    can_attack = true
    $Cooldown/AttackCooldown.wait_time = attack_cooldown

func _on_AttackLength_timeout():
    is_attacking = false
    $Weapon.hide()
    $Weapon/AnimationPlayer.stop()


func _on_Weapon_body_entered(body):
    enemies_in_range.append(body)


func _on_Weapon_body_exited(body):
    enemies_in_range.remove(enemies_in_range.find(body))


func _on_Sprite_animation_finished():
    if $Sprite.get_animation() == "death":
        $Sprite.stop()
        emit_signal("death_animation_finished")


func _on_DamagedTimer_timeout():
    is_damaged = false
    $DamagedAnimation.play("RESET")
