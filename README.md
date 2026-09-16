# Mawson Station Air-Ground Voice Radio Simulator
### Zetron DCS5020 Dispatch Console Training Simulator

An interactive, voice-driven aviation radio communications training simulator modeled after an authentic polar station communications console (**Zetron DCS5020 / Axxon style GUI**).

The simulator trains radio operators at **Mawson Station, Antarctica** (`67°36′S, 62°52′E`) to manage VHF/HF/Satellite air-ground communications with inbound and outbound polar transport aircraft (**DHC-6 Twin Otter** and **Basler BT-67**) operating from:
1. **Rumdoodle Ski Landing Area (SLA)** (Plateau blue ice strip, Elev 498m AMSL)
2. **Mawson Sea Ice SLA** (Station-adjacent seasonal fast-ice runway)

---

## What It Does

This simulator replicates the high-stakes communications environment of an Antarctic station radio room during flight operations:

1. **Hardware-Accurate Dispatch GUI**: Replicates a 12-channel Zetron DCS5020 console with 3D tactile buttons, dual 10-segment LED VU audio meters, channel state indicators (`● ON` / `STBY`), repeater selectors (`RPT` / `DIR`), and real-time Mawson Local and UTC clocks.
2. **Interactive Voice & Push-to-Talk (PTT)**: Trainees use actual spoken voice over a microphone by holding the Spacebar or clicking the on-screen PTT switch. The simulator evaluates aeronautical phraseology, callsign accuracy, and polar weather reporting in real-time.
3. **Cockpit & Radio Acoustic Synthesis**: Powered entirely by the browser's Web Audio API with zero audio files to download:
   - Authentic twin-turboprop engine propeller drone with blade-passage tremolo and slipstream air noise.
   - Microswitch relay pops, filtered RF carrier hiss (`400 Hz – 3 kHz`), 80ms squelch tail unkey bursts, and 1200 Hz courtesy roger beeps.
   - Terrain-induced VHF squelch flutter and dropout effects.
   - Dual-tone multi-frequency (DTMF) satellite phone dialing chirps.
4. **AROC Aeronautical Phraseology Coach**: Evaluates transmissions against CASA Aeronautical Radio Operator Certificate (AROC) standards for non-controlled aerodrome advisory services (UNICOM).
5. **Safety Alert System**: Antarctic station operators are **not** Air Traffic Controllers. Issuing unauthorized control instructions (such as *"cleared to land"* or *"cleared for takeoff"*) triggers an immediate safety breach alarm.
6. **Electronic Flight Progress Strip & SARWATCH**: Live aircraft telemetry tracking (callsign, souls on board, fuel endurance, ETA, and SARWATCH search-and-rescue countdown timers).
7. **Automated "Example Play" Mode**: A fully automated walkthrough where an animated virtual operator pointer depresses console buttons and conducts complete radio dialogues for training or demonstration.

---

## Quick Start: How to Run & Install

The simulator is 100% self-contained in a single file (`index.html`). All graphics, audio synthesis, speech recognition, and mission engines are built in.

### Method 1: Web App via GitHub Pages (Zero Install)
You can run the simulator directly in your browser on any computer:
1. Open Google Chrome or Microsoft Edge and navigate to:
   ```
   https://rossdem699.github.io/ZetronSim/
   ```
2. Allow microphone access when prompted.
3. *(Optional)* Click the **Install ZetronSim** icon in the browser address bar to install it as a standalone, windowed desktop app.

---

### Method 2: Windows (1-Click, Zero Installs Needed)
If you downloaded or cloned the repository onto a Windows laptop:
1. Double-click **`start-windows.bat`**.
2. The script automatically checks for Python or launches a local server using built-in Windows PowerShell.
3. It opens Microsoft Edge or Google Chrome in dedicated application mode with microphone permissions enabled.

---

### Method 3: macOS (1-Click)
1. Double-click **`start-mac.command`**.
2. It starts a local server on port 8080 and opens your default browser.

---

### Method 4: Linux
Run from the terminal:
```bash
./run.sh
```
Or start a manual local server:
```bash
python3 -m http.server 8080
```
Then visit `http://localhost:8080` in Chrome or Edge.

---

### Method 5: Portable USB Bundle (< 1 MB)
The repository includes a portable archive **`ZetronSim-Portable.zip`** (~52 KB):
1. Copy `ZetronSim-Portable.zip` to a USB thumb drive.
2. Extract the zip on any laptop.
3. Double-click `start-windows.bat` (Windows), `start-mac.command` (Mac), or `run.sh` (Linux).

---

## Console Layout & Features

