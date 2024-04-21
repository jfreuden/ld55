extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationPlayer.play("idle")

func attack_player():
    var player: Node2D = get_node("/root/Root/%Player")
    var animation_player: AnimationPlayer = get_node("AnimationPlayer")

    # animation_player.stop()
    # TODO: play the throw animation and tween the spear to the player at the end of the throw animation
