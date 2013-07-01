#include <file.au3>
#include <array.au3>

$tablesize = 500
Dim $Table[$tablesize][3]

Func ReadTable($table_file)
	_DebugOut("Using Table: " & $table_file)
	Dim $lines
	Dim $oneLinetemp[8]
	
	$table_file = @ScriptDir & "\Tables\" & $table_file
	ConsoleWrite($table_file & @LF)
	If Not _FileReadToArray( $table_file, $lines) Then
		MsgBox(4096,"Error", " Error reading Table " & $table_file & " to Array     error:" & @error)
		Return $ERROR
	EndIf
	
	$i = 0
	;_ArrayDisplay($lines)
	For $x = 1 to $lines[0]
		$oneLineTemp = StringSplit($lines[$x], ",")
		;_ArrayDisplay($oneLineTemp, "in for lool")
		If $oneLineTemp[0] == 4 Then
			;_ArrayDisplay($oneLineTemp, "after stringsplit")
			;ConsoleWrite($oneLineTemp[1] & @LF)
			$Table[$i][0] = $oneLineTemp[1] & $oneLineTemp[2]
			$Table[$i][1] = $oneLineTemp[3]
			$Table[$i][2] = $oneLineTemp[4]
		EndIf
		$i = $i + 1
		;_ArrayDisplay($Table, "table")
	Next
	return $PASS
EndFunc
	
Func ID($_win_obj, $raw = 0)
	;ConsoleWrite("Looking for " & $_win_obj & @LF)
	
	For $i = 0 To $tablesize - 1 Step 1
		;ConsoleWrite($i & ":  " & $Table[$i][0] & @LF)
		If $_win_obj == $Table[$i][0] Then
			;ConsoleWrite("Returning ID " & $Table[$i][1] & @LF)
			if $raw == 1 Then
				Return $Table[$i][1]
			Else
				Return "[ID:" & $Table[$i][1] & "]"
			EndIf
		EndIf
	Next
	ConsoleWrite("TABLE ERROR, Could not find: " & @LF)
	ConsoleWrite(@TAB & "SOURCE: " & $_win_obj & @LF)
	Return "[ID:0000]"	
EndFunc

Func CLASS($_win_obj)
	;ConsoleWrite("Looking for " & $_win_obj & @LF)
	For $i = 0 To $tablesize - 1 Step 1
		;ConsoleWrite($i & ":  " & $Table[$i][0] & @LF)
		If $_win_obj == $Table[$i][0] Then
			;ConsoleWrite("Returning CLASS" & $Table[$i][2] & @LF)
			;_ArrayDisplay($Table)
			Return $Table[$i][2]
		EndIf
	Next
	ConsoleWrite("TABLE ERROR, Could not find: " & @LF)
	ConsoleWrite(@TAB & "SOURCE: " & $_win_obj & @LF)
	Return "NONE"	
EndFunc