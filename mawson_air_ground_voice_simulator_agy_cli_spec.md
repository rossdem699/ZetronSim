# AGY-CLI Task Specification: Mawson Station Air-Ground Voice Radio Simulator

## 1. Project Overview & Objective
Build an interactive, real-time voice-driven aviation radio communications training simulator modeled after an Australian Antarctic Division (AAD) station communications console (Zetron / Axxon style GUI). 

The application trains station comms operators at **Mawson Station** to manage air-ground communications with incoming and outgoing fixed-wing aircraft (Twin Otter / Basler BT-67) landing at or departing from:
1. **Rumdoodle Ski Landing Area (SLA)** (Plateau ice strip)
2. **Mawson Sea Ice SLA** (Station-adjacent seasonal strip)

The app must use **Web Speech Recognition (STT)** with Spacebar Push-to-Talk (PTT) for the user, and **SpeechSynthesis (TTS)** with realistic cockpit/RF radio distortion filters for pilot responses.

---

## 2. Technical Stack & Architectural Requirements
- **Framework**: Single-page modern web application (React with Tailwind CSS or standalone HTML5/ES6 modules with Tailwind CDN).
- **Audio & Voice Layer**:
  - **Speech-to-Text (User PTT)**: Browser `webkitSpeechRecognition` / `SpeechRecognition` API.
  - **PTT Control**: Holding the `Spacebar` or clicking/holding the on-screen gooseneck PTT pedal activates recognition; releasing sends the transmission.
  - **Text-to-Speech (Pilot Radio)**: Browser `window.speechSynthesis`.
  - **Aviation Radio Sound Effects**: Web Audio API audio graph (bandpass filter $300\text{ Hz} - 3400\text{ Hz}$, light white-noise injection, mic click-on and squelch-tail burst upon release).
- **Data & State Management**:
  - Realistic Weather Generator: Automated Weather Station (AWS) / AMDS simulation (Wind direction/speed, Visibility, Drift, Temp, QNH altimeter).
  - Aircraft Mission State Engine: Step-by-step state machine tracking flight legs from inbound check-in to touchdown.
  - Instant Recall Recorder (IRR) buffer: Circular audio recorder/transcript log allowing instant replay of the last 3 transmissions.

---

## 3. UI/UX Layout: Axxon / Zetron Console Recreation
The interface must simulate an authentic radio dispatch terminal:

```
+-------------------------------------------------------------------------------+
| MAWSON COMMS CONSOLE - AXXON / ZETRON GUI           [UTC CLOCK: 04:15:22 UTC] |
+-----------------------+---------------------------------------+---------------+
| RADIO TILES (CHANNELS)| MET DATA / STATION AWS                | FLIGHT STRIP  |
| [1] AIR-GROUND VHF    | Wind: 140° @ 28 kts (Gusts 36 kts)    | CALL: VHG-FBO |
|     126.7 MHz [ACTIVE]| Vis: 8 km (Light blowing drift)       | TYPE: DHC-6   |
| [2] HF AIR SEC        | Temp: -18°C | QNH: 988 hPa            | ROUTE: DAVIS->|
|     5484 kHz          | SLA Selected: RUMDOODLE (Plateau)     | RUMDOODLE     |
| [3] STN OPS VHF CH 1  | SLA Surface: Firm wind-packed sastrugi| ETA: 04:45 UTC|
| [4] HÄGGLUNDS CH 2    |                                       | SARWATCH: ACT |
+-----------------------+---------------------------------------+---------------+
| PTT & IRR CONTROLS    | LIVE TRANSCRIPT & PHRASEOLOGY COACH   | PILOT AUDIO   |
| [ PTT TRANSMIT (SPC) ]| Pilot: "Mawson Traffic, Twin Otter..." | [RF EFFECT:ON]|
| [ IRR - REPLAY LAST ] | User:  "Twin Otter FBO, Mawson..."    | Volume: [====]|
| Tx Status: [IDLE/TX]  | Coach: "✓ Correct QNH and Wind passed"| Squelch:[====]|
+-----------------------+---------------------------------------+---------------+
```

### Key Interactive Components:
1. **Radio Frequency Tiles**:
   - Tile 1: Air-Ground VHF (Primary Active)
   - Tile 2: Air HF Secondary
   - Tile 3: Mawson Ops VHF (Ch 1)
   - Tile 4: Hägglunds / Ground Transfer Team (Ch 2)
   - Clicking a tile toggles RX Focus and Transmit Select.
2. **Push-To-Talk (PTT)**:
   - `Spacebar` Down: Radio Tx active, mic opens, audio waveform animates.
   - `Spacebar` Up: Tx terminates, squelch tail sound plays, user audio processed through STT.
3. **Instant Recall Recorder (IRR)**:
   - Dedicated "IRR" button that replays the last received incoming transmission with radio static.
4. **Active Met Bar (AWS Display)**:
   - Dynamic values for Wind, Visibility, Temp, and QNH that the trainee must read out accurately.

---

## 4. Aeronautical Phraseology Logic Engine (AROC Standard)

