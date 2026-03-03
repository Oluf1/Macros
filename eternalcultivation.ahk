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
Loop 90 {
    theta := 0.13962634 * (91 - A_Index)
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
    Loop 90 {
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
                    checkIndex += 90
                else if (checkIndex > 90)
                    checkIndex -= 90
                
                targetPt := Points[checkIndex]
                checkARGB := Gdip_GetPixel(pBitmap, targetPt.x - scanX, targetPt.y - scanY)
                
                if ((checkARGB & 0x00FFFFFF) == avoidColor) {
                    isBlocked := true
                    break
                }
            }
            
            if (!isBlocked) {
                Click, % pt.x "," pt.y
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