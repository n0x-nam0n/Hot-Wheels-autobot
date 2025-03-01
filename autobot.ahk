#NoTrayIcon
#Persistent
#KeyHistory 0
SetBatchLines, -1
Process, Priority, , Low

; === Stealthier Config ===
lowballOffers := ["$2 final offer.", "I got $3, take it?", "Low funds, $1?"]
autoReplies := ["Still firm on $2.", "Can’t do more than $3."]

Loop {
    if WinActive("Facebook Marketplace") {
        SendNegotiation()
        Sleep, % Rand(15000, 30000) ; Randomized delay between actions
    }
    else {
        Sleep, 5000 ; Check less frequently when not focused
    }
}

SendNegotiation() {
    ; Stealth-typed message
    offer := lowballOffers[Rand(1, lowballOffers.MaxIndex())]
    Loop, Parse, offer
    {
        Random, delay, 75, 225
        Sleep, delay
        Send, % A_LoopField
    }
    Send, {Enter}
}

Rand(min, max) {
    Random, r, %min%, %max%
    return r
}