```
+---------------------------------------------------------------------------------------------------+
|  ZETRON DCS5020 DISPATCH CONSOLE            [MAWSON LOCAL: 14:22]  [ZULU UTC: 09:22]  [2026-09-16] |
+---------------------------------------------------------------------------------------------------+
|  [BUTTON CONTROL]   [AWS MET TELEMETRY]   [FLIGHT EFPS STRIP]   [AROC COACH]   [SCENARIO SELECT]  |
+-----------------------------------+-------------------------------------------+-------------------+
|  TRANSCEIVER LCD & TELEMETRY      |  12 RADIO CHANNELS MATRIX                 |  TACTILE CONTROLS |
|  - Callsign: VHG-FBO              |  [Tile 1] Air VHF 126.700 MHz (Primary)   |  - Dual VU Meters |
|  - Surface Wind: 140° @ 25 kts    |  [Tile 2] Air HF Net 5484.0 kHz (Enroute) |  - [⚡ PTT] Pedal |
|  - QNH Altimeter: 992 hPa         |  [Tile 3] Iridium Sat Phone (SAT 8816)    |  - [IRR] Replay   |
|  - Skiway: Rumdoodle (Clear)      |  [Tile 4] Hägglunds 148.250 MHz (Ground)  |  - Audio Mute     |
|                                   |  [Tile 5] Plateau Repeater 149.800 MHz    |  - Speaker Enable |
|  LIVE WORD-FOR-WORD SCRIPT        |  [Tile 6] Casey Relay HF 8833.0 kHz       |                   |
|  - Recommended readback text      |  [Tile 7] Field Party 1 156.450 MHz       |                   |
|  - 1-Click Copy & Quick Read      |  [Tile 8] Air Guard / UHF 121.5 / 243.0   |                   |
|                                   |  [Tile 9] Davis Base HF 5100.0 kHz        |                   |
|  EMERGENCY BUTTONS                |  [Tile 10] Inter-Pilot Air Tac 123.450    |                   |
|  - [TERMINATE SARWATCH]           |  [Tile 11] Station Ops 156.800 MHz (Base) |                   |
|  - [EMERGENCY ACK]                |  [Tile 12] Sea Ice SLA Rptr 150.100 MHz   |                   |
+-----------------------------------+-------------------------------------------+-------------------+
|  CALL HISTORY & TRANSMISSION LOG                                                                  |
|  - Color-coded: Blue (Pilot), Yellow (Trainee Readback), Red (Breach/Alert), White (System)       |
|  - Text Fallback Input Box + [Send TX] + [Copy Model Readback]                                    |
+---------------------------------------------------------------------------------------------------+
```

### Key Controls
* **Primary Air VHF (`Tile 1`)**: Tone Remote 1 on `126.700 MHz AM`. Used for standard circuit, arrival, and departure broadcasts.
* **Air HF Net (`Tile 2`)**: Secondary long-range enroute channel on `5484.0 kHz USB`.
* **Iridium Satellite Phone (`Tile 3`)**: Satellite telephone link (`SAT 8816.767`). Features an active **`DIAL`** button that plays dual-tone DTMF chirps and directly connects to the cockpit satellite terminal.
* **Hägglunds Tracked Vehicle (`Tile 4`)**: Ground operations channel on `148.250 MHz FM`. Used after landing to coordinate passenger pickup.
* **Air Guard (`Tile 8`)**: International emergency distress frequency on `121.500 / 243.000 MHz`.
* **Station Ops (`Tile 11`)**: Mawson base station operations on `156.800 MHz FM`.

---

## How to Use: Operating Guide

### 1. Transmitting to the Aircraft
There are three ways to communicate:
1. **Voice Push-to-Talk (Microphone)**:
   - Hold down the **Spacebar** on your keyboard (or click and hold the coral **`⚡ PTT TRANSMIT`** button).
   - Speak your radio transmission clearly into your headset/microphone.
   - Release the Spacebar. A 450ms trailing audio buffer captures your final words, plays a squelch tail burst, and evaluates your transmission.
2. **One-Click Quick Phrases**:
   - Four scenario-adaptive buttons (**`Phrase 1`**, **`Phrase 2`**, **`Phrase 3`**, **`Phrase 4`**) appear below the history log. Click any button to transmit the exact phraseology instantly.
3. **Text Fallback**:
   - Type your transmission into the text box at the bottom and press **Enter** (or click **`Send TX`**).

### 2. Live AROC Script Box
Look at the **AROC Live Script** card on the left panel. It displays the word-for-word correct readback based on real-time station weather and aircraft position. You can click **`📋 Copy Script`** or **`🎙️ Read For Me`** at any time.

### 3. Reviewing Transmissions (Instant Recall Recorder - IRR)
Click the yellow **`IRR`** button on the right panel or **`REPLAY #1` / `REPLAY #2` / `REPLAY #3`** in the IRR drawer to re-listen to recent transmissions with authentic RF radio static.

---

## The 5 Training Scenarios

Select any scenario using the **`Scenario:`** dropdown in the top bar or via the **`SCENARIO SELECT`** tab:

