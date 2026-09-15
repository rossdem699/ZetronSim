# Mawson Station Air-Ground Voice Radio Simulator
### Australian Antarctic Division (AAD) Communications Console (Axxon / Zetron Style GUI)

An interactive, real-time voice-driven aviation radio communications training simulator modeled after an authentic Australian Antarctic Division (AAD) station communications console (Zetron / Axxon style GUI).

The simulator trains Antarctic comms operators at **Mawson Station** (`67°36′S, 62°52′E`) to manage VHF/HF air-ground communications with inbound and outbound fixed-wing aircraft (**DHC-6 Twin Otter** and **Basler BT-67**) landing at or departing from:
1. **Rumdoodle Ski Landing Area (SLA)** (Plateau ice strip, Elev 498m AMSL)
2. **Mawson Sea Ice SLA** (Station-adjacent seasonal fast-ice strip)

---

## Key Features

### 1. Authentic Zetron DCS5020 Dispatch Console GUI
- **Matching Mawson Station Hardware Console Layout**:
  - **Top Title Bar**: White banner with official Zetron logo (blue underline wave), `DCS5020 Dispatch Console`, and right-hand dark blue digital banner displaying **Mawson Local Time**, **Zulu UTC Time**, and Date.
  - **Navigation Tabs**: Classic 3D beveled tabs (`BUTTON CONTROL` with active red indicator, `AWS MET TELEMETRY`, `FLIGHT EFPS STRIP`, `AROC COACH`, `SCENARIO SELECT`).
  - **Left Dedicated Radio Focus (TETRA / Selected Air Channel)**:
    - Teal LCD screen with transceiver graphic, live signal strength bars, aircraft callsign (`VHG-FBO`), and RX/TX status.
    - Quick-action keypad buttons (`Call Stat`, `Descent`, `Alert`, `Circuit`, `Down Safe`, `AWS Met`).
    - Two large coral/red bottom pushbuttons (`TERMINATE SARWATCH` and `EMERGENCY ACK`).
  - **Center "Radio Lines" Matrix (9 DCS5020 Tiles)**:
    - **Tone Remote 1**: Primary Air-Ground VHF `126.700 MHz` AM with lightning bolt PTT & frequency buttons (`CH 1` to `CH 4`).
    - **Tone Remote 2**: Air HF Secondary `5484.0 kHz` USB (Davis/Casey relay) with lightning bolt PTT.
    - **Radio 3 (Ops 1)**: Station Ops VHF Ch 1 `156.800 MHz` FM (Light green card).
    - **Radio 4 (Hägg)**: Hägglunds Ch 2 `148.250 MHz` FM (Orange card).
    - **Radio 5 (Guard)**: Air Guard `121.500 MHz` AM (White/red card).
    - **Radio 6 (SAR HF)**: Search & Rescue `3023.0 kHz` USB (Light green card).
    - **Radio 7 (Tac)**: Inter-pilot Tactical `123.450 MHz` AM (White card).
    - **Radio 8 (Plateau)**: Rumdoodle SLA Repeater `149.800 MHz` FM (Light green card).
    - **Radio 9 (Relay)**: Trans-Antarctic HF Net `8833.0 kHz` USB (Teal card).
  - **Center-Bottom Call History Table**:
    - High-contrast DCS5020 color striping: Red (Emergency / Breach), Yellow (Trainee Readback & Score), Blue (Pilot Transmissions), White (System).
    - Navigation actions (`CALL BACK` IRR replay, `CLEAR LOG`, quick TX text bar with `Send TX` and `Copy Model Readback`).
  - **Right DCS5020 Tactile Button Pad**:
    - **Radio Functions**: Sage green pushbuttons (`Patch`, `Simul Select`, `SELCAL`, `Working Group`, `VOX Filter`, `Monitor`).
    - **Giant Coral PTT Pushbutton**: Large tactile `⚡ PTT TRANSMIT` button (Spacebar hotkey).
    - **General Functions**: Orange buttons (`Mute Line`, `Mic Mute`, `Speaker Enable`, `Ring Disable`), iconic **Yellow `IRR` Replay Button**, and **Green `ALARM` Button**.
    - **Dual Vertical 10-Segment LED VU Ladder**: Real-time animated `TX` and `RX` signal level ladders (Green/Amber/Red LEDs).
  - **Bottom Hardware Status Bar**:
    - Beveled system boxes: `On Line`, `Mode: H/Set`, `Status: Transceiver Selected...`, `Console: 02`, `Repeat Pilot Call`, `Restart Sim`, `EXIT`.

