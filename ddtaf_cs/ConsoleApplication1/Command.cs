using System;

/// <summary>
/// Basic container for a one line command, to be queued for execution.
/// </summary>

public class Command
{
    string s_action;
    string s_data;
    string s_window;
    string s_object;
    string s_pass;
    string s_fail;


    public Command(string _action, string _data, string _window, string _object, string _pass, string _fail)
    {
        s_action = _action;
        s_data = _data;
        s_window = _window;
        s_object = _object;
        s_pass = _pass;
        s_fail = _fail;
    }

    public Command(string _line)
    {
        string[] parts = _line.Split(',');
        s_action    = parts[0];
        s_data      = parts[1];
        s_window    = parts[2];
        s_object    = parts[3];
        s_pass      = parts[4];
        s_fail      = parts[5];
    }
    
    public bool Run()
    {
        return true;
    }

    public string getKey()
    {
        return s_action;
    }

    public string getData()
    {
        return s_data;
    }

    public string getWindow()
    {
        return s_window;
    }

    public string getObject()
    {
        return s_object;
    }

    public string getPass()
    {
        return s_pass;
    }

    public string getFail()
    {
        return s_fail;
    }
}