using Godot;
using System;

public partial class QuestItem : Node2D
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
    [Export] public TaskType QuestTaskType { get; private set; }
    [Export] public QuestItem NextTaskItem { get; private set; }
    
    private Area2D InteractionCircle { get; set; }

    private void GenerateChildren()
    {
        if (InteractionCircle is not null) return;

        InteractionCircle = new Area2D();
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
        // Create the Area2D that will be used for the Interaction
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        if (InteractionCircle is not null)
        {
            // Display a prompt in the world, also check for the interaction button press
        }
    }

    /// <summary>
    /// This needs to execute the steps that find the current quest chain in the list,
    /// disables this item and then proceeds to the next task.
    /// </summary>
    public void NextTask()
    {
        
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

        if (success && QuestTaskType != TaskType.Wait)
        {
            // Stop the timer and proceed to the next task, unless it was a wait
            NextTask();
        }
        
        return success;
    }

    /// <summary>
    /// Basically a simple no-op with no discernible differences
    /// </summary>
    /// <returns></returns>
    public bool InteractBasic()
    {
        return false;
    }

    /// <summary>
    /// By default, this should toggle the visibility of the parent object, but may inherit
    /// </summary>
    /// <returns></returns>
    public bool InteractModify()
    {
        return false;
    }

    /// <summary>
    /// Takes the Parent and puts it into the PlayerHand
    /// </summary>
    /// <returns></returns>
    public bool InteractTake()
    {
        return false;
    }

    /// <summary>
    /// Takes the item from the PlayerHand and puts it as a sibling of this "QuestItem" 
    /// </summary>
    /// <returns></returns>
    public bool InteractPlace(bool visible = true)
    {
        return false;
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
            InteractWait();
            NextTask();
        }
        else
        {
            // The Lord needs to attempt to murder you
        }
    }
    
    /// <summary>
    /// Due to the nature of this, a wait needs to always call a simple `InteractBasic` at the end of the timer.
    /// Otherwise, we would have to find some way of checking if an interaction is valid FIRST. Technically two tasks
    /// (one Deliver and one Wait, for example) does the same thing.
    /// </summary>
    /// <returns></returns>
    public bool InteractWait()
    {
        Timer t = new Timer();

        void TimeoutFunction()
        {
            InteractBasic();
            t.CallDeferred("Dispose");
        }

        t.Timeout += TimeoutFunction;
        t.Start(10);
        
        return true;
    }
}