### 2. Dual-Mode Voice & Radio Audio Chain (Web Audio API)
- **Speech-to-Text (STT) Push-to-Talk (PTT)**:
  - **Hold Spacebar** or click/hold the on-screen tactile PTT pedal to open microphone.
  - Releasing unkeys the transmitter, plays a squelch tail burst, and evaluates the readback.
  - Prevents spacebar capture when typing into text inputs.
- **Realistic Radio Audio Synthesizer**:
  - **Microswitch Click**: High-frequency relay pop on key-on.
  - **RF Carrier Hiss**: Filtered pink/white noise through a bandpass filter (`400 Hz – 3 kHz`) active while transmitting/receiving.
  - **Squelch Tail Burst**: Authentic 80ms FM unkey burst when transmission ends.
  - **Roger Beep**: 1200 Hz courtesy tone following pilot calls.
- **Pilot Voice Synthesis (TTS)**:
  - Browser `speechSynthesis` with Australian/English voice selection and cockpit cadence.
  - Synchronized with Web Audio carrier hiss and squelch tail sound effects.
- **Dynamic Oscilloscope / Visualizer**:
  - Real-time HTML5 Canvas visualizer rendering radio waves (Green for RX, Red for TX, Amber for IRR Replay).

### 3. Instant Recall Recorder (IRR)
- Dedicated 3-slot circular buffer storing recent incoming and outgoing transmissions.
- Replay buttons (`REPLAY #1`, `REPLAY #2`, `REPLAY #3`) re-synthesize transmissions with full RF radio static and squelch sound effects.

### 4. Station AWS / AMDS Telemetry System
- Dynamic Automated Weather Station data:
  - Surface Wind direction, speed, and gusts (e.g. `140° @ 25 kts`, Gusts `34 kts`)
  - Visibility and drifting snow conditions (`10 km Light blowing drift`)
  - Temperature and Wind Chill (`-16°C`, Chill `-32°C`)
  - QNH Altimeter pressure (`992 hPa`)
  - Active SLA surface conditions (sastrugi depth, tide cracks, runway markers)
- "Cycle AWS" button to jitter/refresh weather telemetry.

### 5. Electronic Flight Progress Strip (EFPS) & SARWATCH
- Electronic flight strip displaying callsign, aircraft type, route, POB, fuel endurance, and calculated ETA.
- **SARWATCH Engine**:
  - Displays active SAR countdown and status.
  - Guarded **"Terminate SARWATCH"** button post-landing.
  - Automatically transitions comms focus to **VHF Ch 2 (Hägglunds)** to dispatch passenger pickup.

### 6. AROC Aeronautical Phraseology Coach & Safety Engine
- **Air-Ground Station / UNICOM Rules**:
  - Comms operators at Mawson Station are NOT Air Traffic Controllers.
  - Operators provide surface advisory and traffic reports.
  - **CRITICAL SAFETY STRIKE ALERT**: Trainees must **never** say *"Cleared to land"* or *"Cleared for takeoff"*. Issuing an illegal ATC clearance triggers an emergency red alert alarm and safety breach warning explaining standard UNICOM protocols.
- **Itemized Protocol Rubric**:
  - Aircraft callsign addressed first (`Foxtrot-Bravo-Oscar` / `Bravo-Tango-Golf`)
  - Ground station identifier (`Mawson Base` / `Mawson Traffic`)
  - Readability check (`read you strength 5`)
  - Accurate QNH pressure readback
  - Current surface wind passed
  - Skiway reported clear (`Rumdoodle clear` / `Sea ice clear`)
  - Touchdown acknowledged and UTC time logged
