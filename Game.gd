extends Node2D

onready var Enemy = preload("res://Enemy.tscn")
onready var Player = preload("res://Player.tscn")

var GAME_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var GAME_WIDTH = ProjectSettings.get_setting("display/window/size/width")

var rng = RandomNumberGenerator.new()
var player

func _ready():
    rng.randomize()
    player = Player.instance()
    player.position = Vector2(200,200)
    player.connect("enemy_detected", self, "_player_detected_enemy")
    add_child(player)
    add_enemy()


func add_enemy():
    var enemy = Enemy.instance()
    enemy.position = get_enemy_spawnable_position()
    enemy.set_move_target(player)
    $Enemies.call_deferred("add_child", enemy)
    enemy.set_move_target(player)

func get_enemy_spawnable_position():
    var x = rng.randi_range(200, 1720)
    var y = rng.randi_range(200, 880)
    var pos = Vector2(x, y)
    if player.position.distance_to(pos) < 300:
        return get_enemy_spawnable_position()
    else:
        return pos

func _player_detected_enemy(_body):
    get_tree().change_scene("res://Menu.tscn")

func _process(_delta):
    print($Enemies.get_child_count())

func _on_EnemySpawnTimer_timeout():
    add_enemy()
