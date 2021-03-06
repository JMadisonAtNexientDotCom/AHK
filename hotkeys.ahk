﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;http://www.autohotkey.com/board/topic/87597-help-me-use-global-variables/
SetDefaults(void)
{
global
KONAMI := ""
CTRL_COPY_LIST := ""
CTRL_COPY_LIST_MAKER_IS_ON = false
TheList= fora,bena,iana

 
  ;As nice as it would be to use a shortcut file... lookups this way are SLOW.
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
;//    !J::
;//    {
;//    enterMoveMode(void)
;//    return
;//    }
;//    
;//    !L::
;//    {
;//    enterMoveMode(void)
;//    return
;//    }
;//    
;//    !I::
;//    {
;//    enterMoveMode(void)
;//    return
;//    }
;//    
;//    !K::
;//    {
;//    enterMoveMode(void)
;//    return
;//    }
; /////////////ONLY WHEN IN MOVE MODE///////////////////////////////////////////


enterMoveMode(void)
{
Run, %A_ScriptDir%\SUB_MODULES\MoveMode.ahk
exitApp
}


;		!M::
;		{
;			 ;//MsgBox, "ALT + M??"
;			 Run, %A_ScriptDir%\SUB_MODULES\HackingDrawScreen.ahk
;			 exitApp ;//exit this script so selector hotkeys can take over.
;			 ;return
;		}

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
					DIRECTPASTE_OR_WORK_WITH_FILE_POINTED_TO(possibleFileName, SubInput)
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
			DIRECTPASTE_OR_WORK_WITH_FILE_POINTED_TO(possibleFileName, SubInput)
		}
		else
		{
			;//MsgBox, "NOT FOUND: CARROT_CAKE"
		}
  ;////////////////////////////////////////////////////////////////////
		
	return
}

;Here we decide if we need to paste the file path directly, or if we
;need to work with the contents of the file.
DIRECTPASTE_OR_WORK_WITH_FILE_POINTED_TO(filePath, shortcutPhrase)
{
  ;if shortcutPhrase starts with "/" and filePath starts with C:\,
	;then we will directly paste the filePath, else we will
	;move onto PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE
	PHRASE_START := subStr(shortcutPhrase,1,1)
	FILE_PATH_START := subStr(filePath,1,3)
	HAS_PHRASE_START := 0
	HAS_FILE_PATH_START := 0
	
	if(PHRASE_START == "/")
	{
	HAS_PHRASE_START := 1
	}
	if(FILE_PATH_START == "C:\")
	{
	HAS_FILE_PATH_START := 1
	}
	
	TOTAL := HAS_PHRASE_START + HAS_FILE_PATH_START
	if(TOTAL == 2)
	{
		;msgBox TODODDODOD GET_IT_DONE
		PASTE_TEXT(filePath)
	}
	else
	{
		PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE(filePath)
	}
	
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
			DIRECTPASTE_OR_WORK_WITH_FILE_POINTED_TO(possibleFileName, SubInput)
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
			DIRECTPASTE_OR_WORK_WITH_FILE_POINTED_TO(possibleFileName, SubInput)
		}
		else
		{
			;//MsgBox, "NOT FOUND: CHEETOS"
		}
  ;////////////////////////////////////////////////////////////////////
		
	return
} ;//angular shortcut try.


