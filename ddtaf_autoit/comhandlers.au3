#include <TableData.au3>
#include <array.au3>
#include <ScreenCapture.au3>

Dim $validHandlers[100] = [ _
"IsChecked", "IsUnChecked", "SetFocus", "Launch", "SelectTab", _
"Check", "UnCheck", "LoadTable", "Click", "Select", "IsSelected", _
"WinCap", "KeyStroke", "Skip", "Sleep", "ENDTEST"]

$Console = True
$Show_Debug = True
Func COM($_act, $_dat, $_win, $_obj, $_line)
	$line = $_line + 1;excel test is not 0 based
	$cmd_string = @TAB & $_act & @TAB & $_dat & @TAB & $_win & $_obj

	if -1 == _ArraySearch($validHandlers, $_act, 0, 0, 1) Then
		_DebugOut("Invalid handler: " & $cmd_string)
		Return
	EndIf
	
	$return =  Call("Handler_" & $_act, $_act, $_dat, $_win, $_obj, $line)
	If $return == $PASS Then
		ChannelDebug($line & @TAB & "Pass" & $cmd_string)
	ElseIf $return == $FAIL Then
		ChannelDebug($line & @TAB & "!*FAIL*! Line " & $line & " : " & $cmd_string)
	ElseIf $return == $ERROR Then
		ChannelDebug($line & @TAB & "*ERROR IN EXECUTION* Line " & $line & " : " & $cmd_string)
	ElseIf $return == $ENDTEST Then
		ChannelDebug($line & @TAB & "ENDTEST found. Test terminating normally")
	Else
		ChannelDebug("!!** INVALID FUNCTION RETURN **!! :" & $line & " : <" & $return & "> " $cmd_string)
	EndIf
	
	Sleep(50)

	Return $return
	
EndFunc

Func ChannelDebug($mssg)
	if $Console Then
		ConsoleWrite($mssg & @LF)
	EndIf
	if $Show_Debug Then
		_DebugOut($mssg)
	EndIf
EndFunc
	

Func Handler_IsChecked($_act, $_dat, $_win, $_obj, $line)
	Return Sub_Handler_isChecked($_act, $_dat, $_win, $_obj, $line)
EndFunc

Func Handler_IsUnChecked($_act, $_dat, $_win, $_obj, $line)
	$return = Sub_Handler_isChecked($_act, $_dat, $_win, $_obj, $line)
	If $return == $PASS Then
		Return $FAIL
	ElseIf $return == $FAIL Then
		Return $PASS
	Else
		Return $ERROR
	EndIf
EndFunc

Func Sub_Handler_isChecked($_act, $_dat, $_win, $_obj, $line)
	$win_obj = $_win & $_obj
	$ID = ID($win_obj)
	if ControlCommand($_win, "", $ID, "isVisible") Then
		If ControlCommand($_win, "", $ID, "IsChecked") Then
			Return $PASS
		Else
			Return $FAIL
		EndIf
	Else
		Return $ERROR
		ConsoleWrite("ERROR: Checkbox <" & $win_obj & "> not visible" & @LF)
	EndIf	
EndFunc


Func Handler_SetFocus($_act, $_dat, $_win, $_obj, $line)
	WinActivate($_win)
	Return $PASS
EndFunc

Func Handler_Launch($_act, $_dat, $_win, $_obj, $line)
	;For debugging : ConsoleWrite("Launch <" & $_dat & ">" & @LF)
	;the below use, with the @comspec is for command line launch...
	;and does not seem to work in all circumstances
	;run(@comspec & " /c Start " & $_dat)
	
	;this one seems to work if we give it the full path...
	If Run($_dat) == 0 Then
		Return $ERROR
	Else
		Sleep(1000)
		Return $PASS
	EndIf
	
EndFunc

Func Handler_SelectTab($_act, $_dat, $_win, $_obj, $line)
	;ConsoleWrite("Select Tab" & @LF)
	$win_obj = $_win & $_obj
	$CLASS = CLASS($win_obj)
	$ID = ID($win_obj, 1)
	$tabdirection = "TabRight"
	if $CLASS == "NONE" Then
		Return $ERROR
	EndIf
	
	if ControlCommand($_win, "", $CLASS, "isVisible") Then
		$CUR_ID = ControlCommand($_win, "", $CLASS, "CurrentTab")

		For $try = 10 to 0 Step -1
			if $CUR_ID == $ID Then
				Return $PASS
			ElseIf $CUR_ID < $ID Then
				$tabdirection = "TabRight"
			Else 
				$tabdirection = "TabLeft"
			EndIf
			ConsoleWrite("Current tab ID  " & $CUR_ID & " target: " & $ID & " " & $tabdirection & @LF)			
			ControlCommand($_win, "", $CLASS, $tabdirection)
			$CUR_ID = 0;set this to zero, to force action if no return
			Sleep(200)
			$CUR_ID = ControlCommand($_win, "", $CLASS, "CurrentTab")
			ConsoleWrite("Returned Tab ID  " & $CUR_ID & " target: " & $ID & " "& @LF)
		Next
		ConsoleWrite("TAB NOT FOUND AFTER 10 TRIES " & $CLASS & @LF)		 
		Return $FAIL
	Else
		ConsoleWrite("TAB NOT VISIBLE " & $CLASS & @LF)		 
		Return $FAIL
	EndIf
EndFunc

Func Handler_Check($_act, $_dat, $_win, $_obj, $line)
	if $PASS == Sub_Handler_CheckUnCheck($_act, $_dat, $_win, $_obj, $line) Then
		Return Handler_IsChecked($_act, $_dat, $_win, $_obj, $line)
	Else
		Return $ERROR
	EndIf
EndFunc

