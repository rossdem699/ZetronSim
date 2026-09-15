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

## Priority Task for Next Session: Speech Recognition Latency & Missed Words Fix

### Why the issue currently occurs:
1. **Cloud Server Round-Trip**: The standard browser `webkitSpeechRecognition` streams microphone audio to Google's remote speech servers over HTTPS, resulting in a 300-800ms round-trip network latency before returning text.
2. **Audio Start Latency (Clipped First Words)**: The microphone hardware stream only begins initializing *after* PTT is pressed. The first 150-300ms can be clipped, meaning opening words like *"Foxtrot"* can be cut off before the audio buffer fills.
3. **PTT Release Premature Cut-Off**: When PTT is released, `recognition.stop()` is called immediately, which can drop trailing words still in transit to the server.
4. **Strict Regex / Keyword Matching**: Missed leading syllables can cause standard pattern matching to fail.

### Planned Solutions to Implement:
1. **Pre-Warmed Microphone Stream**: Keep a low-latency `MediaStream` warm in the background so audio capture starts at millisecond zero when PTT is pressed (no clipped first words).
2. **Aggressive Interim Results Buffer**: Capture and display words immediately on `onresult` interim events in real-time as you speak, without waiting for the server's delayed finalization event.
3. **PTT Release Grace Period**: Add a 400ms audio drain buffer when releasing PTT to ensure trailing words finish streaming to the speech recognizer before stopping.
4. **Phonetic & Fuzzy Matching**: Implement Levenshtein / phonetic distance matching for aviation terms (e.g. recognizing "xtrot", "box trot", "foxtrot" as `Foxtrot`, and numeric extraction for QNH and wind) so minor audio drops don't penalize readbacks.
5. **Optional Offline / WebAssembly Local Model**: Option to embed a lightweight in-browser offline speech recognizer (e.g. Vosk / Whisper WebAssembly) for zero-latency, 100% offline speech recognition.
