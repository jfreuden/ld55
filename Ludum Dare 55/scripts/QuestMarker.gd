@icon("res://assets/QuestMarker.svg")
class_name QuestMarker
extends Node2D

# Enums
enum TaskType {
    INTERACT,
    MODIFY,
    TAKE,
    PLACE,
    DELIVER,
    WAIT,
    BELL
}

# Exported variables
@export var quest_string : String = "Describe the task"
@export var quest_task_type : TaskType
@export var next_task_marker : QuestMarker
@export var quest_time : float = 15.0
@export var interaction_radius : float = 50.0

signal interaction_succeeded
signal interaction_failed

# Member variables
var task_clock : Timer
var interaction_area : Area2D
var interaction_collision_shape : CollisionShape2D
var interaction_circle : CircleShape2D
var interaction_panel : Panel
var interaction_enabled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    bind_children()
    disable_children()
    hack_visibility()

# Hack around the visibility thing
func hack_visibility():
    pass

func enable_interaction():
    enable_children()

func disable_interaction():
    disable_children()

func _on_Timer_timeout():
    if quest_task_type == TaskType.WAIT:
        print("Wait time for the task has passed")
        interact()
    else:
        print("The Lord has lost patience")
        var quest_tracker = get_node("/root/Root/QuestTracker")
        get_node("/root/Root/%Lord/Character").attack_player()
        quest_tracker.reset_all_timers()

func interact():
    var success = false
    match quest_task_type:
        TaskType.BELL, TaskType.INTERACT:
            success = interact_basic()
        TaskType.MODIFY:
            success = interact_modify()
        TaskType.TAKE:
            success = interact_take()
        TaskType.PLACE:
            success = interact_place()
        TaskType.DELIVER:
            success = interact_deliver()
        TaskType.WAIT:
            success = interact_wait()

    if success:
        var quest_tracker = get_node("/root/Root/QuestTracker")
        if quest_tracker:
            quest_tracker.next_task(self)
        interaction_succeeded.emit()
    else:
        print("Task Interaction Attempt Failed")
        var t: Tween = create_tween()
        t.tween_property(self, "modulate", Color.CYAN, 0.4)
        t.tween_property(self, "modulate", Color.WHITE, 0.4)
        t.play()
        interaction_failed.emit()
    return success

func interact_basic() -> bool:
    return true

func interact_modify() -> bool:
    var parent : CanvasItem = get_parent()
    parent.visible = !parent.visible
    return true

func interact_take() -> bool:
    var parent : Node2D = get_parent()
    var hand = get_node_or_null("/root/Root/%Player/%PlayerHand")

    if hand == null:
        printerr("We seem to have lost our PlayerHand")
        return false

    if hand.get_child_count() > 0:
        printerr("Something already in the hand")
        return false

    parent.reparent(hand, false)
    parent.position = Vector2.ZERO
    parent.show()
    return true

func interact_place(visible: bool = true) -> bool:
    var parent : CanvasItem = get_parent()
    var hand = get_node_or_null("/root/Root/%Player/%PlayerHand")

    if hand == null:
        printerr("We seem to have lost our PlayerHand")
        return false

    if hand.get_child_count() <= 0:
        print("Nothing in our hand")
        return false

    if hand.get_child_count() > 1:
        printerr("We have too many things in our hand. How did this happen?")
        return false

    var child : Node2D = hand.get_child(0)
    child.reparent(parent, false)
    child.position = position
    child.visible = visible

    return true

func interact_deliver() -> bool:
    return interact_place(false)

func interact_wait() -> bool:
    return true

func enable_children():
    task_clock.wait_time = quest_time

    #set interaction panel size based on user radius
    interaction_panel.size = Vector2.ONE * interaction_radius * 2;
    interaction_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE, true)

    #ensure circle is not smaller than min panel size
    interaction_circle.radius = interaction_radius;

    task_clock.start()

    if quest_task_type != TaskType.WAIT:
        interaction_area.monitorable = true
        interaction_area.monitoring = true
        interaction_collision_shape.disabled = false
        interaction_enabled = true
        interaction_panel.show()
        show()
        if quest_task_type == TaskType.BELL:
            global_position = get_node("/root/Root/Lord").global_position

func disable_children():
    task_clock.stop()
    interaction_area.monitorable = false
    interaction_area.monitoring = false
    interaction_collision_shape.disabled = true
    interaction_enabled = false
    interaction_panel.hide()
    hide()

func bind_children():
    # Bind refs
    task_clock = get_node("TaskClock")
    interaction_area = get_node("InteractionArea")
    var node_and_shape = get_node_and_resource("InteractionArea/InteractionCollisionShape:shape")
    interaction_collision_shape = node_and_shape[0]
    interaction_circle = node_and_shape[1]

    interaction_panel = get_node("InteractionPanel")
    # Todo: bind to particle emitter

