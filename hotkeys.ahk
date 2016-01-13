#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;http://www.autohotkey.com/board/topic/87597-help-me-use-global-variables/
SetDefaults(void)
{
global
TheList= fora,bena,iana

 
  ;As nice as it would be to use a shortcut file... lookups this way are SLOW!
        ; Create the array, initially empty:
        SNIPPET_SHORTCUT_ARRAY     := Object()
				ANG_SNIPPET_SHORTCUT_ARRAY := Object()
				IMP_SNIPPET_SHORTCUT_ARRAY := Object()
				JSP_JSTL_CS_SHORTCUT_ARRAY := Object() ;//CS == Code Snippet.
				;//FUNC_MAPPER_SHORTCUT_ARRAY := Object() ;//function mapping.
				
				;//like SNIPPET_SHORTCUT_ARRAY, 
				;//but has "]" symbols at the end of the words.
				SNIPPET_SHORTCUT_ARRAY_MATCHLIST     = test],try]
				ANG_SNIPPET_SHORTCUT_ARRAY_MATCHLIST = test2],try2]
				IMP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST = test2],try2]
				JSP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST = test4],try4] ;//JSP & JSTL
				;//FUNC_MAPPER_SHORTCUT_ARRAY_MATCHLIST = test8],try8] ;//FUNCTIONS.
				
				;//Create associative array that will map shortcut names to functions.
				SNIPPET_SHORTCUT_ASSOC_ARRAY     := {"testKey":"testValue"}
				ANG_SNIPPET_SHORTCUT_ASSOC_ARRAY := {"testKey":"testValue"}
				IMP_SNIPPET_SHORTCUT_ASSOC_ARRAY := {"testKey":"testValue"}
				JSP_SNIPPET_SHORTCUT_ASSOC_ARRAY := {"testKey":"testValue"}
				;//FUNC_MAPPER_SHORTCUT_ASSOC_ARRAY := {"testKey":"testValue"}
				
				;//ARR_TEST = for],while],main],ps],pv],cs],cdplayerconfig],compactdisc],sgtpeppers],sia_listing],cdplayertest]
 
        ;//BUGFIX:
				;//declare these outside of the loop,
				;//or they will be constantly cleared before they are used.
				theShortCutNameKey := "empty"
				theFuncNameValue   := "emptyFunc"
 
        ; Write to the array:
        ; This loop retrieves each line from the file, one at a time.
        loopcounter :=0
        Loop, Read, CODE_SNIPPET\FILE_TO_KEY_MAPPING.txt
        {
				
					;//make a function lookup table so
					;//we can get rid of horrible long chain of else-if statements.
					
					;base 1 calculations for indexes in file
					loopcounter++
					if(loopcounter>3)
					{
						loopcounter = 1
					}
				 
					if(loopcounter = 1)
					{
						;//Gather the SHORCUT FUNCTION NAME.
						theFuncNameValue = %A_LoopReadLine%   ;//<<correct. use "=" not ":="
						;//MsgBox %theFuncNameValue%
					}else
					if(loopcounter = 2)
					{
						theShortCutNameKey = %A_LoopReadLine%
						SNIPPET_SHORTCUT_ARRAY.Insert(A_LoopReadLine) ; Append this line to the array.
						SNIPPET_SHORTCUT_ARRAY_MATCHLIST = %SNIPPET_SHORTCUT_ARRAY_MATCHLIST%,%A_LoopReadLine%] ;//concatinate a list. And put bracket at end.
						
						;//assemble the current function shortcut key
						;//and function name together into associative array
						;//SNIPPET_SHORTCUT_ASSOC_ARRAY[theKey] := theFuncName <<wrong way to do it.
						SNIPPET_SHORTCUT_ASSOC_ARRAY.Insert(theShortCutNameKey,theFuncNameValue)
						;//MsgBox %theShortCutNameKey% %theFuncNameValue%
					}
					
					;//MsgBox %theShortCutNameKey% %theFuncNameValue%
												
        } ;END OF LOOP
				
				;//ANGULAR SHORTCUTS READING FILE. Horrible code duplication, I know.... But gotta get this done fast.
				;//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
				loopcounter :=0
        Loop, Read, CODE_SNIPPET\ANGULAR_JS_KEY_MAP.txt
        {
				
					;//make a function lookup table so
					;//we can get rid of horrible long chain of else-if statements.
					
					;base 1 calculations for indexes in file
					loopcounter++
					if(loopcounter>3)
					{
						loopcounter = 1
					}
				 
					if(loopcounter = 1)
					{
						;//Gather the SHORCUT FUNCTION NAME.
						theFuncNameValue = %A_LoopReadLine%   ;//<<correct. use "=" not ":="
						;//MsgBox %theFuncNameValue%
					}else
					if(loopcounter = 2)
					{
						theShortCutNameKey = %A_LoopReadLine%
						ANG_SNIPPET_SHORTCUT_ARRAY.Insert(A_LoopReadLine) ; Append this line to the array.
						ANG_SNIPPET_SHORTCUT_ARRAY_MATCHLIST = %ANG_SNIPPET_SHORTCUT_ARRAY_MATCHLIST%,%A_LoopReadLine%] ;//concatinate a list. And put bracket at end.
						ANG_SNIPPET_SHORTCUT_ASSOC_ARRAY.Insert(theShortCutNameKey,theFuncNameValue)
					}
					
					;//MsgBox %theShortCutNameKey% %theFuncNameValue%
												
        } ;END OF LOOP
				;//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
				
				;//IMPORT SHORTCUTS READING FILE. Horrible code duplication, I know....
				;//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
				loopcounter :=0
        Loop, Read, CODE_SNIPPET\IMPORT_MAPPING.txt
        {
				
					;//make a function lookup table so
					;//we can get rid of horrible long chain of else-if statements.
					
					;base 1 calculations for indexes in file
					loopcounter++
					if(loopcounter>3)
					{
						loopcounter = 1
					}
				 
					if(loopcounter = 1)
					{
						;//Gather the SHORCUT FUNCTION NAME.
						theFuncNameValue = %A_LoopReadLine%   ;//<<correct. use "=" not ":="
						;//MsgBox %theFuncNameValue%
					}else
					if(loopcounter = 2)
					{
						theShortCutNameKey = %A_LoopReadLine%
						IMP_SNIPPET_SHORTCUT_ARRAY.Insert(A_LoopReadLine) ; Append this line to the array.
						IMP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST = %IMP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST%,%A_LoopReadLine%] ;//concatenate a list. And put bracket at end.
						IMP_SNIPPET_SHORTCUT_ASSOC_ARRAY.Insert(theShortCutNameKey,theFuncNameValue)
					}
					
					;//MsgBox %theShortCutNameKey% %theFuncNameValue%
												
        } ;END OF LOOP
				;//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
				
				;//JSTL and JSP shortcuts:
				;//JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
				loopcounter :=0
        Loop, Read, CODE_SNIPPET\JSP_JSTL_MAPPING.txt
        {
				
					;//make a function lookup table so
					;//we can get rid of horrible long chain of else-if statements.
					
					;base 1 calculations for indexes in file
					loopcounter++
					if(loopcounter>3)
					{
						loopcounter = 1
					}
				 
					if(loopcounter = 1)
					{
						;//Gather the SHORCUT FUNCTION NAME.
						theFuncNameValue = %A_LoopReadLine%   ;//<<correct. use "=" not ":="
						;//MsgBox %theFuncNameValue%
					}else
					if(loopcounter = 2)
					{
						theShortCutNameKey = %A_LoopReadLine%
						JSP_SNIPPET_SHORTCUT_ARRAY.Insert(A_LoopReadLine) ; Append this line to the array.
						JSP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST = %JSP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST%,%A_LoopReadLine%] ;//concatenate a list. And put bracket at end.
						JSP_SNIPPET_SHORTCUT_ASSOC_ARRAY.Insert(theShortCutNameKey,theFuncNameValue)
					}
					
					;//MsgBox %theShortCutNameKey% %theFuncNameValue%
												
        } ;END OF LOOP
				;//JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ
				
				
				
					
	;//MsgBox "Initialized:"%SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
	;MsgBox "Initialized:"%IMP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
	;//MsgBox %SNIPPET_SHORTCUT_ARRAY%
 
