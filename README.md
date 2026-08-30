# 🗾 ArekBox JP

Alternatywna edycja **ArekBox** — zestaw narzędzi terminalowych w duchu japońskiego minimalizmu.

> **Dlaczego "JP"?** Kiedyś pomyliłem darmowe, chińskie wielkie LLM (z.ai) z Japonią — nie sprawdziłem wcześniej.
> Od jakiegoś czasu chciałem zwiedzić Japonię, a Japończycy (tak jak ja) kochają **minimalizm**.
> I tak powstał pomysł na japońską wersję ArekBoxa: staram się trzymać zasadę *"mniej, ale lepiej"*.

## 📦 Co zawiera

Zestaw samodzielnych skryptów bash + trochę Pythona, podzielonych na obszary:

| Obszar | Skrypty |
|--------|---------|
| **Instalatory** | `1arekbox_installer.sh`, `2arekbox_installer.sh` — warianty instalacji narzędzi |
| **Media** | `arekbox_media_fixer.sh`, `arekbox_media_manager.sh`, `arekbox_sound_optimizer.sh`, `arekbox_media_cleaner.sh` |
| **TTS / głos** | `arekbox_tts_evolution.sh`, `most_mowy.sh`, `most_mowy_offline.sh`, skrypty `tts.sh`/`whisper.sh` |
| **Japonia / vibe** | `arekbox_jp_pl_mod.sh`, `arekbox_vibe_keeper.sh`, `arekbox_dance_helper.sh`, `japońskie_promty.sh`, `arek_translator.sh` |
| **System / build** | `arekbox_linux_builder.sh` (budowa własnej dystrybucji Linux: debootstrap → chroot → ISO live) |
| **Gry / archiwizacja** | `arekbox_game_archivist.sh`, `arekbox_doc_*`, `arekbox_chat_archiver.sh` |
| **Prywatność** | `arekbox_privacy_guardian.sh`, `arekbox_vpn.sh`, `arekbox_restore_normality.sh` |
| **AI / Ollama** | `arekbox_dual_ollama.sh`, `arekbox_multi_query.sh`, `arekbox_image_generator.sh` |
| **Moduły** | `modules/` — 13 modułów (security, backup, multimedia, optimize, grader itd.) |
| **WebUI** | `webui/gradio_ui.py` — interfejs Gradio do czatu Ollama |

## 🚀 Uruchomienie

```bash
chmod +x *.sh
./1arekbox_installer.sh      # główny instalator
./arekbox.sh                 # globalne menu narzędzi
```

Większość skryptów to menu z wyborem — po prostu uruchom i wybierz opcję.

## ⚠️ Status projektu

- To są **notatki z podróży po programowaniu** — nie wszystko jest skończone/idealne.
- Część skryptów to szybkie prototypy i eksperymenty (w tym AI-assisted, z halucynacjami które naprawiałem).
- Wymagania: Linux (skrypty bash), niektóre moduły potrzebują `ollama`, `ffmpeg`, `espeak`, `python3`.

## 📜 Filozofia

Zamiast "czystego kodu" — zapisana mądrość i doświadczenia z testów, błędów i odkryć.
W komentarzach znajdziesz lekcje, które wyniosłem z 400+ godzin pracy.

## 🕰️ O datach (uczciwie)

Moje prawdziwe "rozbieranie systemów" zaczęło się na **IRC-u w ~1998 r.** — miksowałem skrypty mIRC
z różnych źródeł w jeden własny. Daty podawane w kodzie potrafią się różnić, bo część kodu
generowało AI z **przesuniętym zegarem** (rok wstecz) — potraktuj je z przymrużeniem oka. 😉

---

Created by **Arek** z pomocą AI. Japońska edycja ArekBox — dla miłośników minimalizmu. 🌸
