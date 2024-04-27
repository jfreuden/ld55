extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
    var flicker_rate : float = randf_range(0.87, 0.92)
    var tween1 : Tween = create_tween()
    tween1.tween_property(get_node("Glow1"), "texture_scale", 3, flicker_rate)
    tween1.tween_property(get_node("Glow1"), "texture_scale", 2, flicker_rate)
    tween1.set_loops()
    tween1.play()

    var tween2 : Tween = create_tween()
    tween2.tween_property(get_node("Glow2"), "texture_scale", 4, flicker_rate)
    tween2.tween_property(get_node("Glow2"), "texture_scale", 3, flicker_rate)
    tween2.set_loops()
    tween2.play()

    var tween3 : Tween = create_tween()
    tween3.tween_property(get_node("Glow3"), "texture_scale", 5, flicker_rate)
    tween3.tween_property(get_node("Glow3"), "texture_scale", 4, flicker_rate)
    tween3.set_loops()
    tween3.play()

    var tween4 : Tween = create_tween()
    tween4.tween_property(get_node("Glow4"), "texture_scale", 6, flicker_rate)
    tween4.tween_property(get_node("Glow4"), "texture_scale", 5, flicker_rate)
    tween4.set_loops()
    tween4.play()
