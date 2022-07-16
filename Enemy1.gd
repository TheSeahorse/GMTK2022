extends "res://Enemy.gd"

var speed = 200

func _physics_process(_delta):
    var velocity = position.direction_to(move_target.position) * speed
    velocity = move_and_slide(velocity)

func set_move_target(target: KinematicBody2D):
    move_target = target
