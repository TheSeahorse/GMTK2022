extends KinematicBody2D


var move_target: Vector2
var speed = 200

func _ready():
    pass # Replace with function body.


func _process(delta):
    var velocity = position.direction_to(move_target) * speed
    velocity = move_and_slide(velocity)

func set_move_target(target: Vector2):
    move_target = target