;konami code to activate chord script
;tilde makes key ignore all modifier.
~space::
{

Input, UserInput, V T5 L10 C, {enter}.{esc}{tab},wwssadad

	if (ErrorLevel =="Max" || ErrorLevel == "Timeout" || ErrorLevel == "NewInput")
	{
	return
	}
	
	; NOT SURE WHAT THIS DOES:
	THE_BOOL := false
	THE_BOOL = (InStr(ErrorLevel,"EndKey:")
	if(THE_BOOL)
	{
		if (UserInput = "wwssadad")
		{
			DELETE_WORD("wwssadad",1)
			Run, %A_ScriptDir%\SUB_MODULES\CHORDS\CHORD_SCRIPT.ahk
		}
	}
return
}




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

;turn clipboard list making on:
DO_CLIP_LIST_MAKER_INIT(){
	global CTRL_COPY_LIST_MAKER_IS_ON
	global CTRL_COPY_LIST
	
	;msgBox list_maker_init
	
	CTRL_COPY_LIST_MAKER_IS_ON = true
	CTRL_COPY_LIST := ""
	return
}

~^c::
{
    ;tilde (~) used to that ^c event is not eaten.
	ON_CONTROL_C_OR_X()
	return
}

~^x::
{
	 ;tilde (~) used to that ^x event is not eaten.
	ON_CONTROL_C_OR_X()
	return
}

;proc to do when ctrl+c is pressed:
ON_CONTROL_C_OR_X(){
	global CTRL_COPY_LIST_MAKER_IS_ON
	
	;msgBox on_control_c entered
	
	if(CTRL_COPY_LIST_MAKER_IS_ON = "true"){
		sleep, 100 ;HACK: Make sure clipboard updated before we do our magic.
		DO_CLIP_LIST_MAKER_APPEND()
	}
	
	return
}

;add to the list of lines you are collecting using ctrl+v
DO_CLIP_LIST_MAKER_APPEND(){
    ;msgBox appending
    global CTRL_COPY_LIST
	;nl = `r`n ;newline char. CR-LF windows style.
	nl = `n ;newline, osx style. LF ONLY.
	
	if(CTRL_COPY_LIST==""){
	    ;no newline char for first entry.
		CTRL_COPY_LIST=%CTRL_COPY_LIST%%clipboard%
	}
	else
	{
		CTRL_COPY_LIST=%CTRL_COPY_LIST%%nl%%clipboard%
	}
	
	
	
	return
}

DO_CLIP_LIST_MAKER_DUMP(){

	;msgBox dumping list

    global CTRL_COPY_LIST
	;sendraw %CTRL_COPY_LIST%
	
	;put on clipboard, then ^v, then revert clipboard.
	PASTE_TEXTBLOCK(CTRL_COPY_LIST)
	
	
	return
}

;used for inserting snippets. Example [for] writes a for-loop snippet.
BRACKET_SHORTCUT_TRY(UserInput)
;~[::
{

  ;Clip board list making:
  clip_board_list_INIT = cc`] ;start using clipboard contents to assemble list.
  clip_board_list_DUMP = cd`] ;dump the list we have made, but do not erase it.
  randomErrorCPP = re`] ;random error hash generation.
  randErrCppTab2X= r2`] ;random error, 2 tabs of indent.
  cppIncludeGuardVar = ig`] ;include guard maker script.
	poneVar = pone`]
  pasteUpperVar = pu`]
  pasteLowerVar = pl`]
  
  if(UserInput = clip_board_list_INIT)
  {
	DELETE_WORD("cc",2)
	DO_CLIP_LIST_MAKER_INIT()
	return
  }
  
  if(UserInput = clip_board_list_DUMP)
  {
	DELETE_WORD("cd",2)
	DO_CLIP_LIST_MAKER_DUMP()
	return
  }
  
  if(UserInput = randErrCppTab2X){
    DELETE_WORD("r2",2)
    rhash := "A"
    rhash := RAND_HASH(rhash)
   
    template_path := "CODE_SNIPPET\AHK_TEMPLATE_INJECTION\RAND_ERR_CPP_TABS_2X.txt"
 
    codeblock := ""
    codeblock_edited := ""
    FileRead, codeblock, %template_path%
    codeblock_edited := RegExReplace(codeblock,"12345678",rhash)
    
    PASTE_TEXTBLOCK(codeblock_edited)
    return
  }
	
	if(UserInput = randomErrorCPP)
	{
		DELETE_WORD("re",2)
		rhash := "A"
		rhash := RAND_HASH(rhash)
		;send %rhash%
		
		template_path := "CODE_SNIPPET\AHK_TEMPLATE_INJECTION\RANDOM_ERROR_CPP.txt"
		;PASTE_FILE(mypath)
		
		codeblock := ""
		codeblock_edited := ""
		FileRead, codeblock, %template_path%
		codeblock_edited := RegExReplace(codeblock,"12345678",rhash)
		
		;sleep 100
		;send %codeblock%
		
		PASTE_TEXTBLOCK(codeblock_edited)
		
		return
	}
	
	if(UserInput = cppIncludeGuardVar)
	{
		DELETE_WORD("ig",2) ;delete shortcut for include guard.
		
		tm = %A_HOUR%
		tm_12 = 0;
		time_string = 0
		if(tm > 12){
			tm_12:= tm - 12
			time_string = %tm_12%%A_MM%PM
		}else{
			tm_12 := tm
			time_string = %tm_12%%A_MM%AM
		}
		
		;leading zero:
		if(tm_12 < 10){
			time_string = 0%time_string%
		}
		
		;add seconds to end, because now that you are doing this with a script,
		;you are going pretty fast and can do 3 include gaurds in under a minute:
		time_string = %time_string%%A_SEC%SEC
		
		ds = %A_YYYY%_%A_MM%_%A_DD%_%time_string%
		
		;now add whatever is on clipboard to create our include guard line:
		ig_base = %clipboard%_DATE_%ds%
		
		;Send {#}
		;send ifndef %ig_base%
		;send {enter}
		
		;Send {#}
		;send define %ig_base%
		;send {enter}
		;send {enter}
		
		;Send {#}
		;send endif //GUARD END
		;send {enter}
		
		nl = `n ;newline char.
		
		code_block = `#
		code_block = %code_block%ifndef %ig_base%
		code_block = %code_block%%nl%
		
		code_block = %code_block%`#
		code_block = %code_block%define %ig_base%
		code_block = %code_block%%nl%
		code_block = %code_block%%nl%
		
		code_block = %code_block%`#
		code_block = %code_block%endif //GUARD END
		code_block = %code_block%%nl%
		
		;hack so IDE (editors) don't fuck with your pasting:
		clip_copy = %clipboard%
		clipboard = %code_block%
		send ^v
		sleep, 100 ;HACK: sleep so ^v call goes through. APPROX: 0.1 seconds.
		clipboard = %clip_copy%
		
		;sendraw, %code_block%
		
	
		return
	}
	
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
			DIRECTPASTE_OR_WORK_WITH_FILE_POINTED_TO(possibleFileName, SubInput)
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
		Run "C:\Users\jmadison\Desktop\SecretDesk\NotOrganized\welcome.txt"
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

;Removed suspension hotkey because it conflicts with chord script.
;;  ;;http://www.autohotkey.com/board/topic/91839-turning-off-and-on-switch/
;;  ;;CTRL(^) + ALT(!) + S,
;;  ;;used as toggle to turn auto hotkeys on/off.
;;  ^!s::
;;  Suspend, Permit
;;  Suspend, Toggle
;;  Return

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

	is_runnable := 0
	if(  (ext="docx") || (ext="pdf") || (ext="png") || (ext="jpg") )
	{
		is_runnable = 1
	}else
	if( (ext="exe") || (ext="bat") || (ext="ahk") || (ext="sln") )
	{
		is_runnable = 1;
	}
	
	if(is_runnable > 0)
	{
		RUN_FILE(filePath)
		return
	}
	
	is_url := 0                  ;----------12345678
	HTTP := subStr(filePath,1,7) ;look for: HTTP://
	HTTPS:= subStr(filePath,1,8) ;look for: HTTPS://
	StringUpper, HTTP, HTTP
	StringUpper, HTTPS, HTTPS
	if(HTTP == "HTTP://" || HTTPS == "HTTPS://")
	{
		is_url := 1
	}
	
	if(is_url > 0)
	{ ;rather than open file, paste whatever is there.
		PASTE_TEXT(filePath)
		return
	}
	
	;if not URL and not path to OPENABLE FILE (.exe,.png etc), 
	;then just paste the file contents.
	PASTE_FILE(filePath)
	
	
	
	; if(  (ext="docx") || (ext="pdf") || (ext="png") || (ext="exe") || (ext="bat"))
	; {
	; 	Run, %A_ScriptDir%\%filePath%
	; }
	; else
	; {
	; 	PASTE_FILE(filePath)
	; }
	
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}

PASTE_CLIPBOARD_AS_UPPERCASE(){
  ;Store old contents of clipboard:
	clip_board_contents = %Clipboard%
  StringUpper Clipboard, clip_board_contents
  
  Send, ^v
  
  
  ;Restore Clipboard:
	sleep, 100 ;HACK: sleep so ^v call goes through. APPROX: 0.1 seconds.
	Clipboard = %clip_board_contents% 
	
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}

PASTE_CLIPBOARD_AS_LOWERCASE(){
  ;Store old contents of clipboard:
	clip_board_contents = %Clipboard%
  StringLower Clipboard, clip_board_contents
  
  Send, ^v
  
  
  ;Restore Clipboard:
	sleep, 100 ;HACK: sleep so ^v call goes through. APPROX: 0.1 seconds.
	Clipboard = %clip_board_contents% 
	
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}


PASTE_TEXTBLOCK(textToPasteUsingClipboard){
 ;Store old contents of clipboard:
	clip_board_contents = %Clipboard%
	
	;load clipboard and paste
	clipboard = %textToPasteUsingClipboard%
	Send, ^v
	
	;Restore Clipboard:
	sleep, 100 ;HACK: sleep for 999 milliseconds so ^v call goes through. APPROX: 0.1 seconds.
	Clipboard = %clip_board_contents% 
	
	return
}

RUN_FILE(filePath)
{
;see if filePath is NOT relative:
is_relative_path := 1
base := subStr(filePath,1,3)
if(base == "C:\")
{
is_relative_path := 0
}

	if(is_relative_path == 1)
	{
		Run, %A_ScriptDir%\%filePath%
	}else
	if(is_relative_path == 0)
	{
		Run, %filePath%
	}else
	{
		msgBox NOT1NOT0
	}
	
	return
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

PASTE_TEXT(text_to_paste)
{

  ;Store old contents of clipboard:
	clip_board_contents = %Clipboard%
	
  ;Read data into clipboard, and paste it:
	Clipboard := text_to_paste
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
	;bugfix: Forgot return after DELETE_WORD
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

RAND_HASH(output_var){

;output_var := "XX"  ;assign sets to "XX", good.
;output_var = %output_var%literal_whatever ;correct usage.
;output_var := RAND_ALPHA_NUM()            ;correct usage.

output_var := ""
other_var  := "XX"
loop 8{
other_var  := RAND_ALPHA_NUM()
output_var = %output_var%%other_var%
}

return %output_var%

;return "literal_whatever"
	
	
}

RAND_ALPHA_NUM()
{

	Random n, 1, 36
	
	if(n=1){
		return "A"
	}
	if(n=2){
		return "B"
	}
	if(n=3){
		return "C"
	}
	if(n=4){
		return "D"
	}
	if(n=5){
		return "E"
	}
	if(n=6){
		return "F"
	}
	if(n=7){
		return "G"
	}
	if(n=8){
		return "H"
	}
	if(n=9){
		return "I"
	}
	if(n=10){
		return "J"
	}
	if(n=11){
		return "K"
	}
	if(n=12){
		return "L"
	}
	if(n=13){
		return "M"
	}
	if(n=14){
		return "N"
	}
	if(n=15){
		return "O"
	}
	if(n=16){
		return "P"
	}
	if(n=17){
		return "Q"
	}
	if(n=18){
		return "R"
	}
	if(n=19){
		return "S"
	}
	if(n=20){
		return "T"
	}
	if(n=21){
		return "U"
	}
	if(n=22){
		return "V"
	}
	if(n=23){
		return "W"
	}
	if(n=24){
		return "X"
	}
	if(n=25){
		return "Y"
	}
	if(n=26){
		return "Z"
	}
	if(n=27){
		return "0"
	}
	if(n=28){
		return "1"
	}
	if(n=29){
		return "2"
	}
	if(n=30){
		return "3"
	}
	if(n=31){
		return "4"
	}
	if(n=32){
		return "5"
	}
	if(n=33){
		return "6"
	}
	if(n=34){
		return "7"
	}
	if(n=35){
		return "8"
	}
	if(n=36){
		return "9"
	}
		
	
	return "BAD_RAND_NUM"
}





