class_name QuestTracker
extends Node2D

# Nullable annotations not supported in GDScript

# Member variables
var active_tasks : Array = []
var bell_timer : Timer = Timer.new()
var completed_tasks : int = 0

# Exported variables
@export var disabled_starts : Array[QuestStart] = []
@export var quest_accept_barks : Array[AudioStreamMP3] = []
@export var quest_progress_barks : Array[AudioStreamMP3] = []
@export var quest_complete_barks : Array[AudioStreamMP3] = []
@export var delay_low : float = 15.0
@export var delay_high : float = 60.0

# Called when the node enters the scene tree for the first time.
func _ready():
    bell_timer.connect("timeout", ring_bell)
    bell_timer.one_shot = true
    add_child(bell_timer)
    reset_bell_timer()

func _exit_tree():
    bell_timer.queue_free()
    for start in disabled_starts:
        start.queue_free()
    disabled_starts.clear()

func reset_bell_timer():
    bell_timer.start(randf_range(delay_low, delay_high))

func ring_bell():
    var picked_start : QuestStart = null
    var attempts : int = 0

    if get_child_count() <= 0:
        return

    while picked_start == null || disabled_starts.has(picked_start):
        var children = get_children()
        var selection : int = randi() % children.size()
        picked_start = children[selection] as QuestStart

        if attempts > 100:
            print("No Valid Bell Tasks")
            return

        attempts += 1

    var bell = get_node("%Bell") as Bell
    bell.ring()

    disabled_starts.append(picked_start)
    active_tasks.append(picked_start)
    picked_start.enable_interaction()
    reset_bell_timer()

func next_task(finished_task: QuestMarker):
    completed_tasks += 1
    var next_task: QuestMarker = finished_task.next_task_marker

    finished_task.disable_interaction()
    active_tasks.erase(finished_task)
    if is_ancestor_of(finished_task) and not (finished_task as QuestStart).repeatable:
        remove_child(finished_task)

    if next_task == null:
        var audio_stream_player_2d = get_node("/root/Root/BarkPlayer") as AudioStreamPlayer2D
        audio_stream_player_2d.stop()
        audio_stream_player_2d.stream = quest_complete_barks[randi() % quest_complete_barks.size()]
        audio_stream_player_2d.play()

        for start in disabled_starts:
            var ptr = start
            var attempts : int = 0

            while ptr != null:
                attempts = attempts + 1
                if attempts > 100:
                    # This quest chain is likely a cicular loop, break out
                    break;
                if ptr == finished_task:
                    if start is QuestStart and start.repeatable:
                        disabled_starts.erase(start)
                        start.reparent(self)
                    return
                ptr = ptr.next_task_marker

        return
    else:
        var audio_stream_player_2d = get_node("/root/Root/BarkPlayer") as AudioStreamPlayer2D
        audio_stream_player_2d.stop()
        if finished_task.quest_task_type == QuestMarker.TaskType.BELL:
            audio_stream_player_2d.stream = quest_accept_barks[randi() % quest_accept_barks.size()]
        else:
            audio_stream_player_2d.stream = quest_progress_barks[randi() % quest_progress_barks.size()]
        audio_stream_player_2d.play()

    active_tasks.append(next_task)
    next_task.enable_interaction()

func reset_all_timers():
    for task: QuestMarker in active_tasks:
        task.task_clock.start()
    pass

