# Verilog Projects — Vivado Setup Guide

Three independent, simulation-verified projects. Each folder has:
- `<name>.v` — the design (the actual hardware logic)
- `tb_<name>.v` — the testbench (feeds test inputs, prints results)

All three have already been compiled and simulated (using Icarus Verilog)
to confirm correct behavior — you're getting working code, not just a draft.

---

## How to open in Vivado

1. **Create New Project** → RTL Project → don't add sources yet, just create it.
2. **Add Sources** → Add or Create Design Sources → add the `.v` design file
   (e.g. `traffic_light.v`).
3. **Add Sources** again → Add or Create Simulation Sources → add the
   `tb_<name>.v` file.
4. Choose any target part (a Basys3/Nexys A7 part is fine, or leave default —
   simulation doesn't need real hardware).
5. In the Flow Navigator, click **Run Simulation → Run Behavioral Simulation**.
6. Vivado opens the waveform viewer. Add the signals you want to see
   (right-click in the Scope/Objects pane → Add to Waveform), then click
   the restart/run icons to re-simulate.
7. You can also check the **Tcl Console** at the bottom — it will print the
   same `$display` messages you saw in the terminal test run.

No physical board is required to demonstrate these — waveform screenshots
from Vivado's simulator are enough for a resume/GitHub writeup.

---

## 1. Traffic Light Controller (`1_traffic_light/`)

**What it does:** Moore FSM cycling through 4 states — NS green, NS yellow,
EW green, EW yellow — each held for a fixed number of clock cycles.

**Verified output (state sequence):**
```
NS=GREEN  EW=RED
NS=YELLOW EW=RED
NS=RED    EW=GREEN
NS=RED    EW=YELLOW
... (repeats)
```

**Talking points for interview:** Moore machine (outputs depend only on
state), timer-based state transitions, how you'd extend it to add a
pedestrian-crossing request input.

---

## 2. Elevator Controller (`2_elevator/`)

**What it does:** 4-floor elevator (floors 0–3). Tracks pending requests,
decides direction of travel, opens the door on arrival, then goes idle.

**Verified behavior:** Starts at floor 0 → request comes in for floor 2 →
moves up → arrives, door opens for 4 cycles → request for floor 0 comes in
→ moves down → arrives, door opens again.

**Talking points:** FSM with 4 states (IDLE / MOVING_UP / MOVING_DN /
DOOR_OPEN), how direction is decided (scan for any pending request above
vs below current floor), how you'd extend it to serve multiple requests
in one direction before reversing (like a real elevator scheduling
algorithm).

---

## 3. Vending Machine Controller (`3_vending_machine/`)

**What it does:** Moore FSM tracking inserted coins (5 or 10 rupee coins).
Item price = 15. Dispenses the item once total ≥ 15 and returns any
excess as change.

**Verified output:**
```
10 + 5  = 15 -> ITEM DISPENSED, change = 0
10 + 10 = 20 -> ITEM DISPENSED, change = 5
```

**Talking points:** classic Moore FSM example, why states represent
"money inserted so far," how you'd extend it to support more coin types
or multiple items at different prices.

---

## Suggested resume bullets

- *Designed a Moore-FSM-based traffic light controller in Verilog managing
  timed transitions across 4 signal states; verified via self-checking
  testbench in Vivado simulation.*
- *Implemented an FSM-based 4-floor elevator controller in Verilog with
  request queuing and directional movement logic; verified via testbench
  covering multi-floor request scenarios.*
- *Built a vending machine controller in Verilog using a Moore FSM to
  track inserted coins and trigger dispense/change logic; verified
  correct change calculation via simulation.*
