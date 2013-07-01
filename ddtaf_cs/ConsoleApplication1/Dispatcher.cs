using System;
using System.Collections.Generic;
using System.Text;

class Dispatcher
{
    Dictionary<string, handler> dicHandler;

    public Dispatcher()
    {
        dicHandler = new Dictionary<string, handler>();
        AddKeyHandler("launch", new handler_launch());
        AddKeyHandler("enter", new handler_enter());
        AddKeyHandler("click", new handler_click());
    }

    public void AddKeyHandler(string _key, handler _handler)
    {
        dicHandler.Add(_key, _handler);
    }

    public bool run(Command _com)
    {
        handler tempHandler = new handler();
        string key = _com.getKey();
        if (dicHandler.TryGetValue(_com.getKey(), out tempHandler))
        {
            tempHandler.Execute(_com);
        }
        return true;
    }
}

