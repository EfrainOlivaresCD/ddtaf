using System;
using System.Collections.Generic;
using System.Text;

class fakeDb
{

    Dictionary<string, List<string>> fakeDbase = new Dictionary<string, List<string>>();

    public fakeDb()
    {
        int counter = 0;
        string line;

        System.IO.StreamReader file =
           new System.IO.StreamReader("c:\\fakeDb.csv");
        while ((line = file.ReadLine()) != null)
        {
            string[] parts = line.Split(',');
            Add(line);
            counter++;
        }

        file.Close();
    }

    public void Add(string key, string type, string first, string second, string third, string fourth)
    {
        List<string> theList = new List<string>();
        theList.Add(type);
        theList.Add(first);
        theList.Add(second);
        theList.Add(third);
        theList.Add(fourth);
        fakeDbase.Add(key, theList);
    }

    public void Add(string _line)
    {
        string[] parts = _line.Split(',');
        List<string> theList = new List<string>();
        theList.Add(parts[1]);
        theList.Add(parts[2]);
        theList.Add(parts[3]);
        theList.Add(parts[4]);
        theList.Add(parts[5]);
        fakeDbase.Add(parts[0], theList);
    }

    public List<string> GetList(string key)
    {
        List<string> aList;
        fakeDbase.TryGetValue(key, out aList);
        return aList;
    }

}