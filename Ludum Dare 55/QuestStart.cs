using Godot;

namespace LudumDare55;

public partial class QuestStart : QuestMarker
{
    [Export] public bool Repeatable { get; private set; } = false;
    public new TaskType QuestTaskType { get; private protected set; } = TaskType.Bell;

    public override void _Ready()
    {
        QuestTaskType = TaskType.Bell;
        
        if (Repeatable) GD.PrintErr("Repeatable Tasks are not yet Implemented");
        
        base._Ready();
    }
}