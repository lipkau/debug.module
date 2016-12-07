; DebugView - DebugView.ahk
; author: Lipkau
; created: 2016 12 6

#include lib\ahklib\CNotification.ahk

DebugView_Init()
{
    DllCall("AllocConsole")
    Settings.Debug := {Enabled: true}
    WriteDebug("###################################################################", "", "")
    WriteDebug("#                             a2                                  #", "", "")
    WriteDebug("#   Debugger Console for a2: DebugView                            #", "", "")
    WriteDebug("#                                started at: " FormatTime(A_Now, "dd-MM-yyyy HH:mm:ss") "  #", "", "")
    WriteDebug("###################################################################", "", "")
}

DebugView_Write(var)
{
    WriteDebug(var, "Hello`nWorld", "debug", "DebugView")
}
