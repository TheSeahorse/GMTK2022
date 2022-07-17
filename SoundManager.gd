extends Node

onready var FadeOutTween = get_node("FadeOut")
onready var FadeInTween = get_node("FadeIn")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE


func fade_in(stream: AudioStreamPlayer):
    stream.play()
    FadeInTween.interpolate_property(stream, "volume_db", -80, 0, transition_duration, transition_type, Tween.EASE_IN, 0)
    FadeInTween.start()

func fade_out(stream: AudioStreamPlayer):
    FadeOutTween.interpolate_property(stream, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
    FadeOutTween.start()

func play_menu_music():
    fade_in($MenuMusic)

func stop_menu_music():
    fade_out($MenuMusic)

func _on_FadeOut_tween_completed(object, key):
    if object is AudioStreamPlayer:
        object.stop()
