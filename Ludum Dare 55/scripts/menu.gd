extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node("%Play").grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func play_game():
    get_tree().change_scene("res://root.tscn")

func settings():
    pass

func quit_game():
    get_tree().quit()

