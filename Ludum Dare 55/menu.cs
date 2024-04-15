using Godot;
using System;

public partial class menu : Control
{
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        GetNode<Button>("%Play").GrabFocus();
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }

    public void PlayGame()
    {
        GetTree().ChangeSceneToFile("root.tscn");
    }

    public void Settings()
    {
    }

    public void QuitGame()
    {
        GetTree().Quit();
    }
}