extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationPlayer.play("idle")

func attack_player():
    var animation_player: AnimationPlayer = get_node("AnimationPlayer")
    var player: Node2D = get_node("/root/Root/%Player")
    var player_head: Node2D = get_node("/root/Root/%Player/Character/Polygon/Polygon head")
    var head_offset = player_head.global_position - player.global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
    var arm: Polygon2D = get_node("Polygon/Polygon lord arm front")
    var attached_spear: Polygon2D = get_node("Polygon/Polygon spear")
    var camera: Camera2D = get_viewport().get_camera_2d()
    var spear: Polygon2D = attached_spear.duplicate()
    var bark_player : AudioStreamPlayer2D = get_node("/root/Root/BarkPlayer")
    var death_menu : DeathMenu = %DeathMenu
    bark_player.stream = load("res://audio/characters/lord/ahh2.mp3")
    
    var tween: Tween = create_tween()
    
    tween.tween_property(camera, "global_position", arm.global_position, 0.5)
    
    tween.tween_callback(animation_player.stop)

    tween.tween_callback(animation_player.play.bind("stomp"))
    tween.tween_callback(bark_player.play)
    tween.tween_interval(1.0)
    var throw_speed = 5.0
    tween.tween_property(animation_player, "speed_scale", throw_speed, 0.05)
    tween.parallel().tween_property(camera, "global_position", arm.global_position, 2.0 / throw_speed)
    tween.tween_callback(animation_player.play.bind("pick_sp_throw"))
    tween.tween_interval(3.3 / throw_speed)
    tween.parallel().tween_property(camera, "global_position", arm.global_position, 3.3 / throw_speed)
    tween.tween_callback(animation_player.pause)

    tween.tween_property(spear, "global_rotation", (arm.global_position - player_head.global_position).angle(), 0.01)
    tween.tween_callback(self.add_child.bind(spear, false))
    tween.tween_callback(spear.reparent.bind(player))
    
    
    tween.tween_property(spear, "global_position", arm.global_position, 0.01)
    tween.tween_property(spear, "position", head_offset, 0.2)
    tween.parallel().tween_property(camera, "position", Vector2(0, 0), 0.15)
    tween.tween_callback(camera.align)
    tween.tween_callback(death_menu.increment_death_level)
    
    
    tween.tween_interval(0.7 / throw_speed)
    tween.tween_property(animation_player, "speed_scale", 1.0, 0.05)
    tween.tween_callback(animation_player.stop)    
    tween.tween_callback(animation_player.play.bind("idle"))
    tween.tween_callback(%QuestTracker.reset_all_timers)
    tween.play()

