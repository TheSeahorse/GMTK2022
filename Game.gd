extends Node2D

onready var Player = preload("res://Player.tscn")

var GAME_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var GAME_WIDTH = ProjectSettings.get_setting("display/window/size/width")

var player

func _ready():
    player = Player.instance()
    player.position = Vector2(200,200)
    add_child(player)
