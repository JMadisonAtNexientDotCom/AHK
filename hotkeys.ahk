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
        SNIPPET_SHORTCUT_ARRAY := Object()
				
				;//like SNIPPET_SHORTCUT_ARRAY, 
				;//but has "]" symbols at the end of the words.
				SNIPPET_SHORTCUT_ARRAY_MATCHLIST = test],try]
				
				;//Create associative array that will map shortcut names to functions.
				SNIPPET_SHORTCUT_ASSOC_ARRAY := {"testKey":"testValue"}
				
				ARR_TEST = for],while],main],ps],pv],cs],cdplayerconfig],compactdisc],sgtpeppers],sia_listing],cdplayertest]
 
        ;//BUGFIX:
				;//declare these outside of the loop,
				;//or they will be constantly cleared before they are used.
				theShortCutNameKey := "empty"
				theFuncNameValue := "emptyFunc"
 
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
				
					
	;//MsgBox "Initialized:"%SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
 
return
}
 
SetDefaults(void)

 ~[::
 {
 	Input, UserInput, V T5 L20 C, {enter}{esc}{tab}{backspace}, %SNIPPET_SHORTCUT_ARRAY_MATCHLIST%
 	BRACKET_SHORTCUT_TRY(UserInput)
 }

;used for inserting snippets. Example [for] writes a for-loop snippet.
BRACKET_SHORTCUT_TRY(UserInput)
;~[::
{
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
			MsgBox, "NOT FOUND"
		}
  ;////////////////////////////////////////////////////////////////////
		
	return
}

~>::
{
	Input, UserInput, V T5 L10 C, {enter}.{esc}{tab}{space}, dev,java,hibernate,google,rapid,chrono,clarizen,asana,eclipse,notepad,joblog,gitbash,github,welcome,paint,hotkeys,wamp
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
	if (UserInput = "dev")
	{
			Send, {backspace 5}
			Run, "C:\DEV"
	}else if (UserInput = "java")
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
^#r::
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

	if(ext="docx")
	{
		Run, %A_ScriptDir%\%filePath%
	}
	else
	{
		PASTE_FILE(filePath)
	}
}

;Dont know how to do with function
PASTE_FILE(filePathToRead){
	FileRead, Clipboard, %filePathToRead%
	Send, ^v
}

PRINT_TEMPLATE_CONFIG_FILE_CONTENTS()
{
	theFilePath:="CODE_SNIPPET\FILE_TO_KEY_MAPPING.txt"
	PASTE_FILE(theFilePath) ;//RAWER.
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