return
}
 
SetDefaults(void)


; /////////////Enter move mode script///////////////////////////////////////////
!J::
{
enterMoveMode(void)
return
}

!L::
{
enterMoveMode(void)
return
}

!I::
{
enterMoveMode(void)
return
}

!K::
{
enterMoveMode(void)
return
}
; /////////////ONLY WHEN IN MOVE MODE///////////////////////////////////////////


enterMoveMode(void)
{
Run, %A_ScriptDir%\SUB_MODULES\MoveMode.ahk
exitApp
}

!M::
{
   ;//MsgBox, "ALT + M??"
	 Run, %A_ScriptDir%\SUB_MODULES\HackingDrawScreen.ahk
	 exitApp ;//exit this script so selector hotkeys can take over.
   ;return
}

;// http://www.autohotkey.com/board/topic/99092-remap-colon-key-help/
; `: will use for ":" key.
;// http://www.autohotkey.com/board/topic/80246-shift-key-bind/
; Tilde "~" makes key fire on press rather than release.
;// http://superuser.com/questions/425873/replace-with-and-with-using-autohotkey



;// When you BAIL OUT of the user input, we want to print a ":" or ";" character
;// to the screen. So that this code does not disrupt typing of multiple
;// colons to the screen. Currently it does. So I commented it out, because
;// I am not using JSTL shortcuts right now.
;//			 ;~`;::
;//			 *$;::
;//			 ;//`;::
;//			 {
;//			 ;;MsgBox, "hello"
;//				GetKeyState, state, Shift
;//				myState = %state%
;//				;;MsgBox, "STATE===["%myState%
;//				
;//				 
;//				 if(myState="D")
;//				 {
;//						send,{:}
;//						ON_FULL_COLON_PRESS()
;//					}
;//					else
;//					{
;//						;SEND, "NOT DOWN"
;//						send,{;}
;//						ON_SEMI_COLON_PRESS()
;//					} 
;//					 return
;//			 }

 
ON_FULL_COLON_PRESS()
{
	global JSP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST
	Input, UserInput, V T5 L20 C, {enter}{esc}{tab}{backspace}!, %JSP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
	JSP_JSTL_SHORTCUT_TRY(UserInput)
	return
}

