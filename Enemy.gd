extends KinematicBody2D


var move_target: KinematicBody2D
var speed = 200

func _ready():
    $AnimatedSprite.play()


func _process(_delta):
    var velocity = position.direction_to(move_target.position) * speed
    velocity = move_and_slide(velocity)

func set_move_target(target: KinematicBody2D):
    move_target = target


func die():
    self.queue_free()
