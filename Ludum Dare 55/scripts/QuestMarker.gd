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
@export var next_task_marker : NodePath
@export var quest_time : float = 30.0
@export var interaction_radius : float = 100.0

# Member variables
var task_clock : Timer
var interaction_area : Area2D
var interaction_collision_shape : CollisionShape2D
var interaction_circle : CircleShape2D
var interaction_label : Label
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
        print("Murder Attempt not yet implemented")

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
    else:
        print("Task Interaction Attempt Failed")

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
    child.position = Vector2.ZERO
    child.visible = visible

    return true

func interact_deliver() -> bool:
    return interact_place(false)

func interact_wait() -> bool:
    return true

func enable_children():
    task_clock.wait_time = quest_time
    interaction_circle.radius = interaction_radius
    global_scale = Vector2(1.0, 1.0)
    task_clock.start()

    if quest_task_type != TaskType.WAIT:
        interaction_area.monitorable = true
        interaction_area.monitoring = true
        interaction_collision_shape.disabled = false
        interaction_enabled = true
        interaction_label.show()
        show()
        print(get_node("/root/Root/Lord").global_position)
        print(global_position)
        print(quest_task_type)
        if quest_task_type == TaskType.BELL:
            global_position = get_node("/root/Root/Lord").global_position

func disable_children():
    task_clock.stop()
    interaction_area.monitorable = false
    interaction_area.monitoring = false
    interaction_collision_shape.disabled = true
    interaction_enabled = false
    interaction_label.hide()
    hide()

func bind_children():
    # Bind refs
    task_clock = get_node("TaskClock")
    interaction_area = get_node("InteractionArea")
    var node_and_shape = get_node_and_resource("InteractionArea/InteractionCollisionShape:shape")
    interaction_collision_shape = node_and_shape[0]
    interaction_circle = node_and_shape[1]

    interaction_label = get_node("InteractionLabel")
    # Todo: bind to particle emitter

