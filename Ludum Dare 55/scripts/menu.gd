extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node("%Play").grab_focus()

func PlayGame():
    get_tree().change_scene_to_file("res://root.tscn")

func settings():
    pass

func QuitGame():
    get_tree().quit()

