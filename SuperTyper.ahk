#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%

; ===== SETTINGS =====
minDelay := 0          ; Minimum keystroke delay (ms)
maxDelay := 0.00001         ; Maximum keystroke delay
typoChance := 0        ; % chance to simulate a typo (0-100)
pauseChance := 0        ; % chance of short pause
pauseTime := 0        ; Pause duration in ms
betweenWordPauseMin := 0
betweenWordPauseMax := 0
toggleHotkey := "t"     ; Key to start/stop typing (e.g., "t")

; ===== GUI SETUP =====
Gui, Add, Text,, Paste the text below:
Gui, Add, Edit, vInputText w400 h150
Gui, Add, Button, gStartTyping, Start Typing
Gui, Add, Button, gStopTyping, Stop
Gui, Show,, Super Typer

; ===== REGISTER TOGGLE HOTKEY =====
Hotkey, % "$" . toggleHotkey, ToggleTyping, On
return

; ===== VARIABLES =====
typing := false
pos := 1
textToType := ""

; ===== BUTTON HANDLERS =====
StartTyping:
Gui, Submit, NoHide
if (InputText = "") {
    MsgBox, 48, Error, You need to enter some text first!
    return
}
textToType := InputText
typing := true
SetTimer, DoTyping, 10
Return

StopTyping:
typing := false
SetTimer, DoTyping, Off
pos := 1
Return

; ===== MAIN TYPING LOGIC =====
DoTyping:
if (!typing || pos > StrLen(textToType)) {
    typing := false
    SetTimer, DoTyping, Off
    pos := 1
    return
}

char := SubStr(textToType, pos, 1)

; Simulate typo (3% chance)
Random, chance, 1, 100
if (chance <= typoChance && char != " " && char != "`n") {
    Random, wrongChar, 97, 122
    SendRaw % Chr(wrongChar)
    Sleep, 80
    Send, {BS}
    Sleep, 60
}

; Type correct character
SendRaw %char%

; Optional random pause
Random, pChance, 1, 100
if (pChance <= pauseChance) {
    Sleep, pauseTime
}

; Word pause logic
if (char = " ") {
    Random, delay, betweenWordPauseMin, betweenWordPauseMax
} else {
    Random, delay, minDelay, maxDelay
}
Sleep, delay

pos++
Return

; ===== TOGGLE HOTKEY HANDLER =====
ToggleTyping:
if (!typing && textToType != "") {
    typing := true
    SetTimer, DoTyping, 10
} else {
    typing := false
    SetTimer, DoTyping, Off
}
Return

; ===== CLOSE GUI HANDLER =====
GuiClose:
ExitApp
