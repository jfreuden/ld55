class_name QuestStart
extends QuestMarker

# Exported variable
@export var repeatable : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    # Set QuestTaskType to Bell
    quest_task_type = TaskType.BELL
    global_position = get_node("/root/Root/Lord").global_position

    # Call _ready() from the parent class
    super._ready()

