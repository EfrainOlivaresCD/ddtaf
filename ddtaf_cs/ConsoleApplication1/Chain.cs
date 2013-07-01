using System;
using System.Collections.Generic;

public class Chain
{
    Dictionary<int, Command> chain;

    public Chain()
    {
        loadChain();
    }



    public Dictionary<int, Command> getChain()
    {
        return chain;
    }

    public void loadChain()
    {
        chain = new Dictionary<int, Command>();

        int counter = 0;
        string line;

        System.IO.StreamReader file =
           new System.IO.StreamReader("C:\\code\\KeydrivenFramework\\test.csv");
        while ((line = file.ReadLine()) != null)
        {
            string[] parts = line.Split(',');
            chain.Add(counter, new Command(line));
            counter++;
        }

        file.Close();
    }
}