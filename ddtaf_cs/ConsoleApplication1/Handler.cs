using System;
using WatiN.Core;

/// <summary>
/// Handlers do all the actual work...
/// </summary>
/// 
class Singleton
{
    // Variable
    public static IE ie;

    // Fields
    private static Singleton instance;

    // Empty Constructor
    protected Singleton(string _url)
    {
        ie = new IE(_url);
    }

    // Methods
    public static Singleton Instance(string _url)
    {
        // Uses "Lazy initialization"
        if (instance == null)
            instance = new Singleton(_url);

        return instance;
    }

    public IE getIE()
    {
        return ie;
    }
}

class handler
{
    public virtual bool Execute(Command _com)
    {
        return true;
    }
}

class handler_launch : handler
{
    public override bool Execute(Command _com)
    {
        if (String.Compare(_com.getWindow(), "IE") == 0)
        {
            Singleton ie1 = Singleton.Instance(_com.getData());
            return true;
        }
        else
            return false;
    }

}

class handler_enter : handler
{
    public override bool Execute(Command _com)
    {
        fakeDb DBase = new fakeDb();
        Singleton.Instance("i").getIE().Frame(Find.ByName(DBase.GetList(_com.getObject())[1])).TextField(Find.ByName(DBase.GetList(_com.getObject())[2])).TypeText("kaseya");
        return true;
    }
}

class handler_click : handler
{
    public override bool Execute(Command _com)
    {
        fakeDb DBase = new fakeDb();
        string strType = DBase.GetList(_com.getObject())[0];
        string strFirst = DBase.GetList(_com.getObject())[1];
        string strSecond = DBase.GetList(_com.getObject())[2];
        string strThird = DBase.GetList(_com.getObject())[3];
        string strFourth = DBase.GetList(_com.getObject())[4];

        IE Iexp = Singleton.Instance("i").getIE();
        if (String.Compare(strType, "FRbNA_LIbUR") == 0)
        {
            Iexp.Frame(Find.ByName(strFirst)).Link(Find.ByUrl(strSecond)).Click();
        }
        else if (String.Compare(strType, "FRbNA_LIbNA") == 0)
        {
            Iexp.Frame(Find.ByName(strFirst)).Link(Find.ByName(strSecond)).Click();
        }
        else if (String.Compare(strType, "FRbNA_FObNA_LIbID") == 0)
        {
            Iexp.Frame(Find.ByName(strFirst)).Form(Find.ByName(strSecond)).Link(Find.ById(strThird)).Click();
        }
        else if (String.Compare(strType, "FRbNA_FObNA_BUbID") == 0)
        {
            Iexp.Frame(Find.ByName(strFirst)).Form(Find.ByName(strSecond)).Button(Find.ById(strThird)).Click();
        }
        else if (String.Compare(strType, "FRbNA_FRbNA_FObNA_CHbNA") == 0)
        {
            //Iexp.Frame(Find.ByName(strFirst)).Frame(Find.ByName(strSecond)).Form(Find.ByName(strThird)).CheckBox(Find.ByName(strFourth)).Checked = true;
            //Iexp.Frame(Find.ByName(strFirst)).Form(Find.ByName(strThird)).Table(Find.ByName("scrollTable")).CheckBox(Find.ByName(strFourth)).Checked = true;
            Iexp.Frame(Find.ByName("functionFrame")).CheckBox(Find.ByName("Sel0")).Checked = true;
        }
        return true;
    }
}
