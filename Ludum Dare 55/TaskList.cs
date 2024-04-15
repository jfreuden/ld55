using Godot;
using System;
using System.Linq;

public partial class TaskList : VBoxContainer
{
    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        var questMarkers = GetNode<QuestTracker>("%QuestTracker").ActiveTasks;
        GetNode<Label>("Label").Text = string.Join('\n', questMarkers.Select(x => x.Name + ": " + x.QuestString));
    }
}
