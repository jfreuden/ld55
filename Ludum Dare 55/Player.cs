using Godot;
using System;

public partial class Player : Godot.CharacterBody2D
{
    [Export]
    public float Speed { get; private set; } = 50;

    [Export] public float Momentum { get; private set; } = 0.25f;

    [Signal]
    public delegate void ItemAddedToHandEventHandler();

    [Signal]
    public delegate void ItemRemovedFromHandEventHandler(); 
    
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        Vector2 joyVector2 = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
        
        Velocity = Velocity.MoveToward(Speed * joyVector2, (float)(Momentum / delta));
        MoveAndSlide();
        
        
    }

    public void OnAreaEntered(Area2D area)
    {
        GD.Print(area);
    }

    public void OnAreaExited(Area2D area)
    {
        GD.Print(area);
    }
}
