#MaxThreadsPerHotkey 2
F1::
Toggle := !Toggle

Count := 0
Walktime := 0
Regen_Time := 17000 + 150
LastPickupTime := 0

Loop
{
    if (!Toggle)
    {
        Send, {W up}{S up}
        break
    }

    PixelSearch, Px, Py, 811, 530, 1500, 1180, 0x56569B, 1, Fast RGB
    Result1 := ErrorLevel
    Result2 := ErrorLevel

    if (Result1 = 0 Or Result2 = 0)
    {
        Count++
        Send, e
        LastPickupTime := A_TickCount

        while (Result1 = 0 Or Result2 = 0)
        {
            PixelSearch, Px, Py, 811, 530, 1500, 1180, 0x56569B, 1, Fast RGB
            Result1 := ErrorLevel
            Result2 := ErrorLevel
            Sleep, 10
        }

        if (Count < 3)
        {
            Sleep, 900
            Send, {W down}
            Start_time := A_TickCount

            Sleep, 200
            Loop
            {
                PixelSearch, Px, Py, 811, 530, 1500, 1180, 0x56569B, 1, Fast RGB
                Result1 := ErrorLevel
                Result2 := ErrorLevel
                if (Result1 = 0 Or Result2 = 0)
                    break
                Sleep, 10
            }

            Send, {W up}
            Walktime := Walktime + (A_TickCount - Start_time)
        }
        else
        {
            Send, {o Down}
            Send, m
            Sleep, 250
            Send, {o Up}

            Click, 720, 500
            Click, 720, 500
            Click, 720, 500
            Click, 720, 500
            Sleep, 150
            Click, 720, 890
            Sleep, 150
            Send, m
            Sleep, 20

            Send, {i Down}
            Sleep, 350
            Send, {i up}

            Send, {S down}
            Sleep, Walktime
            Send, {S up}

            Elapsed := A_TickCount - LastPickupTime
            RemainingTime := Regen_Time - Elapsed

            if (RemainingTime > 0)
                Sleep, RemainingTime

            Walktime := 0
            Count := 0
            Sleep, 200
        }
    }

    Sleep, 50
}
return

Esc::ExitApp