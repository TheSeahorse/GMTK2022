extends KinematicBody2D

var direction: Vector2
var speed = 600

func _ready():
    pass # Replace with function body.

func _physics_process(_delta):
    move_and_slide(direction * speed)

func set_direction(new_direction: Vector2):
    direction = new_direction
