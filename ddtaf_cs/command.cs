using System;

/// <summary>
/// Basic container for a one line command, to be queued for execution.
/// </summary>

public class command
{
    string s_action;
    string s_data;
    string s_window;
    string s_object;
    string s_pass;
    string s_fail;


    public command(string _action, string _data, string _window, string _object, string _pass, string _fail)
    {
        s_action = _action;//aka, the key
        s_data = _data;
        s_window = _window;
        s_object = _object;
        s_pass = _pass;
        s_fail = _fail;
    }

    //This might be supreflous, if handler is going all the 'running'.
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