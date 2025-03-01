#NoTrayIcon  
#Persistent  
SetTitleMatchMode, RegEx  

; === SCALPER-B-GONE PROTOCOL ===  
scalperPatterns := ["rare", "super treasure hunt", "hard to find", "no lowball"]  

Loop {  
    WinActivate, Facebook Marketplace  
    Send, ^f  
    Sleep, 500  
    Send, % scalperPatterns[Random(1,4)]  
    Sleep, 2000  
    Send, {Enter}  
    Sleep, 3000  
    Send, {Tab 5}  
    Send, {Enter}  
    Sleep, 1000  
    Send, "Hey bro, I'll take it for $2 cash right now. Meet at [RANDOM COORDINATES]?"  
    Send, {Enter}  
    Sleep, % Random(60000, 180000) ; Let them marinate in false hope  
}  