### Operating Constraints:
- Mawson Comms operates as an **Air-Ground Ground Station / UNICOM** (NOT Air Traffic Control).
- Trainees **must never** say "Cleared to land" or "Cleared for takeoff".
- Acceptable clearance language: "Runway clear", "Skiway reported clear", "No conflicting traffic", "Surface conditions are...".

### 4-Stage Interactive Scenario Sequence:

#### Stage 1: Initial Inbound Contact (~30–45 mins out)
- **Aircraft (TTS)**: 
  > *"Mawson Traffic, Twin Otter Foxtrot-Bravo-Oscar, 40 miles north-east, maintaining 7,500 feet, estimating Rumdoodle at [ETA] UTC, inbound for landing."*
- **User Expected Reply**:
  - Must include: Aircraft callsign (`Foxtrot-Bravo-Oscar` or `FBO`), station identifier (`Mawson Base` or `Mawson Traffic`), readability (`read you strength 5`), SLA status (`Rumdoodle clear`), Wind, Visibility, Temp, and **QNH** from the Met bar.
  - *Example*: `"[Callsign], Mawson Base, read you strength 5. Rumdoodle Ski Landing Area currently reported clear. Surface wind 140 degrees at 25 knots, visibility 10 kilometres, temperature minus 16, QNH 992. No conflicting traffic."`
- **Validation Engine**:
  - Checks if transcript contains: Call sign, "Mawson", "Rumdoodle", QNH value, and wind details.
  - Flags error if trainee says: `"Cleared to land"`.

#### Stage 2: Aircraft Readback & Descent (~10–15 mins out)
- **Aircraft (TTS)**:
  > *"QNH [QNH], Rumdoodle clear, Foxtrot-Bravo-Oscar descending to 3,000 feet."*
- **User Expected Reply**:
  - `"[Callsign], Mawson, copy"` or `"Mawson copies descent."`

#### Stage 3: Joining Circuit Call
- **Aircraft (TTS)**:
  > *"Mawson Traffic, Foxtrot-Bravo-Oscar, joining downwind for the Rumdoodle skiway."*
- **User Expected Reply**:
  - Must acknowledge downwind and pass updated wind check.
  - *Example*: `"[Callsign], copy downwind, wind now 150 degrees at 28 knots."`

#### Stage 4: Touchdown & Runway Vacated
- **Aircraft (TTS)**:
  > *"Foxtrot-Bravo-Oscar, down and safe at Rumdoodle, skiway clear, shutting down."*
- **User Expected Reply**:
  - Must acknowledge "down and safe" and record UTC time.
  - *Example*: `"[Callsign], Mawson copies down and safe at [Current UTC] UTC."`
- **Post-Landing Checklist Action**:
  - Prompt user to click **"Terminate SARWATCH"** and alert Hägglunds transfer crew on VHF Ch 2.

---

## 5. Phraseology Evaluation & Feedback Engine
Implement a fuzzy/pattern-matching grading system:
1. **AROC Protocol Checks**:
   - Did the user identify the aircraft callsign first?
   - Did the user identify Mawson Ground Station?
   - Did the user correctly read the current AWS QNH pressure?
   - **Critical Safety Strike**: Did the user issue an illegal air traffic control clearance (e.g., "cleared to land")? If so, trigger a red alert explanation.
2. **Instant Visual Feedback**:
   - Provide a scoring pill (e.g., `Readback Accurate 100%`, `Missing QNH`, `ATC Breach Warning`).
   - Show a "What you should have said" prompt if the speech pattern is incomplete.

---

## 6. Implementation Steps for AGY-CLI
1. **File Creation**:
   - Implement the complete application in a single self-contained HTML file (`index.html`) using Tailwind CSS via CDN, Lucide icons via CDN, and vanilla ES6 classes for audio effects and speech logic.
2. **Web Audio RF Sound Chain**:
   - Create audio synthesis for:
     - Mic PTT click on.
     - White noise generator running through a BiquadFilter (bandpass 400Hz - 3kHz).
     - PTT squelch tail termination burst (80ms pink noise burst).
3. **Voice Engine Integration**:
   - Integrate `SpeechRecognition` triggered by Spacebar `keydown` and stopped on `keyup`.
   - Setup fallback input box for environments without mic permissions.
   - Configure `speechSynthesis` using English voices (preferably Australian or US English if available).
4. **Flight Scenarios & State Machine**:
   - Provide scenario selector:
     - *Scenario A*: Standard VFR Inbound to Rumdoodle (DHC-6 Twin Otter).
     - *Scenario B*: Basler BT-67 Inbound to Mawson Sea Ice (Gusting Wind & Drift).
     - *Scenario C*: Overdue aircraft / SARWATCH exercise.

---

## 7. Verification & Testing Checklist
- [ ] Spacebar down starts audio recognition without duplicating event listeners.
- [ ] Spacebar up triggers squelch audio and initiates transcript evaluation.
- [ ] Pilot audio plays with high-pass/band-pass radio filter effect.
- [ ] IRR button replays the last synthesized radio transmission.
- [ ] System detects forbidden ATC phrases ("cleared to land") and flags an AROC safety breach.
- [ ] Flight strips and weather values update dynamically across scenarios.