ON_SEMI_COLON_PRESS()
{
	
	return
}

~!::
{
	;//is not able to work before text becomes un-highlighted.
	;//send ^c ;//So you can convert highlighted text.

	global IMP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST
	;//MsgBox "Angular Will Go Here"
	Input, UserInput, V T5 L20 C, {enter}{esc}{tab}{backspace}!, %IMP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
	IMPORT_SHORTCUT_TRY(UserInput)
	;//MsgBox "userInput==" %UserInput%
}

IMPORT_SHORTCUT_TRY(UserInput)
{
	;//Declare the globals you are using:
	;//http://www.autohotkey.com/board/topic/87597-help-me-use-global-variables/
	global IMP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST
	global IMP_SNIPPET_SHORTCUT_ASSOC_ARRAY
	
	;//msgbox %UserInput%
	;//msgbox MATCHLIST==%SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
	
	bailOut = HAS_EXIT_WORTHY_ERROR(ErrorLevel)
	if(bailOut = true)
	{
		;//msgbox "CANCELLED"
		return
	}
	
	If InStr(ErrorLevel, "EndKey:")
	{
			;//MsgBox, You entered "%UserInput%" and terminated the input with %ErrorLevel%.
			exclaim = {!}
			exclaim2 = %exclaim%
			if(ErrorLevel = "EndKey:!" )
			{
				global IMP_SNIPPET_SHORTCUT_ASSOC_ARRAY ;//declare again for this scope?
				;//MsgBox, Meow
				;//try to convert clipboard contents
				ClipBoard = %ClipBoard%
				SubInput = %ClipBoard%
				
				;//MsgBox, %IMP_SNIPPET_SHORTCUT_ASSOC_ARRAY%
				possibleFileName:= IMP_SNIPPET_SHORTCUT_ASSOC_ARRAY[SubInput]
				possibleFileNameLen:=StrLen(possibleFileName)
				;//MsgBox, "SubInput Is" %SubInput%
				if(possibleFileNameLen > 0)
				{
					DELETE_WORD("!!",0)
					PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE(possibleFileName)
				}
				else
				{
					return
				}
				
			}
			else
			{
			return
			}
			
		return ;always return if error to fix typing to fast error?
	}
	; Otherwise, a match was found.
	
	
	
  ;//call function by unfiltered user input:
	;///////////////////////////////////////////////////////////////////
		;Strip the ending brace "]" off of our matches using
		;StrLen and SubStr methods.
		;Then do matches against "SubInput" rather than "UserInput"
		Len:=StrLen(UserInput) ;getting correct length of 4 for "for]"
		LenToUse:=Len-1
		;MsgBox %LenToUse%
		SubInput:=SubStr(UserInput,1, LenToUse)
		;//MsgBox SubInput==%SubInput%
		
		;//MsgBox "ASSOC ARR IS==" %IMP_SNIPPET_SHORTCUT_ASSOC_ARRAY%
		
		possibleFileName:= IMP_SNIPPET_SHORTCUT_ASSOC_ARRAY[SubInput]
		;MsgBox % possibleFileName
		possibleFileNameLen:=StrLen(possibleFileName)
		;//MsgBox % possibleFileNameLen
		
		;//if key exists in dictionary, call the function
		;//that it is paired with, then finalize.
		if(possibleFileNameLen > 0)
		{
			DELETE_WORD(SubInput,2)
			PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE(possibleFileName)
		}
		else
		{
			;//MsgBox, "NOT FOUND: CARROT_CAKE"
		}
  ;////////////////////////////////////////////////////////////////////
		
	return
}

