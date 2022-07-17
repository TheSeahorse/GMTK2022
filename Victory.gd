extends Node2D

var GAME_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var GAME_WIDTH = ProjectSettings.get_setting("display/window/size/width")
onready var Coin = preload("res://Dice.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
    rng.randomize()

func _on_CoinTimer_timeout():
    var rndX = rng.randi_range(0, GAME_WIDTH)
    var rndY = rng.randi_range(0, GAME_HEIGHT)
    var coin = Coin.instance()
    coin.position = Vector2(rndX, rndY)
    $Coins.add_child(coin)
