using Godot;
using System;

public partial class CharacterBody2D : Godot.CharacterBody2D
{
    [Export]
    public float Speed { get; private set; } = 50;

    [Export] public float Momentum { get; private set; } = 0.25f;
    
    
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _PhysicsProcess(double delta)
    {
        Vector2 joyVector2 = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");
        
        Velocity = Velocity.MoveToward(Speed * joyVector2, (float)(Momentum / delta));
        MoveAndSlide();
    }
}