~<::
{
  global ANG_SNIPPET_SHORTCUT_ARRAY_MATCHLIST
	;//MsgBox "Angular Will Go Here"
	Input, UserInput, V T5 L20 C, {enter}{esc}{tab}{backspace}, %ANG_SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
	ANGULAR_SHORTCUT_TRY(UserInput)
	;//MsgBox "userInput==" %UserInput%
	
	;return might be needed for angular hotkeys to not flow into other hotkeys.
	return
}

JSP_JSTL_SHORTCUT_TRY(UserInput)
{
;//Declare the globals you are using:
	;//http://www.autohotkey.com/board/topic/87597-help-me-use-global-variables/
	global JSP_SNIPPET_SHORTCUT_ARRAY_MATCHLIST
	global JSP_SNIPPET_SHORTCUT_ASSOC_ARRAY
	
	;//msgbox %UserInput%
	;//msgbox MATCHLIST==%SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
	
	bailOut = HAS_EXIT_WORTHY_ERROR(ErrorLevel)
	if(bailOut = true)
	{
		;//msgbox "CANCELLED"
		return
	}
	
	If InStr(ErrorLevel, "EndKey:")
	{
			;MsgBox, You entered "%UserInput%" and terminated the input with %ErrorLevel%.
			return
	}
	; Otherwise, a match was found.
	
	
	
  ;//call function by unfiltered user input:
	;///////////////////////////////////////////////////////////////////
		;Strip the ending brace "]" off of our matches using
		;StrLen and SubStr methods.
		;Then do matches against "SubInput" rather than "UserInput"
		Len:=StrLen(UserInput) ;getting correct length of 4 for "for]"
		LenToUse:=Len-1
		;MsgBox %LenToUse%
		SubInput:=SubStr(UserInput,1, LenToUse)
		;//MsgBox SubInput==%SubInput%
		
		possibleFileName:= JSP_SNIPPET_SHORTCUT_ASSOC_ARRAY[SubInput]
		;MsgBox % possibleFileName
		possibleFileNameLen:=StrLen(possibleFileName)
		;//MsgBox % possibleFileNameLen
		
		;//if key exists in dictionary, call the function
		;//that it is paired with, then finalize.
		if(possibleFileNameLen > 0)
		{
			DELETE_WORD(SubInput,2)
			PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE(possibleFileName)
		}
		else
		{
			;//MsgBox, "NOT FOUND: BROCOLLI"
		}
  ;////////////////////////////////////////////////////////////////////
		
	return
} ;;;//JSTL & JSP shortcuts.

