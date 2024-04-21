extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationPlayer.play("idle")

func attack_player():
    var player: Node2D = get_node("/root/Root/%Player/Character/Polygon/Polygon head")
    var animation_player: AnimationPlayer = get_node("AnimationPlayer")
    var spear: Polygon2D = get_node("Polygon/Polygon spear")
    var arm: Polygon2D = get_node("Polygon/Polygon lord arm front")
    var tween: Tween = create_tween()
    tween.tween_callback(animation_player.stop)
    var throw_speed = 5.0
    tween.tween_property(animation_player, "speed_scale", throw_speed, 0.05)
    tween.tween_callback(animation_player.play.bind("pick_sp_throw"))
    tween.tween_interval(3.3 / throw_speed)
    # maybe consider using the signal???
    tween.tween_callback(animation_player.pause)
    tween.tween_property(spear, "global_rotation", (arm.global_position - player.global_position).angle(), 0.01)
    tween.tween_property(spear, "global_position", arm.global_position, 0.01) 
    tween.tween_property(spear, "global_position", player.global_position, 0.3) # the throw
    tween.tween_callback(animation_player.stop)
    tween.tween_property(animation_player, "speed_scale", 1.0, 0.05)
    tween.tween_callback(animation_player.play.bind("idle"))
    tween.play()
