WinWait, X-Lite Setup
WinActivate, X-Lite Setup
WinWaitActive, X-Lite Setup
if ErrorLevel
{
    MsgBox, WinWait timed out.
    return
}
SetKeyDelay, 0, 50

SendInput {Tab}
SendInput {Space}

SendInput {Tab}

SendInput {Space}

SendInput {Tab}

SendInput {Tab}

SendInput {Space}

WinWaitClose