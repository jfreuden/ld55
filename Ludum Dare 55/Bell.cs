using Godot;
using System;

public partial class Bell : Sprite2D
{
    [Export] Godot.Collections.Array<AudioStreamMP3> streams = new();
    
    
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }

    /// <summary>
    /// Ring the bell: Play the animation, play a random sound 
    /// </summary>
    public void Ring()
    {
        var audioStreamPlayer = GetNode<AudioStreamPlayer>("AudioStreamPlayer");
        var animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
        audioStreamPlayer.Stream = streams.PickRandom();
        audioStreamPlayer.Play();
        animationPlayer.Stop();
        animationPlayer.Play("ring_the_bell");
    }
}
