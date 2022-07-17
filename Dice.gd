extends Area2D

var max_value = 6
var mouse_over = false
var stat_box_over = false
var stat_box: Area2D = null

func _ready():
    if randi() % 2 == 0:
        $AnimatedSprite.flip_h = true

func _process(_delta):
    if Input.is_mouse_button_pressed(1) and mouse_over:
        self.position = get_viewport().get_mouse_position()
    if Input.is_action_just_released("left_click") and mouse_over and stat_box_over:
        stat_box.update_value(max_value)
        self.queue_free()


func _on_Dice_mouse_entered():
    mouse_over = true


func _on_Dice_mouse_exited():
    mouse_over = false


func _on_Dice_area_entered(area):
    stat_box_over = true
    stat_box = area

func _on_Dice_area_exited(_area):
    stat_box_over = false
    stat_box = null
