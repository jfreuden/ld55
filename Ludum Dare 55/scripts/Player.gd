extends CharacterBody2D

# Exported variables
@export var speed : float = 400
@export var momentum : float = 0.25

# Signals
signal item_added_to_hand
signal item_removed_from_hand

# Called when the node enters the scene tree for the first time.
func _ready():
    var animation_player = $Character/AnimationPlayer
    animation_player.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var joy_vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var animation_player = $Character/AnimationPlayer

    var abs_dist = joy_vector2.dot(joy_vector2)
    if abs_dist > 0.0:
        animation_player.speed_scale = abs_dist
        animation_player.play("walk")
    else:
        animation_player.speed_scale = 1.0
        animation_player.play("idle")

    var character = $Character
    if joy_vector2.x < 0.0:
        character.scale.x = abs(character.scale.x)
    elif joy_vector2.x > 0.0:
        character.scale.x = -abs(character.scale.x)

    if Input.is_action_just_pressed("ui_accept"):
        handle_interact_key()

    velocity = velocity.move_toward(speed * joy_vector2, momentum / delta)
    move_and_slide()

func handle_interact_key():
    var overlapping_areas = $InteractionCircle.get_overlapping_areas()
    print(overlapping_areas.size(), " overlaps upon Interaction")

    # Get the closest parent
    if overlapping_areas.size() > 0:
        var selected_parent = overlapping_areas[0].get_parent()
        var closest_distance = selected_parent.position.distance_to(position)

        for area in overlapping_areas:
            var distance_to = area.position.distance_to(position)
            if distance_to < closest_distance:
                closest_distance = distance_to
                selected_parent = area.get_parent()

        var success = selected_parent.interact()

# Unused signals
# func _on_Area2D_area_entered(area):
#     print(area)
#
# func _on_Area2D_area_exited(area):
#     print(area)

