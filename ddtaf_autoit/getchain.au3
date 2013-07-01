#include <file.au3>

Func GetChain_FromTextFile($filename)

	Dim $aRecords
	Dim $aChain[1] 

	$message = "Please select a test file to run"
	
	;if filename passed is empty, query for a name, othewise, run with it
	Dim $var

	if $filename == "" Then
		$var = FileOpenDialog($message, @ScriptDir & "\Tests", "Text files (*.csv)|All (*.*)"  , 1 + 4 )
	Else
		_DebugOut("Test File: " & $filename)
		$var = @ScriptDir & "\Tests\" & $filename
	EndIf

	
	If @error Then
		MsgBox(4096,"","No File(s) chosen")
	Else
		_DebugSetup("RESULTS for " & $var)
		If Not _FileReadToArray( $var,$aRecords) Then
			MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
			Exit
		Else
			Dim $temparray[8]
			For $x = 1 to $aRecords[0]
				$oneTestLine = StringSplit($aRecords[$x], ",")
				For $i = 1 To $oneTestLine[0]
					$temparray[$i - 1] = $oneTestLine[$i]
					;ConsoleWrite($x & ":" & $i - 1 & "  " & $temparray[$i - 1] & "| ")
				Next
				$aChain[$x-1] = $temparray
				_ArrayAdd($aChain, $temparray)
				
				ConsoleWrite(@LF)
			Next
			_ArrayPop($aChain);temp bug fix, because we keep getting en extra line
		EndIf
	EndIf
	;_ArrayDisplay($aChain)
	return $aChain
EndFunc
