CoordMode, Mouse, Screen
SetDefaultMouseSpeed, 0
SetMouseDelay, 5

=::
Loop
{
    Loop, 4
    {
        Click, 800, 1500
        Sleep, 70
        Click, 650, 1850
        Sleep, 70
    }

    Click, 2650, 900
    Sleep, 50
}
return

Esc::ExitApp