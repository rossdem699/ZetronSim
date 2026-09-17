# Scenario Schema & Implementation Reference

This document provides drop-in templates and reference configurations for building scenarios in `index.html`.

---

## 1. Scenario Templates by Category

### Category A: Inbound Weather Diversion / Whiteout
Used when approaching skiway experiences sudden deteriorate below visual minimums.
```javascript
{
  id: 'G',
  name: 'G: Weather Diversion (Sudden Whiteout)',
  type: 'emergency',
  aircraftCall: 'VKB-BTG',
  pilotCallPhonetic: 'Bravo-Tango-Golf',
  aircraftType: 'Basler BT-67',
  route: 'DAVIS -> MAWSON SEA ICE (DIVERT RUMDOODLE)',
  slaName: 'MAWSON SEA ICE',
  slaSurface: 'Sea ice blowing snow, horizon lost in whiteout',
  initialEtaMinutes: 20,
  stages: [
    {
      stageNum: 1,
      title: 'Inbound Descent with Deteriorating AWS Weather',
      pilotCall: 'Mawson Traffic, Basler Bravo-Tango-Golf, 20 miles east descending 4,000 feet, estimating Sea Ice skiway at [ETA] UTC. Request updated AWS visibility.',
      expectedModel: 'Bravo-Tango-Golf, Mawson Base, strength 5. Deteriorating conditions: Sea Ice AWS reporting zero visibility in ground blizzard. Surface wind [WIND], QNH [QNH]. Rumdoodle Plateau skiway remains reported clear above inversion.'
    },
    {
      stageNum: 2,
      title: 'Decision to Divert to Rumdoodle Plateau',
      pilotCall: 'Bravo-Tango-Golf copies Sea Ice below minimums, unable visual contact. Diverting to Rumdoodle skiway, climbing 5,000 feet, revised ETA [ETA] UTC.',
      expectedModel: 'Bravo-Tango-Golf, Mawson Base copies diversion to Rumdoodle, climbing 5,000 feet. Rumdoodle skiway clear, wind [WIND].'
    },
    {
      stageNum: 3,
      title: 'Rumdoodle Circuit Joining Call',
      pilotCall: 'Mawson Traffic, Bravo-Tango-Golf visual with Rumdoodle markers, joining left base.',
      expectedModel: 'Bravo-Tango-Golf, copy left base, Rumdoodle surface wind [WIND], no conflicting traffic.'
    },
    {
      stageNum: 4,
      title: 'Touchdown & Safe on Plateau',
      pilotCall: 'Bravo-Tango-Golf down and safe at Rumdoodle, shutting down. Request transport to station.',
      expectedModel: 'Bravo-Tango-Golf, Mawson copies down and safe at Rumdoodle at [UTC] UTC. Hägglunds dispatched to plateau.'
    }
  ]
}
```

---

### Category B: Pre-Departure Radio Check & Comms Relay
Used for multi-hop communication tests prior to long traverse or deep-field depot flights.
```javascript
{
  id: 'H',
  name: 'H: Deep Field HF Check & Relay (Twin Otter)',
  type: 'hf_check',
  aircraftCall: 'VHG-FBO',
  pilotCallPhonetic: 'Foxtrot-Bravo-Oscar',
  aircraftType: 'Twin Otter DHC-6',
  route: 'RUMDOODLE -> SOUTHERN DEPOT',
  slaName: 'RUMDOODLE',
  slaSurface: 'Firm sastrugi, cold soak -28°C',
  initialEtaMinutes: 0,
  stages: [
    {
      stageNum: 1,
      title: 'Pre-flight HF Primary Radio Check',
      pilotCall: 'Mawson Comms, Twin Otter Foxtrot-Bravo-Oscar on HF 5484 kHz, pre-flight radio check from Rumdoodle skiway.',
      expectedModel: 'Foxtrot-Bravo-Oscar, Mawson Base on HF 5484, read you strength 4 with light static. How me?'
    },
    {
      stageNum: 2,
      title: 'Secondary Iridium Voice Link Verification',
      pilotCall: 'Read you strength 5 on HF, switching to Iridium cockpit satphone for secondary comms check.',
      expectedModel: 'Foxtrot-Bravo-Oscar, Mawson Base standing by on Iridium Sat Line 3.'
    },
    {
      stageNum: 3,
      title: 'Iridium Satellite Handshake',
      pilotCall: 'Mawson Comms, Foxtrot-Bravo-Oscar connected via Iridium Sat 8816, loud and clear.',
      expectedModel: 'Foxtrot-Bravo-Oscar, Mawson copies 5 by 5 on satellite. Both primary and secondary voice links verified.'
    },
    {
      stageNum: 4,
      title: 'Departure Clearance Lineup',
      pilotCall: 'Foxtrot-Bravo-Oscar, all comms verified, lining up Rumdoodle skiway heading 180 for Southern Depot.',
      expectedModel: 'Foxtrot-Bravo-Oscar, Mawson Base copies lineup, surface wind [WIND], QNH [QNH]. Report airborne with SARWATCH time.'
    }
  ]
}
```

---

## 2. AROC Speech Recognition Evaluation Keywords

When the engine evaluates user speech via `handleUserTransmission(spokenText)`:

| Stage | Expected Keywords | Pass Requirement |
| :--- | :--- | :--- |
| **Stage 1 (Initial Report)** | `strength 5`, `clear` or `reported clear`, `wind`, `qnh`, `traffic` | Must include callsign + strength + skiway + wind/qnh |
| **Stage 2 (Descent / Repeat)** | `copies descent`, `descent`, altitude (e.g. `3,000`, `2,500`), or `repeating` | Confirms aircraft descent altitude or repeats airborne time |
| **Stage 3 (Circuit)** | `downwind`, `base`, `final`, `wind`, `clear` | Acknowledges pilot's position in circuit |
| **Stage 4 (Touchdown)** | `down and safe`, `welcome`, `sarwatch` | Terminates SARWATCH or confirms safe landing |

---

## 3. AutoPlay Step Structure

```javascript
{
  title: "Clear Model Readback Broadcast",
  narration: "Station Operator holds PTT and reads back standard UNICOM advisory.",
  action: () => {
    virtualClick('tile-ptt-1', "TRANSMIT UNICOM READBACK", () => {
      pttActive = true;
      stationOperatorSpeech.speak(scriptText, () => {
        pttActive = false;
        this.scheduleNext(1200);
      });
    });
  }
}
```
