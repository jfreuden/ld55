extends VBoxContainer

func _ready():
    if OS.is_debug_build():
        get_node("../../../HBoxContainer").visible = true
    if OS.has_feature("web"):
        get_node("Quit").visible = false

func _process(delta):
    if Input.is_action_just_pressed("ui_cancel"):
        if not get_tree().paused:
            get_tree().paused = true
            get_parent().visible = true
        else:
            _on_continue_pressed()

func _on_menu_pressed():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://menu.tscn")

func _on_continue_pressed():
    get_tree().paused = false
    get_parent().visible = false

func _on_quit_pressed():
    get_tree().quit()
