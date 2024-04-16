extends VBoxContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var quest_markers = get_node("%QuestTracker").active_tasks
    var label = get_node("Label") as Label
    var text = ""
    for quest_marker in quest_markers:
        text += quest_marker.name + ": " + quest_marker.quest_string + "\n"
    label.text = text

