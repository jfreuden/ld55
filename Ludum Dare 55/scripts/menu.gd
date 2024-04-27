extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node("%Play").grab_focus()
    if OS.has_feature("web"):
        get_node("NinePatchRect/VBoxContainer/Quit").visible = false

func PlayGame():
    get_tree().change_scene_to_file("res://root.tscn")

func settings():
    pass

func QuitGame():
    get_tree().quit()

