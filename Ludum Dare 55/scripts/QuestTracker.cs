#nullable enable
using Godot;
using System;
using System.Linq;
using Godot.Collections;
using LudumDare55;

public partial class QuestTracker : Node2D
{
    /// <summary>
    /// These are the tasks currently in progress
    /// </summary>
    public Godot.Collections.Array<QuestMarker> ActiveTasks = new Array<QuestMarker>();

    /// <summary>
    /// These quest chains have begun, and are repeatable
    /// </summary>
    private Godot.Collections.Array<QuestMarker> DisabledStarts = new Array<QuestMarker>();

    [Export] private float delayLow { get; set; } = 15.0f;
    [Export] private float delayHigh { get; set; } = 60.0f;
    
    private Timer bellTimer = new();
    
    // All the QuestItem Children on this QuestTracker are all Bell Start quests

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        bellTimer.Timeout += RingBell;
        bellTimer.OneShot = true;
        AddChild(bellTimer);
        bellTimer.Start(4.5);
        
    }

    public void ResetBellTimer()
    {
        bellTimer.Start(GD.RandRange(delayLow, delayHigh));
    }
    
    public override void _ExitTree()
    {
        bellTimer.Free();
        // Dispose of the nodes that we were keeping around in the DisabledStarts list
        foreach (var node in DisabledStarts)
        {
            node.Free();
        }

        DisabledStarts.Clear();
        base._ExitTree();
    }


    /// <summary>
    /// Calling this should basically pick from the bucket
    /// Choose a random child node (that is a QuestItem)
    /// Add a reference to the node to the `ActiveTasks`
    /// Call `Interact()` on that node.
    /// </summary>
    public void RingBell()
    {
        QuestStart? pickedStart = null;

        int attempts = 0;
        if (GetChildCount() <= 0) return;

        while (pickedStart is null || DisabledStarts.Contains(pickedStart))
        {
            var childCount = GetChildCount();
            var children = GetChildren();
            int selection = (int)(GD.Randi() % childCount);
            pickedStart = children[selection] as QuestStart;

            if (attempts > 100)
            {
                GD.Print("No Valid Bell Tasks");
                return;
            }

            attempts++;
        }

        GetNode<Bell>("%Bell").Ring();

        DisabledStarts.Add(pickedStart);
        ActiveTasks.Add(pickedStart);
        bool success = pickedStart.Interact();
        if (success) GD.Print("Says it worked");
        ResetBellTimer();

    }

    public void NextTask(QuestMarker finishedTask)
    {
        var nextTask = finishedTask.NextTaskMarker;

        finishedTask.DisableInteraction();
        var success = ActiveTasks.Remove(finishedTask);
        if (!success) GD.PrintErr("Failed to Remove Task from Active List");
        if (IsAncestorOf(finishedTask) && !((QuestStart)finishedTask).Repeatable)
        {
            RemoveChild(finishedTask);
        }

        // Warning: Cursed.
        // When we hit the end of a quest chain, let's check our disabled starts to see if it's a repeatable chain, that also leads to this one.
        if (nextTask is null)
        {
            foreach (var start in DisabledStarts)
            {
                var ptr = start;

                while (ptr is not null)
                {
                    // If we reach this, then this `start` was the origin of this current end task
                    if (ptr == finishedTask)
                    {
                        // If it's repeatable, then move this start out of `DisabledStarts` and reclaim it as a child
                        if (start is QuestStart qs && qs.Repeatable)
                        {
                            DisabledStarts.Remove(start);
                            start.Reparent(this);
                        } 
                        return;
                    }
                    ptr = ptr.NextTaskMarker;
                }
            }
            
            return;
        }

        ActiveTasks.Add(nextTask);
        nextTask.EnableInteraction();

    }
}