extends Area2D

signal player_entered


func _ready():
    $AnimatedSprite.play("spawn")


func _on_AnimatedSprite_animation_finished():
    if $AnimatedSprite.animation == "spawn":
        $AnimatedSprite.play("idle")

func _on_Goal_body_entered(body):
    emit_signal("player_entered")
