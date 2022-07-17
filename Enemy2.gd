extends "res://Enemy.gd"

signal shoot
onready var Projectile = preload("res://Enemy2Projectile.tscn")

var speed = 50


func _physics_process(_delta):
    if frozen:
        return
    var velocity = position.direction_to(move_target.position) * speed
    velocity = move_and_slide(velocity)

func set_move_target(target: KinematicBody2D):
    move_target = target

func shoot():
    if frozen:
        return
    var direction = position.direction_to(move_target.position)
    emit_signal("shoot", self.position, direction)
    $FireStream.play(0.5)

func _on_AttackTimer_timeout():
    $AnimatedSprite.play("shooting")


func _on_AnimatedSprite_frame_changed():
    if $AnimatedSprite.animation == "shooting" and $AnimatedSprite.frame == 3:
        shoot()


func _on_AnimatedSprite_animation_finished():
    if $AnimatedSprite.animation == "shooting":
        $AnimatedSprite.play("flying")