Func Handler_UnCheck($_act, $_dat, $_win, $_obj, $line)
	if $PASS == Sub_Handler_CheckUnCheck($_act, $_dat, $_win, $_obj, $line) Then
		Return Handler_IsUnChecked($_act, $_dat, $_win, $_obj, $line)
	Else
		Return $ERROR
	EndIf
EndFunc


Func Sub_Handler_CheckUnCheck($_act, $_dat, $_win, $_obj, $line)
	$win_obj = $_win & $_obj
	$ID = ID($win_obj)
	if ControlCommand($_win, "", $ID, "isVisible") Then
		ControlCommand($_win, "", $ID, $_act)
		Return $PASS
	Else
		Return $ERROR
		ConsoleWrite("ERROR: Checkbox <" & $win_obj & "> not visible" & @LF)
	EndIf	
EndFunc

Func Handler_LoadTable($_act, $_dat, $_win, $_obj, $line)
	Return ReadTable($_dat)
EndFunc

Func Handler_Click($_act, $_dat, $_win, $_obj, $line)
	$win_obj = $_win & $_obj
	$ID = ID($win_obj)
	if $ID == "[ID:0000]" Then
		ConsoleWrite("ERROR Handler_Click: No valid ID for this object: " & $win_obj & @LF)
		Return $ERROR
	EndIf
	
	if ControlCommand($_win, "", $ID, "isVisible") Then
		If ControlClick($_win, "", $ID) Then
			Return $PASS
		Else
			Return $FAIL
		EndIf
	Else
		ConsoleWrite("ERROR Handler_Click: <" & $win_obj & "> not visible" & @LF)
		Return $ERROR
	EndIf	
EndFunc

Func Handler_Select($_act, $_dat, $_win, $_obj, $line)
	$win_obj = $_win & $_obj
	$CLASS = CLASS($win_obj)
	$ID = ID($win_obj)
	If StringInStr($CLASS, "ComboBox") Then
		if ControlCommand($_win, "", $ID, "isVisible") Then
			$start_string = ControlCommand($_win, "", $CLASS, "GetCurrentSelection")
			$str_ref = ControlCommand($_win, "", $CLASS, "FindString", $_dat)
			ControlCommand($_win, "", $CLASS, "SetCurrentSelection", $str_ref)
			$final_string = ControlCommand($_win, "", $CLASS, "GetCurrentSelection")
			If $_dat == $final_string Then
				Return $PASS
			Else
				ControlCommand($_win, "", $CLASS, "SelectString", $start_string)
				ConsoleWrite("ERROR Select: ComboBox <" & $_dat & "> not selectable" & @LF)
				Return $FAIL
			EndIf
		Else
			ConsoleWrite("ERROR Select: ComboBox <" & $win_obj & "> not visible" & @LF)
			Return $ERROR
		EndIf	
	EndIf
	ConsoleWrite("ERROR Select: <" & $win_obj & "not handled" & @LF)
	Return $ERROR
EndFunc

Func Handler_IsSelected($_act, $_dat, $_win, $_obj, $line)
	$win_obj = $_win & $_obj
	$CLASS = CLASS($win_obj)
	$ID = ID($win_obj)
	If StringInStr($CLASS, "ComboBox") Then
		if ControlCommand($_win, "", $ID, "isVisible") Then
			$start_string = ControlCommand($_win, "", $CLASS, "GetCurrentSelection")
			If $_dat == $start_string Then
				Return $PASS
			Else
				ConsoleWrite("ERROR IsSelected: ComboBox <" & $_dat & "> not selected" & @LF)
				Return $FAIL
			EndIf
		Else
			ConsoleWrite("ERROR IsSelected: ComboBox <" & $win_obj & "> not visible" & @LF)
			Return $ERROR
		EndIf	
	EndIf
	ConsoleWrite("ERROR IsSelected: <" & $win_obj & "not handled" & @LF)
	Return $ERROR
EndFunc

Func Handler_WinCap($_act, $_dat, $_win, $_obj, $line)
	$win_obj = $_win & $_obj
	Local $handle
	; Change into the WinTitleMatchMode that supports classnames and handles
	AutoItSetOption("WinTitleMatchMode", 2)

	WinActivate($_win)
	$handle = WinGetHandle($_win)
	If @error Then
		ConsoleWrite("ERROR: WinCap Could not find the correct window" & @LF)
		Return $ERROR
	Else
		_ScreenCapture_CaptureWnd (@ScriptDir & "\ScreenCap\" & $_dat & "_" & $line & "_" & $win_obj  & "_" & @HOUR & @MIN & @SEC & ".jpg", $handle)
		Return $PASS
	EndIf

EndFunc


Func Handler_KeyStroke($_act, $_dat, $_win, $_obj, $line)
	Opt("WinTitleMatchMode", -2) 
	If WinActivate($_win) Then
		Opt("SendKeyDownDelay", 5)
		Send($_dat)
		Return $PASS
	Else
		ConsoleWrite("ERROR: KeyStroke Could not find window" & $_win & @LF)		
		Return $ERROR
	EndIf

EndFunc

Func Handler_Skip($_act, $_dat, $_win, $_obj, $line)
	ConsoleWrite("Handler_Skip: Line " & $line & " intentionally skipped" & @LF)		
	Return $PASS
EndFunc

Func Handler_Sleep($_act, $_dat, $_win, $_obj, $line)
	ConsoleWrite("Sleep(" & $_dat & ")" & @LF)
	Sleep($_dat)
	Return $PASS
EndFunc

Func Handler_ENDTEST($_act, $_dat, $_win, $_obj, $line)
	;ConsoleWrite("ENDTEST" & $_dat & " " & @LF)	
	Return $ENDTEST
EndFunc