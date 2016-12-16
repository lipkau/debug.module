; DebugView - DebugView.ahk
; author: Lipkau
; created: 2016 12 6

#include lib\ahklib\CNotification.ahk

DebugView_Init()
{
    DllCall("AllocConsole")
    Settings.Debug := {Enabled: true}
    FileAppend % "###################################################################`n", *
    FileAppend % "#                             a2                                  #`n", *
    FileAppend % "#   Debugger Console for a2: DebugView                            #`n", *
    FileAppend % "#                                started at: " FormatTime(A_Now, "dd-MM-yyyy HH:mm:ss") "  #`n", *
    FileAppend % "###################################################################`n", *
}

DebugView_Write(var)
{
    WriteDebug(var, "Hello`nWorld", "debug", "DebugView")
}
