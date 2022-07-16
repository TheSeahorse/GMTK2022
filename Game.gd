extends Node2D

onready var Enemy = preload("res://Enemy.tscn")
onready var Enemy2 = preload("res://Enemy2.tscn")
onready var Player = preload("res://Player.tscn")
onready var Dice = preload("res://Dice.tscn")

var GAME_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var GAME_WIDTH = ProjectSettings.get_setting("display/window/size/width")

var rng = RandomNumberGenerator.new()
var player
var player_health = 3

func _ready():
    rng.randomize()
    player = Player.instance()
    player.position = Vector2(400,400)
    player.connect("enemy_detected", self, "_player_detected_enemy")
    add_child(player)
    add_enemy()


func add_enemy():
    var enemyType = rng.randi_range(0, 1)
    var enemy
    if enemyType == 0:
        enemy = Enemy.instance()
    if enemyType == 1:
        enemy = Enemy2.instance()

    enemy.position = get_enemy_spawnable_position()
    enemy.set_move_target(player)
    $Enemies.call_deferred("add_child", enemy)
    enemy.set_move_target(player)
    enemy.connect("died", self, "_enemy_died")

func get_enemy_spawnable_position():
    var x = rng.randi_range(200, 1720)
    var y = rng.randi_range(200, 880)
    var pos = Vector2(x, y)
    if player.position.distance_to(pos) < 300:
        return get_enemy_spawnable_position()
    else:
        return pos

func _player_detected_enemy(body):
    var layer = body.get_collision_layer()
    if layer == 8: # Projectile
        body.queue_free()
    if layer == 4: # Enemy
        player.push(body.position.direction_to(player.position))
    if player_health > 1:
        player_health -= 1
    else:
        get_tree().change_scene("res://Menu.tscn")

func _enemy_died(position: Vector2):
    var dice = Dice.instance()
    dice.position = position
    add_child(dice)

func _process(_delta):
    pass

func _on_EnemySpawnTimer_timeout():
    add_enemy()
