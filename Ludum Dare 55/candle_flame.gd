extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
    var tween1 : Tween = create_tween()
    tween1.tween_property(get_node("Glow1"), "texture_scale", 3, 0.9)
    tween1.tween_property(get_node("Glow1"), "texture_scale", 2, 0.9)
    tween1.set_loops()
    tween1.play()
    
    var tween2 : Tween = create_tween()
    tween2.tween_property(get_node("Glow2"), "texture_scale", 4, 0.9)
    tween2.tween_property(get_node("Glow2"), "texture_scale", 3, 0.9)
    tween2.set_loops()
    tween2.play()
    
    var tween3 : Tween = create_tween()
    tween3.tween_property(get_node("Glow3"), "texture_scale", 5, 0.9)
    tween3.tween_property(get_node("Glow3"), "texture_scale", 4, 0.9)
    tween3.set_loops()
    tween3.play()
    
    var tween4 : Tween = create_tween()
    tween4.tween_property(get_node("Glow4"), "texture_scale", 6, 0.9)
    tween4.tween_property(get_node("Glow4"), "texture_scale", 5, 0.9)
    tween4.set_loops()
    tween4.play()
