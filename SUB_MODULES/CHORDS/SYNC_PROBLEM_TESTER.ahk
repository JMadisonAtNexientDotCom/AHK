;------------------------------------------------------------------------------+
;##############################################################################|
#NoEnv  ; Performance & Compatibility.                             ############|
; #Warn ; Enable Warnings For Debugging.                           ############|
SendMode Input  ; Superior Speed and Reliability.                  ############|
SetWorkingDir %A_ScriptDir%  ; Ensures consistent start directory. ############|
;##############################################################################|
;------------------------------------------------------------------------------+


global COUNTER
INIT_GLOBALS(void)
{
	COUNTER := 0
	return
}
INIT_GLOBALS(void)

DO_IT()
{
	
	;clipBoard = [%COUNTER%]
	;clipBoard = %COUNTER%
	;clipBoard = A
	;send ^v
	;send {enter}
	;send m
	
	loop, 5
	{
	COUNTER := COUNTER + 1
	send [%COUNTER%]
	}
	
	
	return
}

Q::
{
DO_IT()
return
}

W::
{
DO_IT()
return
}

E::
{
DO_IT()
return
}

R::
{
DO_IT()
return
}






