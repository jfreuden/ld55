class_name DeathMenu
extends Control

var current_death_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    set_death_level(current_death_level)

func increment_death_level():
    current_death_level = current_death_level + 1
    set_death_level(current_death_level)

func decrement_death_level():
    current_death_level = current_death_level - 1
    set_death_level(current_death_level)

func set_death_level(level: int):
    if level < 1:
        get_node("DeathLevel1").visible = false
        get_node("DeathLevel2").visible = false
        get_node("DeadPage").visible = false
    elif level == 1:
        get_node("DeathLevel1").visible = true
        get_node("DeathLevel2").visible = false
        get_node("DeadPage").visible = false
    elif level == 2:
        get_node("DeathLevel1").visible = true
        get_node("DeathLevel2").visible = true
        get_node("DeadPage").visible = false
    else:
        get_tree().paused = true
        %PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
        var page_tween : Tween = create_tween()
        page_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
        page_tween.tween_interval(2)
        page_tween.tween_callback(display_screen)
        page_tween.tween_interval(4)
        page_tween.tween_callback(get_tree().change_scene_to_file.bind("res://menu.tscn"))
        page_tween.tween_property(get_tree(), "paused", false, 0.00001)
        page_tween.play()

func display_screen():
    get_node("DeathLevel1").visible = false
    get_node("DeathLevel2").visible = false
    get_node("DeadPage").visible = true
    get_node("/root/Root/Player").visible = false
    get_node("/root/Root/GreatHall/LevelStaticBody").visible = false
    get_node("/root/Root/GreatHall/GreatHallItems").visible = false
    get_node("/root/Root/Lord").visible = false

