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
@export var delay_low : float = 5.0
@export var delay_high : float = 12.0
@export var max_quest_count : int = 5
@export var patience_factor : float = 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
    bell_timer.connect("timeout", ring_bell)
    bell_timer.one_shot = true
    add_child(bell_timer)
    bell_timer.start(2.0)

func _exit_tree():
    bell_timer.queue_free()
    for start in disabled_starts:
        start.queue_free()
    disabled_starts.clear()

func reset_bell_timer():
    var timer_delay = randf_range(delay_low, delay_high) + 3 * (len(active_tasks) - 1)
    print(timer_delay)
    bell_timer.start(timer_delay)

func ring_bell():
    var picked_start : QuestStart = null
    var attempts : int = 0

    if get_child_count() <= 0:
        return

    if len(active_tasks) >= max_quest_count:
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

func isnt_start(node: Node):
    print(node)
    return not node is QuestStart

func next_task(finished_task: QuestMarker):
    completed_tasks += 1
    var next: QuestMarker = finished_task.next_task_marker

    finished_task.disable_interaction()
    active_tasks.erase(finished_task)
    if is_ancestor_of(finished_task) and not (finished_task as QuestStart).repeatable:
        remove_child(finished_task)
        disabled_starts.erase(finished_task)

    add_patience()
    var tasks_tween : Tween = create_tween()
    tasks_tween.set_ease(Tween.EASE_IN_OUT)
    tasks_tween.set_trans(Tween.TRANS_ELASTIC)
    tasks_tween.tween_property(%TaskList, "scale", Vector2(1.2, 1.2), 1)
    tasks_tween.tween_property(%TaskList, "scale", Vector2(1.0, 1.0), 1)
    tasks_tween.play()

    if next == null:
        var audio_stream_player_2d = get_node("/root/Root/BarkPlayer") as AudioStreamPlayer2D
        audio_stream_player_2d.stop()
        audio_stream_player_2d.stream = quest_complete_barks[randi() % quest_complete_barks.size()]
        audio_stream_player_2d.play()
        print(disabled_starts)
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
        if (get_child_count() == 0 or get_children().all(isnt_start)) and len(active_tasks) == 0:
            get_tree().paused = true
            %PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
            var page_tween : Tween = create_tween()
            page_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
            page_tween.tween_interval(2)
            page_tween.tween_callback(get_tree().change_scene_to_file.bind("res://menu.tscn"))
            page_tween.tween_property(get_tree(), "paused", false, 0.00001)
            page_tween.play()
        return
    else:
        var audio_stream_player_2d = get_node("/root/Root/BarkPlayer") as AudioStreamPlayer2D
        audio_stream_player_2d.stop()
        if finished_task.quest_task_type == QuestMarker.TaskType.BELL:
            audio_stream_player_2d.stream = quest_accept_barks[randi() % quest_accept_barks.size()]
        else:
            audio_stream_player_2d.stream = quest_progress_barks[randi() % quest_progress_barks.size()]
        audio_stream_player_2d.play()

    active_tasks.append(next)
    next.enable_interaction()

func reset_all_timers():
    for task: QuestMarker in active_tasks:
        if task.quest_task_type != QuestMarker.TaskType.WAIT:
            task.task_clock.start(task.quest_time)

func add_patience():
    for task: QuestMarker in active_tasks:
        if task.quest_task_type != QuestMarker.TaskType.WAIT:
            # Adds 20% to whatever remaining time there is, up to the quest time.
            var reset_time = minf(task.task_clock.time_left * patience_factor, task.quest_time)
            task.task_clock.start(reset_time)


