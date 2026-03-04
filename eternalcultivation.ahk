#Requires AutoHotkey v1.1
#NoEnv
#Include Gdip_All.ahk
SetBatchLines, -1
ListLines, Off
SetControlDelay, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0

if !pToken := Gdip_Startup() {
    MsgBox, GDI+ Error
    ExitApp
}
OnExit, ExitSub

centre_x := 950
centre_y := 625
radius := 325
targetColor := 0x0087FF
avoidColor := 0xFF0000
tolerance := 10

Points := []
Loop 45 {
    theta := 0.13962634 * (46 - A_Index)
    Points[A_Index, "x"] := Round(centre_x + radius * Cos(theta))
    Points[A_Index, "y"] := Round(centre_y + radius * Sin(theta))
}

scanX := centre_x - radius - 10
scanY := centre_y - radius - 10
scanW := (radius * 2) + 20
scanH := (radius * 2) + 20
scanArea := scanX "|" scanY "|" scanW "|" scanH

F1::
Loop 2 { 
    Loop 45 {
        x := Points[A_Index].x
        y := Points[A_Index].y
        MouseMove, %x%, %y%
        Sleep 1 
    }
}

Loop {
    pBitmap := Gdip_BitmapFromScreen(scanArea)
    for index, pt in Points {
        argb := Gdip_GetPixel(pBitmap, pt.x - scanX, pt.y - scanY)
        rgb := argb & 0x00FFFFFF
        
        if (CheckColor(rgb, targetColor, tolerance)) {
            isBlocked := false
            
            Loop, 5 {
                checkIndex := index + (A_Index - 3)
                
                if (checkIndex < 1)
                    checkIndex += 45
                else if (checkIndex > 45)
                    checkIndex -= 45
                
                tX := Points[checkIndex].x
                tY := Points[checkIndex].y
                
                cARGB := Gdip_GetPixel(pBitmap, tX - scanX, tY - scanY)
                cRGB := cARGB & 0x00FFFFFF
                
                if (CheckColor(cRGB, avoidColor, tolerance)) {
                    isBlocked := true
                    break
                }
            }
            
            if (!isBlocked) {
                targetX := pt.x
                targetY := pt.y
                SendInput, {Click %targetX% %targetY%}
                Gdip_DisposeImage(pBitmap)
                continue 2
            }
        }
    }
    Gdip_DisposeImage(pBitmap)
}
return

CheckColor(c1, c2, tol) {
    if (tol <= 0)
        return (c1 == c2)
    r1 := (c1 >> 16) & 0xFF, g1 := (c1 >> 8) & 0xFF, b1 := c1 & 0xFF
    r2 := (c2 >> 16) & 0xFF, g2 := (c2 >> 8) & 0xFF, b2 := c2 & 0xFF
    return (Abs(r1 - r2) <= tol && Abs(g1 - g2) <= tol && Abs(b1 - b2) <= tol)
}

ExitSub:
Gdip_Shutdown(pToken)
ExitApp

Esc::ExitApp