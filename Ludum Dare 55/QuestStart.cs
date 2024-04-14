using Godot;

namespace LudumDare55;

public partial class QuestStart : QuestItem
{
    [Export] public bool Repeatable { get; private set; } = false;
    public new TaskType QuestTaskType { get; private protected set; } = TaskType.Bell;
    
    public override void _Ready()
    {
        QuestTaskType = TaskType.Bell;
        base._Ready();
    }
}