---
name: zetron-scenario-builder
description: Author, generate, or modify aviation communication scenarios for the Zetron DCS5020 Air-Ground Radio Simulator. Use whenever the user asks to create, add, design, or update a training flight scenario (e.g., inbounds, departures, emergency weather whiteouts, comms dropouts, SARWATCH overdues, medical evacuations, alternate radio routing).
---

# Zetron DCS5020 Scenario Builder Skill

This skill guides the creation, configuration, and integration of authentic flight dispatch scenarios into the **Zetron DCS5020 Air-Ground Voice Simulator** (`index.html`).

---

## 1. Mandatory Domain & Compliance Rules

1. **Strict Organization Anonymity**:
   - **NEVER** mention any specific government division, agency acronyms, or organizational titles in code, UI, scripts, or comments.
   - Use generic or geographical identifiers: *"Mawson Station"*, *"Station Comms"*, *"Antarctic Flight Operations"*, *"Mawson Dispatch"*, *"Base Radio Operator"*.

2. **UNICOM / Aerodrome Advisory Protocol (AROC)**:
   - Station operators provide **advisory traffic information only**, NOT Air Traffic Control (ATC).
   - **NEVER use ATC clearances**: Do not say *"Cleared to land"*, *"Cleared for takeoff"*, or *"Maintain altitude"*.
   - **Mandatory UNICOM Phraseology**:
     - Station report: *"Foxtrot-Bravo-Oscar, Mawson Base, read you strength 5."*
     - Runway / Skiway status: *"Rumdoodle Ski Landing Area currently reported clear."*
     - Weather telemetry: *"Surface wind [WIND], visibility [VIS] kilometres, temperature [TEMP], QNH [QNH]."*
     - Traffic advisory: *"No reported conflicting traffic in the circuit area."*
     - Touchdown readback: *"Foxtrot-Bravo-Oscar, Mawson Base copies down and safe at [UTC] UTC."*

3. **Authentic Phonetic Alphabet**:
   - All callsigns must expand to standard ICAO phonetics (e.g., `VHG-FBO` -> `Foxtrot-Bravo-Oscar`, `VKB-BTG` -> `Bravo-Tango-Golf`).

---

## 2. Radio Lines & Frequency Matrix Reference

The Zetron DCS5020 Matrix has 12 dedicated lines:

| Tile ID | Line Name | Frequency / Mode | Primary Role |
| :--- | :--- | :--- | :--- |
| **1** | **Tone Remote 1** | **126.700 MHz AM** | **Primary Air-to-Ground VHF Channel** |
| **2** | **Tone Remote 2** | **5484.0 kHz USB** | **Enroute Air HF Net (Long Range)** |
| **3** | **Iridium Sat** | **SAT 8816.767** | **Cockpit Satphone Voice Link** |
| **4** | Radio 4 (Hägg) | 148.250 MHz FM | Field Crew & Hägglunds Vehicles |
| **5** | Rumdoodle RPT | 149.800 MHz FM | Rumdoodle Ski Landing Area (SLA) Repeater |
| **6** | Mt Henderson | 148.500 MHz FM | Mountain Repeater (Elev 1020m) |
| **7** | Framnes Range | 149.250 MHz FM | Inland Range Repeater |
| **8** | Air Guard / UHF | 121.5 / 243.0 MHz | Emergency Distress Line |
| **9** | SAR HF Net | 3023.0 kHz USB | International SAR Frequency |
| **10** | Air-to-Air Tac | 123.450 MHz AM | Inter-Pilot Chat |
| **11** | Radio 11 (Ops) | 156.800 MHz FM | Base Operations & Marine Ch 16 |
| **12** | Casey/Davis HF | 8833.0 kHz USB | Inter-Station Trunk Relay |

---

## 3. Scenario Object Schema

Every scenario lives inside the `SCENARIOS` object in `index.html` (around line 3343):