- **Model Phraseology Card**: Shows exact recommended readback with a single-click **"Use This"** button.
- **Fallback Input & Quick Phrases**: Trainees can type transmissions or use one-click quick phrase chips for instant practice without a microphone.

### 7. Automated Simulation Mode ("Example Play Scenario")
- **One-Click End-to-End Walkthrough**:
  - Click the gold **`▶ EXAMPLE PLAY SCENARIO`** button in the top navigation bar (or select Auto-Play from the *SCENARIO SELECT* modal).
  - The simulator runs an end-to-end guided interactive demonstration:
    - **Dual-Sided Voice Communications**: Pilot calls with realistic Web Audio VHF distortion, carrier hiss, and roger beeps; Ground Station Dispatcher responds with authentic Mawson Base readbacks.
    - **Visual Virtual Operator**: A floating pointer (`👉 OPERATOR ACTION`) glides across the console and physically depresses the console buttons (`SEL`, `RPT`, `⚡ PTT TRANSMIT`, `TERMINATE SARWATCH`, `Hägglunds 148.250 MHz`).
    - **Live HUD Banner**: Displays step progression (e.g. `STEP 1/12`), action titles, and operational narration with interactive controls (`⏸ Pause`, `⏭ Skip`, `⏹ Exit`).
    - **100% CASA AROC Compliance**: Demonstrates standard aerodrome advisory phraseology (surface wind, QNH, skiway status, no conflicting traffic) without unauthorized ATC clearances.
    - **Complete Flight Lifecycle**: Inbound position broadcast, descent acknowledgment, downwind circuit check, touchdown, formal SARWATCH termination, and ground transfer crew dispatch.

---

## 3 Training Scenarios

1. **Scenario A: Rumdoodle Ski Landing Area (DHC-6 Twin Otter)**
   - Aircraft: `VHG-FBO` (*"Foxtrot-Bravo-Oscar"*)
   - Route: Davis Station -> Rumdoodle (Plateau ice strip)
   - 4-Stage progression: Initial inbound (40 nm NE) -> Descent to 3,000 ft -> Joining downwind -> Touchdown & SARWATCH termination.
2. **Scenario B: Mawson Sea Ice SLA (Basler BT-67)**
   - Aircraft: `VKB-BTG` (*"Bravo-Tango-Golf"*)
   - Route: Casey Station -> Mawson Sea Ice (Station-adjacent fast-ice strip)
   - Gusting katabatic winds (`160° @ 32 kts gusts 42 kts`), tide crack surface condition advisory.
3. **Scenario C: Overdue Aircraft / SARWATCH Alert Exercise**
   - Aircraft: `VHG-FBO`
   - Aircraft misses 10-minute descent check-in; SARWATCH alert triggers emergency alarm.
   - Operator initiates blind calls on VHF 126.7 MHz and HF 5484 kHz, alerts station muster crew on Ch 2, until contact is re-established.

---

## How to Run

Because the simulator is completely self-contained in `index.html`, you can run it locally with any browser or local HTTP server:

### Option 1: Python HTTP Server (Recommended for Speech Recognition)
Modern browsers require `http://localhost` or `https://` for full microphone access (`SpeechRecognition`).
```bash
python3 -m http.server 8080
```
Then open in your browser:
```
http://localhost:8080
```

### Option 2: Direct File Open
Open `index.html` directly in Google Chrome, Microsoft Edge, or Firefox. If microphone permissions are restricted by local file security, use the on-screen fallback text input and Quick Phrase buttons.

---

## Keyboard & Hotkey Shortcuts

| Key / Action | Function |
|---|---|
| **Hold Spacebar** | Push-To-Talk (PTT) transmit active |
| **Release Spacebar** | End transmission, play squelch burst, evaluate phraseology |
| **Enter (in input)** | Transmit manual fallback readback |
| **Audio Test Button** | Verify Web Audio relay click, roger tone, and squelch tail |
