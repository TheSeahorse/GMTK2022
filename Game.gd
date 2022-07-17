extends Node2D

onready var Enemy = preload("res://Enemy.tscn")
onready var Enemy2 = preload("res://Enemy2.tscn")
onready var Enemy3 = preload("res://Enemy3.tscn")
onready var Enemy4 = preload("res://Enemy4.tscn")
onready var Player = preload("res://Player.tscn")
onready var Dice = preload("res://Dice.tscn")
onready var Goal = preload("res://Goal.tscn")
onready var Projectile2 = preload("res://Enemy2Projectile.tscn")
onready var Projectile4 = preload("res://Enemy4Projectile.tscn")

onready var CursorHold = preload("res://assets/HUD/cursor_hold_small.png")
onready var CursorRegular = preload("res://assets/HUD/cursor_reg_small.png")

var GAME_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var GAME_WIDTH = ProjectSettings.get_setting("display/window/size/width")

var rng = RandomNumberGenerator.new()
var player
var player_health = 1
var level = 1
var lev_clear = false
var level1 = [[1]]
var level2 = [[2],[1,1,2]]
var level3 = [[3],[2,2,3],[1,2,3,3]]
var level4 = [[4],[1,3,4],[4,4,4],[1,2,3,4]]
var level5 = [[1,1,1],[2,2,2],[3,3,3],[4,4,4],[1,1,2,2,3,3,4,4]]
var wave = 1
var wave_over = false
var in_transition = true
var spawned_first_wave = false
var current_cursor

func _ready():
    rng.randomize()
    player = Player.instance()
    player.position = Vector2(400,400)
    player.connect("enemy_detected", self, "_player_detected_enemy")
    player.z_index = 1
    add_child(player)
    $AnimationPlayer.play("Level1")


func _physics_process(_delta):
    if not in_transition and spawned_first_wave:
        check_cursor_hold()
        check_cleared_wave()


func check_cursor_hold():
    var already_held = false
    for coin in $Coins.get_children():
        if coin.holding and already_held:
            coin.holding = false
        elif coin.holding:
            already_held = true
    if already_held:
        if not current_cursor == CursorHold:
            Input.set_custom_mouse_cursor(CursorHold)
            current_cursor = CursorHold
    else:
        if not current_cursor == CursorRegular:
            Input.set_custom_mouse_cursor(CursorRegular)
            current_cursor = CursorRegular


func check_cleared_wave():
    print(str($Enemies.get_child_count()))
    if $Enemies.get_child_count() < 1:
        if wave == level:
            level_cleared()
        else:
            wave_cleared()

func level_cleared():
    if lev_clear:
        return
    lev_clear = true
    var goal = Goal.instance()
    var pos = get_enemy_spawnable_position()
    goal.position = pos
    goal.connect("player_entered", self, "_entered_goal", [goal])
    call_deferred("add_child", goal)

func wave_cleared():
    print("wave_cleared")
    if wave_over:
        return
    wave_over = true
    wave += 1
    spawn_wave()

func start_level():
    lev_clear = false
    wave_over = false
    wave = 1
    spawn_wave()
    in_transition = false
    spawned_first_wave = true

func spawn_wave():
    print("spawn_wave")
    var waves
    match level:
        1:
            waves = level1
        2:
            waves = level2
        3:
            waves = level3
        4:
            waves = level4
        5:
            waves = level5
    for enemy in waves[wave-1]:
        add_enemy(enemy)
    wave_over = false


func add_enemy(enemy_type: int):
    var enemy
    if enemy_type == 1:
        enemy = Enemy.instance()
    if enemy_type == 2:
        enemy = Enemy2.instance()
        enemy.connect("shoot",self,"_spawn_enemy_two_projectile")
    if enemy_type == 3:
        enemy = Enemy3.instance()
        enemy.connect("shake", self, "_camera_shake")
    if enemy_type == 4:
        enemy = Enemy4.instance()
        enemy.connect("shoot", self, "_spawn_enemy_four_projectile")

    enemy.position = get_enemy_spawnable_position()
    enemy.set_move_target(player)
    $Enemies.call_deferred("add_child", enemy)
    enemy.set_move_target(player)
    enemy.connect("died", self, "_enemy_died")

func get_enemy_spawnable_position():
    var x = rng.randi_range(180, GAME_WIDTH - 180)
    var y = rng.randi_range(420, GAME_HEIGHT - 180)
    var pos = Vector2(x, y)
    if player.position.distance_to(pos) < 300:
        return get_enemy_spawnable_position()
    else:
        return pos

func _camera_shake(amount, time=0.6, limit=1000):
    $Camera.shake(amount, time, limit)

func _entered_goal(goal):
    for p in $Projectiles.get_children():
        p.queue_free()
    for c in $Coins.get_children():
        c.queue_free()
    goal.queue_free()
    level += 1
    in_transition = true
    spawned_first_wave = false
    $AnimationPlayer.play("Level" + str(level))

func _player_detected_enemy(body):
    var layer = body.get_collision_layer()
    if layer == 8: # Projectile
        player.push(body.get_direction(), 2)
        body.queue_free()
    if layer == 4: # Enemy
        player.push(body.position.direction_to(player.position), 5)
    if player_health > 1:
        player_health -= 1
        $Hud.decrease_all()
    else:
        player.play_death_animation()
        $GameOverTimer.start()


func _enemy_died(position: Vector2):
    var dice = Dice.instance()
    dice.position = position
    $Coins.call_deferred("add_child", dice)


func _on_Hud_stats_updated():
    player_health = $Hud.get_health_stat()
    player.set_movement_modifier($Hud.get_speed_stat())
    player.set_attack_modifier($Hud.get_cooldown_stat())


func _on_GameOverTimer_timeout():
    get_tree().change_scene("res://Menu.tscn")


func _spawn_enemy_two_projectile(pos: Vector2, direction: Vector2):
    var p = Projectile2.instance()
    p.position = pos
    p.set_direction(direction)
    $Projectiles.call_deferred("add_child", p)

func _spawn_enemy_four_projectile(pos: Vector2, direction: Vector2):
    var p = Projectile4.instance()
    p.position = pos
    p.set_direction(direction)
    $Projectiles.call_deferred("add_child", p)


func _on_AnimationPlayer_animation_finished(anim_name):
    start_level()


func _middle_of_animation():
    $Background.play(str(level))
    var new_song: AudioStreamPlayer = get_node("Music/Level" + str(level))
    if level == 1:
        new_song.play()
    else:
        var playing_song: AudioStreamPlayer = get_node("Music/Level" + str(level-1))
        new_song.play(playing_song.get_playback_position())
        playing_song.stop()

