extends Node2D

onready var Enemy = preload("res://Enemy.tscn")
onready var Player = preload("res://Player.tscn")

var GAME_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var GAME_WIDTH = ProjectSettings.get_setting("display/window/size/width")

var player
var enemy

func _ready():
    player = Player.instance()
    player.position = Vector2(200,200)
    add_child(player)
    enemy = Enemy.instance()
    enemy.position = Vector2(800,800)
    add_child(enemy)

func _process(_delta):
    enemy.set_move_target(player.position)
