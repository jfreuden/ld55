class_name Bell
extends Sprite2D

# Export an array of AudioStreamMP3
@export var streams : Array[AudioStreamMP3] = []

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

# Ring the bell: Play the animation, play a random sound
func ring():
    var audio_stream_player = $AudioStreamPlayer
    var animation_player = $AnimationPlayer
    audio_stream_player.stream = streams[randi() % streams.size()]
    audio_stream_player.play()
    animation_player.stop()
    animation_player.play("ring_the_bell")

