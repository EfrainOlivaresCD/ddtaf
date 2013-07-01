$ERROR = -1
$FAIL = 0
$PASS = 1
$ENDTEST = 2

#include <debug.au3>
#include <getchain.au3>
#include <comhandlers.au3>

Dim $Com_Chain

_DebugSetup("RESULTS for " & @ScriptName)

if $CmdLine[0] > 0 Then
	$Com_Chain = GetChain_FromTextFile($CmdLine[1])
Else
	$Com_Chain = GetChain_FromTextFile("")
EndIf


$Com = $Com_Chain[0]
$text = $Com[0]

$c = 0
While True
	;_ArrayDisplay($Com)
	$com_res = COM($Com[0], $Com[1], $Com[2], $Com[3], $c)

	;ConsoleWrite("for Command # " & $c & " the result is " & $com_res & @LF)
	If $com_res == $ENDTEST Then
		ExitLoop
	EndIf
	
	$c = $c + 1
	$Com_onError = $Com[4] ;save this BEFORE incrementing, if there was error, this tells us what to do.
	$Com = $Com_Chain[$c]
	;_ArrayDisplay($Com)
	if $com_res == $ERROR Then
		ChannelDebug("Directive on ERROR is <" & $Com_onError & ">" & @LF)
		if $Com_onError == 'continue' Then
			_DebugOut("Continue directive on ERROR, ignoring error" & @LF)
		ElseIf $Com_onError == 'stop' Then
			_DebugSetup("stop directive on ERROR, ending test" & @LF)
			ExitLoop
		ElseIf $Com_onError == "" Then
			_DebugSetup("no directive found on ERROR, ending test" & @LF)
			ExitLoop
		EndIf
	EndIf
Wend
