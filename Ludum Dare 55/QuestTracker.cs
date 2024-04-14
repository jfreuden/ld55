using Godot;
using System;
using Godot.Collections;

public partial class QuestTracker : Node2D
{
    /// <summary>
    /// These are the tasks currently in progress
    /// </summary>
    public Godot.Collections.Array<QuestItem> ActiveTasks = new Array<QuestItem>();
    
    /// <summary>
    /// These quest chains have begun, and are repeatable
    /// </summary>
    public Godot.Collections.Array<QuestItem> DisabledStarts = new Array<QuestItem>();
    
    // All the QuestItem Children on this QuestTracker are all Bell Start quests
    
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }

    /// <summary>
    /// Calling this should basically pick from the bucket
    /// Choose a random child node (that is a QuestItem)
    /// Add a reference to the node to the `ActiveTasks`
    /// Call `Interact()` on that node.
    /// </summary>
    public void RingBell()
    {
        
    }

    public void NextTask(QuestItem finishedTask)
    {
        // this should do the logic of proceeding the quest chain
        
        // TODO: Handle the edge case of removing the associated child node if this QuestItem is a child that Isn't repeatable
    }
    
}