```javascript
SCENARIOS['F'] = {
  id: 'F',                                       // Single uppercase letter
  name: 'F: Medical Evacuation Inbound (Twin Otter VHG-FBO)', // Display name
  type: 'medevac',                               // 'inbound' | 'departure' | 'emergency' | 'medevac'
  aircraftCall: 'VHG-FBO',                       // Tail registration
  pilotCallPhonetic: 'Foxtrot-Bravo-Oscar',       // Spoken callsign
  aircraftType: 'Twin Otter DHC-6',              // Aircraft airframe
  route: 'FIELD CAMP -> RUMDOODLE',              // Flight sector
  slaName: 'RUMDOODLE (Plateau - Elev 498m)',    // Destination skiway
  slaSurface: 'Firm sastrugi, emergency flare path lit', // Surface notes
  initialEtaMinutes: 30,                         // Initial time out
  stages: [
    {
      stageNum: 1,
      title: 'Initial Inbound Priority Medevac Contact',
      pilotCall: 'Mawson Traffic, Twin Otter Foxtrot-Bravo-Oscar, 35 miles south, priority medical transfer inbound, estimating Rumdoodle at [ETA] UTC. Request skiway conditions and medical vehicle standby.',
      expectedModel: 'Foxtrot-Bravo-Oscar, Mawson Base, strength 5. Priority acknowledged. Rumdoodle Ski Landing Area reported clear, doctor and medical Hägglunds standing by. Surface wind [WIND], QNH [QNH]. No conflicting traffic.'
    },
    {
      stageNum: 2,
      title: 'Descent Check & Medical Standby',
      pilotCall: 'QNH [QNH], Foxtrot-Bravo-Oscar descending 3,500 feet over north glacier.',
      expectedModel: 'Foxtrot-Bravo-Oscar, Mawson copies descent to 3,500 feet, medical team in position at skiway hut.'
    },
    {
      stageNum: 3,
      title: 'Circuit & Final Approach',
      pilotCall: 'Mawson Traffic, Foxtrot-Bravo-Oscar turning final Rumdoodle skiway.',
      expectedModel: 'Foxtrot-Bravo-Oscar, copy final, surface wind [WIND], skiway clear.'
    },
    {
      stageNum: 4,
      title: 'Touchdown & Patient Transfer',
      pilotCall: 'Foxtrot-Bravo-Oscar down and safe, vacating skiway to ambulance. Shutting down.',
      expectedModel: 'Foxtrot-Bravo-Oscar, Mawson copies down and safe at [UTC] UTC. Medical team is approaching aircraft.'
    }
  ]
};
```

### Supported Dynamic Template Tokens
The engine dynamically replaces these bracketed tokens at runtime:
- `[ETA]`: Dynamic estimated time of arrival (e.g. `07:45 UTC`).
- `[QNH]`: Current atmospheric pressure from telemetry (e.g. `992 hPa`).
- `[WIND]`: Current surface wind (e.g. `140 degrees at 25 knots`).
- `[VIS]`: Current visibility (e.g. `10 kilometres`).
- `[TEMP]`: Current ambient temperature (e.g. `minus 16`).
- `[UTC]`: Current Zulu timestamp (e.g. `11:42`).
- `[DEP_TIME]`: Simulated departure timestamp.
- `[SAR_TIME]`: Simulated SARWATCH expiration time.

---

## 4. End-to-End Implementation Workflow

When asked to build or add a new scenario:

### Step 1: Define the Scenario
Identify the aircraft type, callsign, route, scenario conditions (normal inbound, departure, emergency, comms dropout, SARWATCH alert, diversion), and the 4 mission stages.

### Step 2: Update `index.html`
1. **Dropdown Selector**:
   Locate `<select id="scenario-dropdown">` (around line 285) and add the new option:
   ```html
   <option value="F">F: Medical Evacuation Inbound (Twin Otter VHG-FBO)</option>
   ```
2. **Scenario Data Dictionary**:
   Add the new scenario definition into `const SCENARIOS = { ... }` (around line 3343).
3. **AutoPlay Sequence**:
   Locate `AutoPlayEngine.buildSteps(scenarioId)` (around line 4835). Add the corresponding case:
   ```javascript
   if (scenarioId === 'F') {
     this.steps = [
       {
         title: "Select AIR VHF 126.700 MHz",
         narration: "Mawson Dispatch verifies Tone Remote 1 is selected on AIR VHF 126.700 MHz.",
         action: () => { ... }
       },
       ...
     ];
   }
   ```
4. **Special Stage Handlers (if applicable)**:
   If the scenario includes rapid clock fast-forward or alternate comms (like Scenario E):
   - Hook into `handleUserTransmission()` or `advanceStage()`.

### Step 3: Verify with Headless Chrome
Always verify the layout renders cleanly across laptop viewport resolutions with no overflows:
```bash
google-chrome --headless --disable-gpu --virtual-time-budget=3000 --window-size=1449,560 --screenshot=test_scenario.png file://$(pwd)/index.html
```

### Step 4: Update Portable Zip & Git Push
1. Ensure `ZetronSim-Portable.zip` contains the latest `index.html` and `README.md`.
2. Commit and push to `origin/main`.
