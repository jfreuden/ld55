extends VBoxContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var quest_markers = get_node("%QuestTracker").active_tasks
    var label = get_node("Label") as Label
    var text = ""
    for quest_marker in quest_markers:
        var timer: Timer = quest_marker.task_clock
        text += quest_marker.quest_string + " - " + str(timer.time_left).pad_decimals(2) + "\n"
    label.text = text

