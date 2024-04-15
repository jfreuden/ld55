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
    private Godot.Collections.Array<QuestMarker> ActiveTasks = new Array<QuestMarker>();

    /// <summary>
    /// These quest chains have begun, and are repeatable
    /// </summary>
    private Godot.Collections.Array<QuestMarker> DisabledStarts = new Array<QuestMarker>();

    // All the QuestItem Children on this QuestTracker are all Bell Start quests

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
    }
    
    public override void _ExitTree()
    {
        // Dispose of the nodes that we were keeping around in the DisabledStarts list
        foreach (var node in DisabledStarts)
        {
            node.Free();
        }
        DisabledStarts.Clear();
        base._ExitTree();
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        QueueRedraw();
    }

    /// <summary>
    /// Calling this should basically pick from the bucket
    /// Choose a random child node (that is a QuestItem)
    /// Add a reference to the node to the `ActiveTasks`
    /// Call `Interact()` on that node.
    /// </summary>
    public void RingBell()
    {
        // TODO: Make sure that the children actually are QuestStarts
        QuestStart? pickedStart = null;

        int attempts = 0;
        if (GetChildCount() <= 0) return;

        while (pickedStart is null || DisabledStarts.Contains(pickedStart))
        {
            var childCount = GetChildCount();
            var children = GetChildren();
            int selection = (int)(GD.Randi() % childCount);
            pickedStart = (QuestStart)children[selection];

            if (attempts > 100)
            {
                GD.Print("No Valid Bell Tasks");
                return;
            }
            else
            {
                attempts++;
            }
        }

        DisabledStarts.Add(pickedStart);
        ActiveTasks.Add(pickedStart);
        bool success = pickedStart.Interact();
        if (success) GD.Print("Says it worked");

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

        if (nextTask is null) return;

        ActiveTasks.Add(nextTask);
        nextTask.EnableInteraction();
    }
}