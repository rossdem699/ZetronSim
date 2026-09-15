# Zetron DCS5020 Dispatch Simulator - Project Status & Roadmap

## Current State (Saved & Committed)
- **Git Branch**: `main` (clean commit `113004f` - all project code safely stored).
- **Primary Application**: `index.html` (self-contained, modern web console).
- **Server Ports**:
  - `http://localhost:3000/` (active)
  - `http://localhost:8080/` (backup)
- **Start Command**: `./run.sh` or `python3 -m http.server 3000`

---

## What Has Been Completed
1. **Zetron DCS5020 UI Alignment**:
   - 12 realistic hardware radio tiles (Tone Remote 1 & 2, Station Ops, Hägglunds, Repeaters, Guard 121.5, Tactical, Casey/Davis).
   - Repeater mode selectors (`RPT` / `DIR`), channel states (`● ON` / `STBY`), and active channel glow.
   - Left LCD panel, 3x2 quick keys, and dual VU audio level meters.
2. **Dynamic Live Report Script & Telemetry Card**:
   - Replaced modal tabs with direct top controls.
   - Populates the left space with real-time checklist data (Aircraft callsign, ETA, Skiway status, Wind, Vis/Temp, QNH).
   - Word-for-word AROC speech script box with 1-click copy and PTT Read transmission.
3. **RF Audio & Cockpit Sound Synthesizer**:
   - Web Audio API dual-turboprop propeller drone with blade passage tremolo and slipstream air noise.
   - Authentic mic clicks, squelch tails, and roger beeps.
4. **Automated Scenario Player ("Example Play Scenario")**:
   - Visual flying pointer simulating button presses, channel selection, and PTT hold.
   - Collapsible HUD with pause/resume and step indicators.
5. **Mr. T (The A-Team) Debrief Feature**:
   - Pilot announces waiting for pick up upon touchdown in all scenarios.
   - Synthesizes 1980s A-Team brass fanfare chord progression with 80s bass drum thump.
   - Deep baritone Mr. T voice-over: *"Great job fool, you landed the plane now go get a drink"*.
   - Gold debrief modal with replay button and instant test button in nav bar.

---

---

## Completed: Speech Recognition Latency & Missed Words Fix (Steps 1 to 4)

The speech recognition latency and clipped word issues have been resolved in `index.html`:

1. **Pre-Warmed Background Microphone Stream (`getUserMedia`)**:
   - Hardware audio stream initialized on boot / first user interaction and kept warm in the background.
   - Eliminates OS/driver audio pipeline spin-up latency (150–300ms) so opening syllables like *"Foxtrot"* or *"Mawson"* are captured instantly at millisecond zero.
2. **PTT Release Grace Period (Audio Drain Buffer)**:
   - Added a 450ms trailing audio drain grace period when PTT or Spacebar is released.
   - Visual button feedback switches to `⏳ DRAINING BUFFER...` and status updates to `⏳ PROCESSING FINAL AUDIO...`.
   - Trailing syllables, altimeter numbers, and QNH digits in transit are captured and transcribed before `recognition.stop()` is called.
   - Squelch tail and tile TX release occur automatically when the drain completes.
   - Re-keying PTT during drain seamlessly resumes without interruption.
3. **Aggressive Real-Time Interim Transcript Capture**:
   - Real-time continuous streaming of interim hypotheses into the TX input and status bar.
   - Automatic fallback evaluates accumulated interim transcripts immediately if cloud speech servers stall or delay `isFinal` delivery.
4. **Phonetic & Aviation Keyword Fuzzy Matching + Spoken Number Normalizer**:
   - Built-in Levenshtein distance algorithm and fuzzy word/bigram matcher (`hasFuzzyWord`).
   - Aviation callsign and phonetic aliases (`foxtrot`, `box trot`, `oxtrot`, `fxtrot`, `bravo`, `ravo`, `oscar`, `scar`, `tango`, `golf`, `basler`, `twin otter`).
   - Mawson station aliases (`mawson`, `molson`, `morrison`, `maws`, `maulson`, `base`, `traffic`, `ground`, `station`).
   - Spoken number converter (`normalizeSpokenNumbers`) converting phonetic digits (*"nine nine two"* &rarr; `992`, *"one four zero"* &rarr; `140`, *"three thousand"* &rarr; `3000 feet`).
   - Flexible numeric extraction for QNH (any barometric 3-4 digit reading 950–1050) and wind direction/speed.

---

## Roadmap / Next Enhancements
- **Optional Offline / WebAssembly Local Model**: Option to embed a lightweight in-browser offline speech recognizer (e.g., Vosk / Whisper WebAssembly) for 100% air-gapped / zero-network environments.

