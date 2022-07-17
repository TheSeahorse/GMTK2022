extends Control


func _ready():
    $HowToPlay.hide()

func _on_StartButton_pressed():
    get_tree().change_scene("res://Game.tscn")

func _on_HowToPlayButton_pressed():
    $Buttons.hide()
    $HowToPlay/AnimationPlayer.play("coin_move")
    $HowToPlay.show()


func _on_HowToPlayTexture_pressed():
    $HowToPlay.hide()
    $HowToPlay/AnimationPlayer.play("RESET")
    $Buttons.show()


func _on_QuitButton_pressed():
    $Buttons/QuitButton.hide()
