extends KinematicBody2D

onready var Projectile = preload("res://Enemy2Projectile.tscn")

var move_target: KinematicBody2D
var speed = 50

func _ready():
    $AnimatedSprite.play()


func _process(_delta):
    var velocity = position.direction_to(move_target.position) * speed
    velocity = move_and_slide(velocity)

func set_move_target(target: KinematicBody2D):
    move_target = target

func attack():
    var p = Projectile.instance()
    var direction = position.direction_to(move_target.position)
    p.set_direction(direction)
    p.position = position
    get_parent().add_child(p)


func _on_AttackTimer_timeout():
    attack()

func die():
    self.queue_free()
