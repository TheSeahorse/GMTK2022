extends Control

onready var SoundManager = get_node("/root/SoundManager")

func _ready():
    $HowToPlay.hide()
    SoundManager.play_menu_music()

func _on_StartButton_pressed():
    SoundManager.stop_menu_music()
    get_tree().change_scene("res://Game.tscn")

func _on_HowToPlayButton_pressed():
    $Logo.hide()
    $Buttons.hide()
    $HowToPlay/AnimationPlayer.play("coin_move")
    $HowToPlay.show()


func _on_HowToPlayTexture_pressed():
    $Logo.show()
    $HowToPlay.hide()
    $HowToPlay/AnimationPlayer.play("RESET")
    $Buttons.show()


func _on_QuitButton_pressed():
    $Buttons/QuitButton.hide()
