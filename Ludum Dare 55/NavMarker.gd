extends Polygon2D

func _ready():
    var parent : QuestMarker = get_parent()
    if parent and (parent.quest_task_type == QuestMarker.TaskType.DELIVER or parent.quest_task_type == QuestMarker.TaskType.PLACE or parent.name == "Empty Chamberpot"):
        var blink_tween : Tween = create_tween()
        blink_tween.tween_property(self, "modulate", Color.FIREBRICK, 0.45)
        blink_tween.tween_property(self, "modulate", Color.WHITE, 0.45)
        blink_tween.set_loops()
        blink_tween.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    var parent : QuestMarker = get_parent()
    if parent and parent.visible:
        var target : QuestMarker = get_parent()
        var screen_size = get_viewport_rect().size

        var target_pos = target.global_position
        var camera_pos = get_viewport().get_camera_2d().get_screen_center_position()
        var direction_vector: Vector2 = (target_pos - camera_pos)
        var dir_len = direction_vector.length()
        if dir_len < 300:
            modulate.a = clampf((dir_len - 100) / 300, 0, 1)
        else:
            modulate.a = 1.0
            global_position.x = clamp(target_pos.x, camera_pos.x - screen_size.x / 2, camera_pos.x + screen_size.x / 2)
            global_position.y = clamp(target_pos.y, camera_pos.y - screen_size.y / 2, camera_pos.y + screen_size.y / 2)
            # Set UI element's position and rotation
            rotation = direction_vector.normalized().angle()
