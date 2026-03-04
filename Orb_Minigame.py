import mss
import numpy as np
import time
import math
import keyboard
import pydirectinput
import threading 


pydirectinput.PAUSE = 0
centre_x = 950
centre_y = 625
radius = 325
n = 180
stop_event = threading.Event()

Points = []
xs, ys = [], []

for i in range(n):
    theta = (n - i) * (2 * math.pi / n)
    x = round(centre_x + radius * math.cos(theta))
    y = round(centre_y + radius * math.sin(theta))
    Points.append((x, y))
    xs.append(x)
    ys.append(y)
    
    

left = min(xs)
top = min(ys)
width = max(xs) - left + 1
height = max(ys) - top + 1

def color_match(rgb, target, tol):
    return all(abs(int(c) - t) <= tol for c, t in zip(rgb, target))


def stop_script():
    print("Stopping...")
    stop_event.set()
    
def scan_loop():
    stop_event.clear()
    
    for x,y in Points: #This loop is purely made so that the user can align themselves
        if stop_event.is_set(): return 
        pydirectinput.moveTo(x,y)
        time.sleep(0.001)
        
        
        
    
    with mss.mss() as sct:
        
        while not stop_event.is_set():
            red = set()
            img = sct.grab({"top": top, "left": left, "width": width, "height": height})
            arr = np.array(img)
            for i, (x, y) in enumerate(Points):
                px = x - left
                py = y - top
                pixel_rgb = arr[py, px][:3]

                if color_match(pixel_rgb, (0,0,255), 10):
                    red.add(i)
            for i, (x, y) in enumerate(Points):
                px = x - left
                py = y - top
                pixel_rgb = arr[py, px][:3]
                if color_match(pixel_rgb, (255, 136, 0), 20):
                    for offset in range(-3, 4):  
                        check_index = (i + offset) % len(Points)
                        if check_index in red:
                            break
                    else:
                        pydirectinput.click(x,y)
                        time.sleep(0.00001)
                        break
                    
                
                
                    
                    

            
keyboard.add_hotkey("f1", lambda: threading.Thread(target=scan_loop, daemon=True).start())
keyboard.add_hotkey("esc", stop_script)
print("ready")
keyboard.wait()