ANGULAR_SHORTCUT_TRY(UserInput)
{
	;//Declare the globals you are using:
	;//http://www.autohotkey.com/board/topic/87597-help-me-use-global-variables/
	global ANG_SNIPPET_SHORTCUT_ARRAY_MATCHLIST
	global ANG_SNIPPET_SHORTCUT_ASSOC_ARRAY
	
	;//msgbox %UserInput%
	;//msgbox MATCHLIST==%SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
	
	bailOut = HAS_EXIT_WORTHY_ERROR(ErrorLevel)
	if(bailOut = true)
	{
		;//msgbox "CANCELLED"
		return
	}
	
	If InStr(ErrorLevel, "EndKey:")
	{
			;MsgBox, You entered "%UserInput%" and terminated the input with %ErrorLevel%.
			return
	}
	; Otherwise, a match was found.
	
	
	
  ;//call function by unfiltered user input:
	;///////////////////////////////////////////////////////////////////
		;Strip the ending brace "]" off of our matches using
		;StrLen and SubStr methods.
		;Then do matches against "SubInput" rather than "UserInput"
		Len:=StrLen(UserInput) ;getting correct length of 4 for "for]"
		LenToUse:=Len-1
		;MsgBox %LenToUse%
		SubInput:=SubStr(UserInput,1, LenToUse)
		;//MsgBox SubInput==%SubInput%
		
		possibleFileName:= ANG_SNIPPET_SHORTCUT_ASSOC_ARRAY[SubInput]
		;MsgBox % possibleFileName
		possibleFileNameLen:=StrLen(possibleFileName)
		;//MsgBox % possibleFileNameLen
		
		;//if key exists in dictionary, call the function
		;//that it is paired with, then finalize.
		if(possibleFileNameLen > 0)
		{
			DELETE_WORD(SubInput,2)
			PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE(possibleFileName)
		}
		else
		{
			;//MsgBox, "NOT FOUND: CHEETOS"
		}
  ;////////////////////////////////////////////////////////////////////
		
	return
} ;//angular shortcut try.









 ~[::
 {
 ;//MSGBox "user input test..."
 	Input, UserInput, V T5 L30 C, {enter}{esc}{tab}{backspace}, %SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
 	BRACKET_SHORTCUT_TRY(UserInput)
	return
 }
 
 ;; possible that short var names make script less glitchy?
PONE_SIM_PASTE(){

	empty_string := ""  ;//set to empty string.
	fixboard   := RegExReplace(Clipboard, "\R", empty_string) ;//remove newlines

	;//Get rid of extra spaces. Up to 40 in a row:
	;//https://autohotkey.com/board/topic/8690-little-math-replacing-multiple-spaces-with-one/
	StringReplace fixboard, fixboard, %A_Space%    %A_Space%, %A_Space%, All 
	StringReplace fixboard, fixboard, %A_Space% %A_Space%, %A_Space%, All 
	StringReplace fixboard, fixboard, %A_Space%%A_Space%, %A_Space%, All 
	StringReplace fixboard, fixboard, %A_Space%%A_Space%, %A_Space%, All
	
	;My edit. NOTE: spacing of lines is intentional I believe.
	StringReplace fixboard, fixboard, %A_Tab%    %A_Tab%, %A_Tab%, All 
	StringReplace fixboard, fixboard, %A_Tab% %A_Tab%, %A_Tab%, All 
	StringReplace fixboard, fixboard, %A_Tab%%A_Tab%, %A_Tab%, All 
	StringReplace fixboard, fixboard, %A_Tab%%A_Tab%, %A_Tab%, All
	
	
	SendInput, {Raw}%fixboard%
	return

}
 
PASTE_CLIPBOARD_USING_SIMULATED_TYPING()
{
	;//clipboard = %clipboard%
	;//send %clipboard%
	;//SendInput, {Raw}%clipboard%
	
	;// http://www.autohotkey.com/board/topic/85303-having-an-issue-replacing-crlf-with-regexreplace/
	;//replace the newlines, with newlines.
	;//I think the RegExReplace looks for CRLF or CR or LF
	;//So if you replace with "" you get a single line.
	;//The hack is to replace "\R" with "\R" which seems like it would do
	;//Nothing, but it effectively prevents line-endings from becomming
	;//compounded. Thus warding of the double-spacing that was happening
	;//when we cut+pasted.
	thisR = `r
	fixboard := RegExReplace(Clipboard, "\R", thisR)
	SendInput, {Raw}%fixboard%
	;//SendInput,%fixboard%   ;//<---makes one long string.
	return
}

;used for inserting snippets. Example [for] writes a for-loop snippet.
BRACKET_SHORTCUT_TRY(UserInput)
;~[::
{

	poneVar = pone`]
  pasteUpperVar = pu`]
  pasteLowerVar = pl`]
	
	if(UserInput = poneVar)
	{
		DELETE_WORD("pone",2)
		PONE_SIM_PASTE()
		;PASTE_CLIPBOARD_USING_SIMULATED_TYPING()
		return
	}
  
  if(UserInput = pasteUpperVar){
    DELETE_WORD("pu",2)
    PASTE_CLIPBOARD_AS_UPPERCASE()
    return
  }
  
  if(UserInput = pasteLowerVar){
    DELETE_WORD("pl",2)
    PASTE_CLIPBOARD_AS_LOWERCASE()
    return
  }

  ;//I HAVE NO CLUE WHY THIS NEEDS AN ENTER KEY TO BE INVOKED?? AH...
	;//It still needs to be in the match list. Even though we are overriding it.
	;//special case for my SEND_PASTE command:
	;//sends contents of clipboard. Making it possible
	;//to paste to command prompt, youtube, and whatever else you need.
	pasteVar = paste`]
	;//pasteVar = paste
	;//msgBox, %pasteVar%
	;//msgBox, userinput== %UserInput%
	if(UserInput = pasteVar)
	{
		;//msgbox, "paste dsfsdfsdfasdf"
		
		DELETE_WORD("paste",2)
		
		PASTE_CLIPBOARD_USING_SIMULATED_TYPING()
		
		
		return
	}
	
	
	

	;//Declare the globals you are using:
	;//http://www.autohotkey.com/board/topic/87597-help-me-use-global-variables/
	global SNIPPET_SHORTCUT_ARRAY_MATCHLIST
	global SNIPPET_SHORTCUT_ASSOC_ARRAY
	
	;//msgbox %UserInput%
	;//msgbox MATCHLIST==%SNIPPET_SHORTCUT_ARRAY_MATCHLIST%

	;Input, UserInput, V T5 L20 C, {enter}.{esc}{tab}{backspace}, %SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
	
	if (ErrorLevel = "Max")
	{
			;MsgBox, You entered "%UserInput%", which is the maximum length of text.
			return
	}
	if (ErrorLevel = "Timeout")
	{
			;MsgBox, You entered "%UserInput%" at which time the input timed out.
			return
	}
	if (ErrorLevel = "NewInput")
			return
	If InStr(ErrorLevel, "EndKey:")
	{
			;MsgBox, You entered "%UserInput%" and terminated the input with %ErrorLevel%.
			return
	}
	; Otherwise, a match was found.
	
	
	
  ;//call function by unfiltered user input:
	;///////////////////////////////////////////////////////////////////
		;Strip the ending brace "]" off of our matches using
		;StrLen and SubStr methods.
		;Then do matches against "SubInput" rather than "UserInput"
		Len:=StrLen(UserInput) ;getting correct length of 4 for "for]"
		LenToUse:=Len-1
		;MsgBox %LenToUse%
		SubInput:=SubStr(UserInput,1, LenToUse)
		;MsgBox SubInput==%SubInput%
		
		possibleFileName:= SNIPPET_SHORTCUT_ASSOC_ARRAY[SubInput]
		;MsgBox % possibleFileName
		possibleFileNameLen:=StrLen(possibleFileName)
		;//MsgBox % possibleFileNameLen
		
		;//if key exists in dictionary, call the function
		;//that it is paired with, then finalize.
		if(possibleFileNameLen > 0)
		{
			DELETE_WORD(SubInput,2)
			PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE(possibleFileName)
		}
		else
		{
			MsgBox, "APPLE PIE AND CAKE (NOT FOUND)"
		}
  ;////////////////////////////////////////////////////////////////////
		
	return
}

~>::
{
	Input, UserInput, V T5 L10 C, {enter}.{esc}{tab}{space},gui1,gui2,testbat,cmake,dev,java,hibernate,google,rapid,chrono,clarizen,asana,eclipse,notepad,joblog,gitbash,github,welcome,paint,hotkeys,wamp,word,money,ontop,nts,putty,midori
	if (ErrorLevel = "Max")
	{
	    ;;this will conflict with HTML coding, so comment out the msg box.
			;;MsgBox, You entered "%UserInput%", which is the maximum length of text.
			return
	}
	if (ErrorLevel = "Timeout")
	{
			;;this will conflict with HTML coding, so comment out the msg box.
			;;MsgBox, You entered "%UserInput%" at which time the input timed out.
			return
	}
	if (ErrorLevel = "NewInput")
			return
	If InStr(ErrorLevel, "EndKey:")
	{
			if(ErrorLevel = "EndKey:Space")
			{
				;;do nothing for this terminating key.
			}
			else
			{
				;;MsgBox, You entered "%UserInput%" and terminated the input with %ErrorLevel%.
			}
			
			return
	}
	; Otherwise, a match was found.
	if (UserInput = "putty")
	{
		DELETE_WORD("putty",1)
		Run, "C:\DEV\PROG\SSH\Putty"
	}
	else if (UserInput = "gui1"){
		DELETE_WORD("gui1",1)
		Run, "C:\DEV\AHK\CODE_SNIPPET\NEXIENT_PROJECTS\GAUNTLET_UI\BAT\BootUp_01.bat"
	}
	else if (UserInput = "gui2"){
		DELETE_WORD("gui2",1)
		Run, "C:\DEV\AHK\CODE_SNIPPET\NEXIENT_PROJECTS\GAUNTLET_UI\BAT\BootUp_02.bat"
    }
    else if (UserInput = "testbat"){
		DELETE_WORD("testbat",1)
		Run, "C:\DEV\AHK\CODE_SNIPPET\NEXIENT_PROJECTS\GAUNTLET_UI\BAT\TestBat.bat"
    }
	else if (UserInput = "midori")
	{
		DELETE_WORD("midori",1)
		Run, "C:\DEV\PROG\MidoriBrowser\bin\midori.exe"
	}
	else if (UserInput = "cmake")
	{
		DELETE_WORD("cmake",1)
		Run, "C:\DEV\SDK\GAME_DEV\CMAKE\cmake-3.3.2-win32-x86\bin\cmake-gui.exe"
	}
	else if (UserInput = "dev")
	{
			Send, {backspace 5}
			Run, "C:\DEV"
	}
	else if (UserInput = "nts")
	{
		DELETE_WORD("nts",1)
		Run, "C:\DEV\REPO\GIT\Nexient-TestingService"
	}
	else if(UserInput = "ontop")
	{
		Run, "C:\DEV\PROG\AlwaysOnTopMaker\AlwaysOnTopMaker.exe"
	}
	else if(UserInput = "money")
	{
		Run, "C:\Users\jmadison\Desktop\NotOrganized\Money"
	}
	else if(UserInput = "word")
	{
		DELETE_WORD("word",1)
		Run, "C:\Program Files\Microsoft Office\Office14\WINWORD.exe"
	}
	else if (UserInput = "java")
	{
			Send, {backspace 6}
			Run, "C:\DEV\SDK\JAVA"
	}
	else if (UserInput = "hibernate")
	{
			Send, {backspace 10}
			Run, "C:\DEV\SDK\JAVA_TECH\HIBERNATE"
	}
	else if (UserInput = "google")
	{
			Send, {backspace 7}
			Run http://www.google.com
	}
	else if (UserInput = "asana")
	{
		Send, {backspace 6}
			Run https://app.asana.com
	}
	else if (UserInput = "clarizen")
	{
		Send, {backspace 9}
		Run https://app2.clarizen.com/
	}
	else if (UserInput = "rapid")
	{
		Send, {backspace 6}
		Run "C:\DEV\PROG\RapidEE\INST\RapidEE.exe"
	}
	else if (UserInput = "eclipse")
	{
		Send, {backspace 7}
		Run "C:\DEV\PROG\eclipse\eclipse.exe"
	}
	else if (UserInput = "notepad")
	{
		Send, {backspace 8}
		Run "C:\DEV\PROG\notePadPP\notepad++.exe"
	}
	else if (UserInput = "chrono")
	{
		Send, {backspace 7}
		;;ENV get is useless!!
		;;theEnvVar := "Meows"
		;;EnvGet, KEEP_THE_JOB_REPORT, theEnvVar ;;http://ahkscript.org/docs/commands/EnvGet.htm
		;;Send, % theEnvVar
		Run "C:\Users\jmadison\Desktop\KeepTheJobReport\CHRONO"
	}
	else if (UserInput = "joblog")
	{
		;;Send, {backspace theVar}
		DELETE_WORD("joblog",1)
		Run "C:\Users\jmadison\Desktop\KeepTheJobReport\JOB_LOG"
	}
	else if (UserInput = "gitbash")
	{
		DELETE_WORD("gitbash",1)
		Run "C:\DEV\PROG\Git\bin\sh.exe"
	}
	else if (UserInput = "welcome")
	{
		DELETE_WORD("welcome",1)
		Run "C:\Users\jmadison\Desktop\NotOrganized\welcome.txt"
	}
	else if (UserInput = "paint")
	{
		DELETE_WORD("paint",1)
		Run "C:\DEV\PROG\paintDNet\PaintDotNet.exe"
	}
	else if (UserInput = "hotKeys")
	{
		DELETE_WORD("hotKeys",1)
		;Run Edit "C:\DEV\hotkeys.ahk" ;http://www.autohotkey.com/board/topic/30483-how-to-open-a-file-in-notepad/
		Run "C:\DEV\PROG\notePadPP\notepad++.exe" "C:\DEV\hotkeys.ahk"
	}
	else if (UserInput = "wamp")
	{
		DELETE_WORD("wamp",1)
		Run "C:\DEV\SDK\JAVA_TECH\WAMPSERVER"
	}
	else if (UserInput = "github")
	{
		DELETE_WORD("github",1)
		Run "https://github.com/SystemsInMotion/Nexient-TestingService/find/master"
	}

	return
}

;;http://www.autohotkey.com/board/topic/91839-turning-off-and-on-switch/
;;CTRL(^) + ALT(!) + S,
;;used as toggle to turn auto hotkeys on/off.
^!s::
Suspend, Permit
Suspend, Toggle
Return

;A alternate way to enter shortcut using a dialog box:
^#r::  ; (^#r) === (CTRL + WINDOWS + R) key::
{
	;MsgBox "Test"
  ;//http://ahkscript.org/docs/commands/InputBox.htm
	;InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]
	InputBox, OutputVar
	;//Send, [%OutputVar%]
	closingBracketChar = ]
	argString = %OutputVar%%closingBracketChar%
	;//MsgBox %argString%
	BRACKET_SHORTCUT_TRY(argString)
	
}


;//If the file type is a text-only format like:
;//.txt, .html, .java, .cpp, .xml, then it will paste
;//the document using the clipboard.
;//If it is NOT friendly: .docx, .xls, .rtf, .pdf, .bmp, .jpg
;//Then it will be opened with the default program.
;//http://www.autohotkey.com/docs/commands/SplitPath.htm <will need this.
PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE(filePath){
	;//SplitPath, InputVar [, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive]
	SplitPath, filePath, dontCare01,  dontCare02, ext,  dontCare03,  dontCare04

	if(  (ext="docx") || (ext="pdf") || (ext="png") || (ext="exe") || (ext="bat"))
	{
		Run, %A_ScriptDir%\%filePath%
	}
	else
	{
		PASTE_FILE(filePath)
	}
	
	return
}

PASTE_CLIPBOARD_AS_UPPERCASE(){
  ;Store old contents of clipboard:
	clip_board_contents = %Clipboard%
  StringUpper Clipboard, clip_board_contents
  
  Send, ^v
  
  
  ;Restore Clipboard:
	sleep, 100 ;HACK: sleep so ^v call goes through. APPROX: 0.1 seconds.
	Clipboard = %clip_board_contents% 
}

PASTE_CLIPBOARD_AS_LOWERCASE(){
  ;Store old contents of clipboard:
	clip_board_contents = %Clipboard%
  StringLower Clipboard, clip_board_contents
  
  Send, ^v
  
  
  ;Restore Clipboard:
	sleep, 100 ;HACK: sleep so ^v call goes through. APPROX: 0.1 seconds.
	Clipboard = %clip_board_contents% 
}

;Dont know how to do with function
PASTE_FILE(filePathToRead){

  ;Store old contents of clipboard:
	clip_board_contents = %Clipboard%
	
  ;Read data into clipboard, and paste it:
	FileRead, Clipboard, %filePathToRead%
	Send, ^v
	
	;Restore Clipboard:
	sleep, 100 ;HACK: sleep for 999 milliseconds so ^v call goes through. APPROX: 0.1 seconds.
	Clipboard = %clip_board_contents% 
	
	return
}

PRINT_TEMPLATE_CONFIG_FILE_CONTENTS()
{
	theFilePath:="CODE_SNIPPET\FILE_TO_KEY_MAPPING.txt"
	PASTE_FILE(theFilePath) ;//RAWER.
	
	return
}

;;backspaces number of characters in inWord
;;plus whatever extra
DELETE_WORD(inWord, extra){
	varGoBackAmt := ( StrLen(inWord) + extra)
	Loop, %varGoBackAmt%
	{
		Send, {backspace}
	}
}

;//has an error that should make us bail out from the
;//function that is currently taking user input?
HAS_EXIT_WORTHY_ERROR(ERROR_LEVEL){
	if (ErrorLevel = "Max")
	{
	  return true
	}
	if (ErrorLevel = "Timeout")
	{
		return true
	}
	if (ErrorLevel = "NewInput")
	{
		return true
	}
	
	return false
}
