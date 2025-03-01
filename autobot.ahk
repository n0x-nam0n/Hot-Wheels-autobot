#NoTrayIcon
#Persistent
#KeyHistory 0
#WinActivateForce
SetBatchLines, -1
Process, Priority, , Low

; === Advanced Anti-Detection Config ===
headlessChrome := "C:\Program Files\Google\Chrome\Application\chrome.exe"
profileDir := "C:\Temp\ChromeProfile"
vpnAPI := "https://api.iproyal.com/ips?api_key=YOUR_KEY"
ocrEngine := "C:\Tesseract-OCR\tesseract.exe"

; === Stealth Components ===
humanTypeSpeed(min, max) {
    Random, speed, %min%, %max%
    Return speed
}

rotateIP() {
    RunWait, curl -X POST %vpnAPI%,,Hide
    Sleep, 5000
}

chromeAttach() {
    global chrome
    chrome := ComObjCreate("Chrome.CHrome")
    chrome.GetPage().EvaluateJavaScript("document.querySelector('meta[name=viewport]').content='width=1920, initial-scale=1'")
}

messageGen() {
    phrases := ["Would you consider $2?", "I can offer $1.50 today", "Final offer $2.25?"]
    Random, r, 1, 3
    Return StrReplace(phrases[r], "$", Rand(1,3))
}

Rand(min, max) {
    Random, r, %min%, %max%
    Return r
}

; === Main Execution ===
Loop {
    rotateIP()
    Run, %headlessChrome% --remote-debugging-port=9222 --user-data-dir=%profileDir% --headless "https://facebook.com/marketplace",,Hide
    Sleep, 8000
    chromeAttach()
    
    ; OCR-based message detection
    Loop {
        ; Capture chat area
        chrome.GetPage().CaptureScreenshot("C:\temp\chat.png")
        RunWait, %ocrEngine% C:\temp\chat.png C:\temp\output -l eng,,Hide
        FileRead, chatText, C:\temp\output.txt
        
        If (InStr(chatText, "New message")) {
            ; Human-like response
            response := messageGen()
            Loop, Parse, response {
                Random, delay, 75, 225
                Sleep, %delay%
                chrome.GetPage().EvaluateJavaScript("document.querySelector('[aria-label=Message]').value += '" A_LoopField "'")
            }
            chrome.GetPage().EvaluateJavaScript("document.querySelector('[aria-label=Send]').click()")
            Sleep, % humanTypeSpeed(3000, 12000)
        }
        
        ; Random browser actions
        If (Mod(A_Index, 5) = 0) {
            chrome.GetPage().EvaluateJavaScript("window.scrollBy(0, " Rand(200,800) ")")
            Sleep, % humanTypeSpeed(1500, 4000)
        }
        
        ; Rotate session every 10 messages
        If (messageCount >= 10) {
            chrome.Quit()
            Process, Close, chrome.exe
            Break
        }
    }
    
    ; Random break pattern
    Sleep, % Rand(60000, 300000)
}
