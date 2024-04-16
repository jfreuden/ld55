using Godot;
using System;

public partial class QuestMarker : Node2D
{
    public enum TaskType
    {
        Interact,
        Modify,
        Take,
        Place,
        Deliver,
        Wait,
        Bell
    }

    [Export] public string QuestString { get; private set; } = "Describe the task";
    [Export] public TaskType QuestTaskType { get; set; }
    [Export] public QuestMarker NextTaskMarker { get; private set; }
    [Export] public float QuestTime { get; private set; } = 30.0f;
    [Export] public float InteractionRadius { get; private set; } = 100.0f;


    private Timer TaskClock { get; set; }
    private Area2D InteractionArea { get; set; }
    private CollisionShape2D InteractionCollisionShape { get; set; }
    private CircleShape2D InteractionCircle { get; set; }
    private Label InteractionLabel { get; set; }
    private bool InteractionEnabled { get; set; } = false;

    private void EnableChildren()
    {
        // TODO: Some of this should be conditional on the Task type
        TaskClock.WaitTime = QuestTime;
        InteractionCircle.Radius = InteractionRadius;
        GlobalScale = new Vector2(1.0f, 1.0f);
        TaskClock.Start();

        if (QuestTaskType != TaskType.Wait)
        {
            InteractionArea.Monitorable = true;
            InteractionArea.Monitoring = true;
            InteractionCollisionShape.Disabled = false;
            InteractionEnabled = true;
            InteractionLabel.Show();
            Show();
            GD.Print(GetNode<Node2D>("/root/Root/Lord").GlobalPosition);
            GD.Print(GlobalPosition);
            GD.Print(QuestTaskType);
            if (QuestTaskType == TaskType.Bell) GlobalPosition = GetNode<Node2D>("/root/Root/Lord").GlobalPosition;
        }
        
    }

    private void BindChildren()
    {
        // Bind refs
        TaskClock = GetNode<Timer>("TaskClock");
        InteractionArea = GetNode<Area2D>("InteractionArea");
        Godot.Collections.Array nodeAndShape = GetNodeAndResource("InteractionArea/InteractionCollisionShape:shape");
        InteractionCollisionShape = (CollisionShape2D)nodeAndShape[0];
        InteractionCircle = (CircleShape2D)nodeAndShape[1];
        InteractionLabel = GetNode<Label>("InteractionLabel");
        // Todo: bind to particle emitter
    }

    private void DisableChildren()
    {
        TaskClock.Stop();
        InteractionArea.Monitorable = false;
        InteractionArea.Monitoring = false;
        InteractionCollisionShape.Disabled = true;
        InteractionEnabled = false;
        InteractionLabel.Hide();
        Hide();
    }

    /*
     * Bell (no desc) (no mode) ->
     * Shake out coat (modify on letter)
       Take red letter (take on letter)
       Deliver to Lord (Deliver on lord)
       Wait for Lord to read letter (wait)
       Take Tomato (modify on tomato)
       Throw at Painting (modify on tomato mess)
     */

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        BindChildren();
        DisableChildren();
        HackVisibility();
    }

    /// <summary>
    /// This is a hack around the fact that our own node won't be visible if the parent isn't
    /// </summary>
    public void HackVisibility()
    {
        // TODO: Hack around the visibility thing
    }
    
    public void EnableInteraction()
    {
        EnableChildren();
    }

    public void DisableInteraction()
    {
        DisableChildren();
    }

    public bool Interact()
    {
        // Make sure to get the inbound quest chain reference from the HUD or wherever

        var success = false;
        switch (QuestTaskType)
        {
            case TaskType.Bell or TaskType.Interact:
                success = InteractBasic();
                break;
            case TaskType.Modify:
                success = InteractModify();
                break;
            case TaskType.Take:
                success = InteractTake();
                break;
            case TaskType.Place:
                success = InteractPlace();
                break;
            case TaskType.Deliver:
                success = InteractDeliver();
                break;
            case TaskType.Wait:
                success = InteractWait();
                break;
        }

        if (success)
        {
            // Stop the timer and proceed to the next task, unless it failed
            GetNode<QuestTracker>("/root/Root/QuestTracker").NextTask(this);
        }
        else
        {
            GD.Print("Task Interaction Attempt Failed");
        }

        return success;
    }

    /// <summary>
    /// Basically a simple no-op with no discernible differences
    /// </summary>
    /// <returns>true</returns>
    public bool InteractBasic()
    {
        return true;
    }

    /// <summary>
    /// By default, this should toggle the visibility of the parent object, but may inherit
    /// </summary>
    /// <returns>true</returns>
    public bool InteractModify()
    {
        var parent = (CanvasItem)GetParent();
        parent.Visible = !parent.Visible;
        return true;
    }

    /// <summary>
    /// Takes the Parent and puts it into the PlayerHand
    /// </summary>
    /// <returns>true if we successfully picked up something, false otherwise</returns>
    public bool InteractTake()
    {
        var parent = (Node2D)GetParent();
        Node2D hand = GetNodeOrNull<Node2D>("/root/Root/%Player/%PlayerHand");

        if (hand is null)
        {
            GD.PrintErr("We seem to have lost our PlayerHand");
            return false;
        }

        if (hand.GetChildCount() > 0)
        {
            GD.PrintErr("Something already in the hand");
            return false;
        }

        parent.Reparent(hand, false);
        parent.Position = Vector2.Zero;
        parent.Show();
        return true;
    }

    /// <summary>
    /// Takes the item from the PlayerHand and puts it as a sibling of this "QuestItem" 
    /// </summary>
    /// <returns>true if we successfully placed something, false otherwise</returns>
    public bool InteractPlace(bool visible = true)
    {
        var parent = (CanvasItem)GetParent();
        Node2D hand = GetNodeOrNull<Node2D>("/root/Root/%Player/%PlayerHand");
        
        if (hand is null)
        {
            GD.PrintErr("We seem to have lost our PlayerHand");
            return false;
        }

        if (hand.GetChildCount() <= 0)
        {
            GD.Print("Nothing in our hand");
            return false;
        }

        if (hand.GetChildCount() > 1)
        {
            GD.PrintErr("We have too many things in our hand. How did this happen?");
            return false;
        }

        Node2D child = (Node2D)hand.GetChild(0);
        child.Reparent(parent, false);
        child.Position = Vector2.Zero;
        child.Visible = visible;
        
        return true;
    }

    /// <summary>
    /// Takes the item from the PlayerHand and puts it as a sibling of this "QuestItem" and then hides it
    /// </summary>
    /// <returns></returns>
    public bool InteractDeliver()
    {
        return InteractPlace(false);
    }

    public void OnTimerTimeout()
    {
        if (QuestTaskType == TaskType.Wait)
        {
            GD.Print("Wait time for the task has passed");
            Interact();
        }
        else
        {
            // The Lord needs to attempt to murder you here
            GD.PrintErr("Murder Attempt not yet implemented");
        }
    }

    /// <summary>
    /// Due to the nature of this, a wait is just a no-op at the end of the timer.
    /// Otherwise, we would have to find some way of checking if an interaction is valid FIRST. Technically two tasks
    /// (one Deliver and one Wait, for example) does the same thing.
    /// </summary>
    /// <returns>true</returns>
    public bool InteractWait()
    {
        return true;
    }
}