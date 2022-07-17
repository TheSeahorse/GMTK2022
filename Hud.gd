extends Node2D

signal stats_updated

func _on_StatDice_updated():
    emit_signal("stats_updated")

func get_health_stat():
    return $StatDice.value

func get_speed_stat():
    return $StatDice3.value

func get_cooldown_stat():
    return $StatDice2.value