### Scenario A: Rumdoodle Ski Landing Area (DHC-6 Twin Otter Arrival)
* **Aircraft**: `VHG-FBO` (*"Foxtrot-Bravo-Oscar"*) from Davis Station.
* **Flight Stages**:
  1. *40 nm Inbound Broadcast*: Operator passes Mawson surface wind, QNH, and confirms Rumdoodle skiway clear.
  2. *Descent to 3,000 ft*: Operator acknowledges descent and reiterates altimeter setting.
  3. *Joining Downwind / Circuit*: Pilot reports joining the visual circuit; operator confirms runway clear.
  4. *Touchdown & SARWATCH*: Pilot reports down safe; operator terminates SARWATCH and switches to Tile 4 (Hägglunds) to dispatch passenger pickup.
* **Post-Flight Celebration**: Authentic 1980s A-Team brass fanfare and Mr. T voice debrief (*"Great job fool, you landed the plane now go get a drink"*).

### Scenario B: Mawson Sea Ice SLA (Basler BT-67 Arrival)
* **Aircraft**: `VKB-BTG` (*"Bravo-Tango-Golf"*) from Casey Station.
* **Flight Stages**:
  - High-wind katabatic environment (`160° @ 32 kts gusts 42 kts`).
  - Operator advises of sea-ice surface conditions and tide crack hazards.
  - Pilot lands on the seasonal fast-ice runway adjacent to the station.

### Scenario C: Overdue Aircraft / SARWATCH Alert Exercise
* **Aircraft**: `VHG-FBO`.
* **Exercise**:
  - Aircraft fails to report by its nominated SARWATCH time.
  - Emergency breach alarm sounds with flashing red indicators.
  - Operator must execute emergency blind calls across primary VHF 126.700 MHz and backup Guard 121.500 MHz, alerting the station muster team until contact is restored.

### Scenario D: Rumdoodle Takeoff (Normal Departure)
* **Aircraft**: `VHG-FBO` bound for Davis Station.
* **Flight Stages**:
  1. *Line Up Call*: Operator provides departure advisory (wind, QNH, skiway clear).
  2. *Airborne Call*: Pilot nominates a 5-minute SARWATCH time; operator acknowledges and confirms.
  3. *Top of Climb (9,000 ft)*: Pilot reports operations normal; operator gives Davis handover advisory.
  4. *Enroute Handover*: SARWATCH transferred to Davis Station; local monitoring closed.

### Scenario E: Takeoff, Comms Dropout & Failed First SARSEARCH (Mountain Shadow)
* **Aircraft**: `VHG-FBO` departing Rumdoodle into the Prince Charles Mountains.
* **Flight Stages**:
  1. *Line Up & Airborne*: Normal departure call.
  2. *RF Dropout & Repeat*: Squelch flutter causes transmission breakup; pilot asks operator to *"say again last message"*; operator re-transmits.
  3. *Accelerated SARWATCH Window*: A live 5-minute countdown clock runs in accelerated fast-forward (~9 seconds) with rhythmic clock ticking audio.
  4. *VHF Mountain Shadow Failure*: Countdown expires; emergency alert triggers. Transmitting on Tile 1 (primary VHF 126.700) results in radio silence due to terrain shadow.
  5. *Alternate Comms Channel Recovery*:
     - Operator switches to **Tile 2 (`AIR HF 5484.0 kHz`)** or **Tile 3 (`IRIDIUM SAT 8816`)**.
     - Clicking **`DIAL`** on Tile 3 dials the cockpit satellite terminal with DTMF chirps.
     - Pilot answers on the alternate channel, reports operations normal descending through the terrain shadow.
     - Operator cancels the emergency and terminates SARWATCH.

---

## CASA AROC Regulatory Safety Rules

In polar non-controlled airspace:
* Station radio operators provide **Aerodrome Advisory Services (UNICOM)**.
* **YOU ARE NOT AN AIR TRAFFIC CONTROLLER.**
* **Never say**: *"Cleared to land"*, *"Cleared for takeoff"*, or *"Cleared to descend"*.
* **Always say**: *"Skiway reported clear"*, *"No reported traffic"*, or report surface weather and QNH.
* *Attempting to issue an ATC clearance will trigger a red Safety Strike alarm and log an infraction.*

---

## Keyboard Shortcuts

| Key / Action | Function |
|---|---|
| **Hold Spacebar** | Key microphone PTT (Push-To-Talk) |
| **Release Spacebar** | Unkey PTT, play squelch tail, evaluate transmission |
| **Enter (in text box)** | Send typed fallback transmission |
| **Esc** | Close any open modal / popup |
| **Audio Test Button** | Test audio synthesizer (relay click, roger beep, squelch tail) |

---

## Technical Architecture

* **Zero Dependencies**: Pure HTML5, CSS3, and modern ECMAScript 2024.
* **Web Audio API**: Real-time synthesized RF noise oscillators, biquad bandpass filters, gain envelopes, and polyphonic brass synths.
* **Speech Recognition**: Hardware-prewarmed Web Speech API (`webkitSpeechRecognition`) with phonetic Levenshtein fuzzy matching and spoken number normalization.
* **Speech Synthesis**: Browser `window.speechSynthesis` tuned for Australian/English aviation cadence.
* **State Engines**: `MissionStageEngine`, `AutoPlayEngine`, `AudioEngine`, and `AWSStationTelemetry`.
