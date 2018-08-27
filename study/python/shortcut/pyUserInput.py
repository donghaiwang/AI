import subprocess

# subprocess.Popen("C:\Windows\System32\\notepad.exe")
# subprocess.Popen("D:\software\Adobe Acrobat X\Acrobat\Acrobat.exe")

# from pymouse import PyMouse
from pykeyboard import PyKeyboard
# m = PyMouse()
# k = PyKeyboard()

# k.press_keys([k.windows_l_key,'d'])  # 执行win+d（显示桌面）
# k.tap_key(k.function_keys[1])         # 按键F1


# import pyautogui
# import time
#
# pyautogui.click(100, 100)
# time.sleep(1)
# pyautogui.hotkey('f9')
# time.sleep(1)
# pyautogui.hotkey('ctrl', 'h')


# import pyautogui
# import time
#
# time.sleep(5)  # 5秒种时间切换到画板程序
#
# pyautogui.moveTo(200, 200, duration=1)  # 鼠标移动到(200,200)的位置
# pyautogui.dragRel(100, 0, duration=1)
# pyautogui.dragRel(0, 100, duration=1)
# pyautogui.dragRel(-100, 0, duration=1)
# pyautogui.dragRel(0, -100, duration=1)



import pyautogui
pyautogui.FAILSAFE = True  # 如果把鼠标光标移动到屏幕左上角，就会产生一个异常，中断PyAutoGUI程序

import win32con
import win32gui
import win32process


def get_hwnds_for_pid(pid):
    def callback(hwnd, hwnds):
        if win32gui.IsWindowVisible(hwnd) and win32gui.IsWindowEnabled(hwnd):
            _, found_pid = win32process.GetWindowThreadProcessId(hwnd)
            if found_pid == pid:
                hwnds.append(hwnd)
            return True

    hwnds = []
    win32gui.EnumWindows(callback, hwnds)
    return hwnds


if __name__ == '__main__':
    import subprocess
    import time

    notepad = subprocess.Popen([r"mspaint.exe"])
    #
    # sleep to give the window time to appear
    #
    time.sleep(2.0)
    print(notepad.pid)
    # 通过获取进程的pid来遍历该进程下的所有窗口，由于notepad.exe只有一个窗口，所以可得到一个窗口的句柄。再调用win32gui的SetForegroundWindow(hwnd)，把该hwnd置首
    for hwnd in get_hwnds_for_pid(notepad.pid):
        print(hwnd, "=>", win32gui.GetWindowText(hwnd))
        win32gui.SetForegroundWindow(hwnd)

        distance = 200
        while distance > 0:
            pyautogui.dragRel(distance, 0, duration=0.5)
            distance -= 5
            pyautogui.dragRel(0, distance, duration=0.5)
            pyautogui.dragRel(-distance, 0, duration=0.5)
            distance -= 5
            pyautogui.dragRel(0, -distance, duration=0.5)

    # pyautogui.typewrite('Hello world!')
