using Godot;
using System;

public partial class Player : Godot.CharacterBody2D
{
    [Export] public float Speed { get; private set; } = 50;

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

        if (Input.IsActionJustPressed("ui_accept"))
        {
            HandleInteractKey();
        }
        
        
        Velocity = Velocity.MoveToward(Speed * joyVector2, (float)(Momentum / delta));
        MoveAndSlide();
    }

    private void HandleInteractKey()
    {
        var overlappingAreas = GetNode<Area2D>("InteractionCircle").GetOverlappingAreas();
        GD.Print(overlappingAreas.Count, " overlaps upon Interaction");

        // TODO: Don't assume that every Area2D is going to be attached to a QuestMarker, but for now it's fine
        // Get the closest parent
        if (overlappingAreas.Count > 0)
        {
            QuestMarker selectedParent = (QuestMarker)overlappingAreas[0].GetParent();
            float closestDistance = selectedParent.Position.DistanceTo(Position);

            foreach (Area2D area in overlappingAreas)
            {
                var distanceTo = area.Position.DistanceTo(Position);
                if (distanceTo < closestDistance)
                {
                    closestDistance = distanceTo;
                    selectedParent = (QuestMarker)area.GetParent();
                }
            }

            bool success = selectedParent.Interact();
        }
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