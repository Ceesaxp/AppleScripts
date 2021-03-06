(*

	Sometimes I come across a good article in {LANG_X} that I'd like to share with
	people who mostly speak {LANG_Y}.  GoogleTranslate makes this possible, but
	copying URL, goign to http://ranslate.google.com is a bit daunting.
	
	This script simplifies the process a bit :)
	
	How to use:
	
	1. Put it under /Users/{your user name}/Library/Applications/Scripts/Safari
	2. Enable Scripts menu (in AppleScript Editor Preferences)
	3. "GoogleTranslate this page" should now be available from Scripts menu.
	
	How to customize:
	
	1. Modify language pairs in customize section, these should be valid ISO 2-letter language codes, supported by GoogleTranslate [see http://www.google.com/language_tools]
	
*)

-- customize
property lang_x : "RU"
property lang_y : "EN"
property buttonXYLabel : lang_x & " to " & lang_y
property buttonYXLabel : lang_y & " to " & lang_x
-- /customize

property googTranslate : "http://translate.google.com/translate?hl=en&"
property fromToLang : ""
property theURL : ""
property fullURL : ""

tell application "Safari"
	set theURL to URL of current tab of window 1
	set encodedURL to urlencode(theURL) of me
end tell

display dialog ¬
	"Choose translation direction:" buttons {"Cancel", buttonYXLabel, buttonXYLabel} default button 3
if the button returned of the result is "" then
	set fromToLang to "&sl=" & lang_y & "&tl=" & lang_x
else
	set fromToLang to "&sl=" & lang_x & "&tl=" & lang_y
end if

set fullURL to googTranslate & fromToLang & "&u=" & encodedURL
set the clipboard to the fullURL as text

display dialog ¬
	"URL to translated page is in the clipboard, you can paste it with ⌘-v.

If you want to open the page in a new browser tab, please click OK, otherwise Cancel." buttons {"Cancel", "OK"} default button 2

if the button returned of the result is "OK" then
	tell application "Safari"
		tell window 1
			make new tab
			set URL of last tab to fullURL
		end tell
	end tell
end if

-- Thanks to http://harvey.nu/applescript_url_encode_routine.html for this subroutine
on urlencode(theText)
	set theTextEnc to ""
	repeat with eachChar in characters of theText
		set useChar to eachChar
		set eachCharNum to ASCII number of eachChar
		if eachCharNum = 32 then
			set useChar to "+"
		else if (eachCharNum ≠ 42) and (eachCharNum ≠ 95) and (eachCharNum < 45 or eachCharNum > 46) and (eachCharNum < 48 or eachCharNum > 57) and (eachCharNum < 65 or eachCharNum > 90) and (eachCharNum < 97 or eachCharNum > 122) then
			set firstDig to round (eachCharNum / 16) rounding down
			set secondDig to eachCharNum mod 16
			if firstDig > 9 then
				set aNum to firstDig + 55
				set firstDig to ASCII character aNum
			end if
			if secondDig > 9 then
				set aNum to secondDig + 55
				set secondDig to ASCII character aNum
			end if
			set numHex to ("%" & (firstDig as string) & (secondDig as string)) as string
			set useChar to numHex
		end if
		set theTextEnc to theTextEnc & useChar as string
	end repeat
	return theTextEnc
end urlencode
