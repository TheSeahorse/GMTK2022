extends KinematicBody2D

var direction: Vector2
var speed = 600

func _ready():
    $AnimatedSprite.play()

func _physics_process(_delta):
    move_and_slide(direction * speed)

func get_direction() -> Vector2:
    return direction

func set_direction(new_direction: Vector2):
    direction = new_direction
