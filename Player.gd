extends KinematicBody2D

var move_speed: = 100
var velocity = Vector2.ZERO
var friction: float


func _ready():
    friction = float(move_speed)/5000


func _physics_process(_delta):
    calculate_movement()
    rotate_player()


func calculate_movement():
    var direction = get_direction()
    if direction.length() > 1.0:
        direction = direction.normalized()
    var target_velocity = direction * move_speed
    velocity += (target_velocity - velocity) * friction
    if velocity.length() > move_speed:
        velocity *= move_speed/velocity.length()
    velocity = move_and_slide(velocity)


func get_direction() -> Vector2:
    var direction = Vector2.ZERO
    direction.x = Input.get_axis("move_left", "move_right")
    direction.y = Input.get_axis("move_up", "move_down")
    return direction

#for rotating the player relative to the mouse
func rotate_player():
    var aim_direction: Vector2
    aim_direction = position.direction_to(get_viewport().get_mouse_position()).normalized()
    var aim_rotation = rad2deg(aim_direction.angle())
    aim_rotation = wrapf(aim_rotation, 0, 360)
    #if aim_rotation < 45 or aim_rotation >= 315:
    #	$Sprite.play("right")
    #elif aim_rotation < 135 and aim_rotation >= 45:
    #	$Sprite.play("down")
    #elif aim_rotation < 225 and aim_rotation >= 135:
    #	$Sprite.play("left")
    #elif aim_rotation < 315 and aim_rotation >= 225:
    #	$Sprite.play("up")
