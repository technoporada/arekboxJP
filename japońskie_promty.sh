#!/bin/bash
# japońskie_promty.sh - Automatyczne zwroty dla ArekBox

# Funkcja: Powitanie po japońsku (godzina ma znaczenie!)
japan_greeting() {
    hour=$(date +%H)
    if (( hour >= 5 && hour < 12 )); then
        echo "おはようございます！ (Ohayō gozaimasu!)"  # Dzień dobry
    elif (( hour >= 12 && hour < 18 )); then
        echo "こんにちは！ (Konnichiwa!)"                # Dzień dobry (po południu)
    else
        echo "こんばんは！ (Konbanwa!)"                 # Dobry wieczór
    fi
}

# Funkcja: Podziękowanie za wykonanie komendy
japan_thanks() {
    echo "お疲れ様です！タスクが完了しました。(Otsukare-sama desu! Tasuku ga kanryō shimashita.)"
    # Tłumaczenie: "Dziękuję za wysiłek! Zadanie ukończone."
}

# Funkcja: Przeprosiny za błąd
japan_apology() {
    echo "申し訳ありません！もう一度試してください。(Mōshiwake arimasen! Mō ichido kokushite kudasai.)"
    # Tłumaczenie: "Przepraszam! Spróbuj ponownie."
}
