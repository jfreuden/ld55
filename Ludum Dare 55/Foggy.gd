extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
    var brown: Polygon2D = get_node("Brown")
    var detail: Polygon2D = get_node("Detail")
    var tween: Tween = create_tween()
    tween.tween_property(brown, "texture_offset", Vector2(-28888.3, 80.2), 900)
    tween.tween_property(brown, "texture_offset", Vector2(0.0, 0.0), 0.1)
    tween.set_loops()
    
    var tween2: Tween = create_tween()
    tween2.tween_property(detail, "texture_offset", Vector2(9188.2, -9188), 700)    
    tween2.tween_property(detail, "texture_offset", Vector2(0.0, 0.0), 0.1)
    tween2.set_loops()
