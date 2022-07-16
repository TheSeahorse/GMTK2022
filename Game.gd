extends Node2D

onready var Enemy = preload("res://Enemy.tscn")
onready var Player = preload("res://Player.tscn")

var GAME_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var GAME_WIDTH = ProjectSettings.get_setting("display/window/size/width")

var rng = RandomNumberGenerator.new()
var player
var enemies = []

func _ready():
    rng.randomize()
    player = Player.instance()
    player.position = Vector2(200,200)
    player.connect("enemy_detected", self, "_player_detected_enemy")
    add_child(player)
    add_enemy()

func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.scancode == KEY_SPACE:
            var popped_enemy = enemies.pop_back()
            popped_enemy.queue_free()
            add_enemy()

func add_enemy():
    var enemy = Enemy.instance()
    enemy.position = get_enemy_spawnable_position()
    call_deferred("add_child", enemy)
    enemies.append(enemy)

func get_enemy_spawnable_position():
    var x = rng.randi_range(200, 1720)
    var y = rng.randi_range(200, 880)
    var pos = Vector2(x, y)
    if player.position.distance_to(pos) < 300:
        return get_enemy_spawnable_position()
    else:
        return pos

func _player_detected_enemy(body):
    add_enemy()
    enemies.erase(body)
    body.queue_free()

func _process(_delta):
    for enemy in enemies:
        enemy.set_move_target(player.position)
