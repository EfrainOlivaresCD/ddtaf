using System;
using System.Collections.Generic;

using WatiN.Core;

namespace WatiNGettingStarted
{
    class WatiNConsoleExample
    {    
        [STAThread]
        static void Main(string[] args)
        {
            Dispatcher disp = new Dispatcher();
            Chain TheChain = new Chain();
 
            Dictionary<int, Command> chain = TheChain.getChain();

            foreach (KeyValuePair<int, Command> entry in chain)
            {
                disp.run(entry.Value);
            }
        }
    }
}

