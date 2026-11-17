# xTelemetry

EdgeTX/OpenTX telemetry script for Rock Robotics drones, for black & white
128x64 radios (for example the RadioMaster Boxer). It shows ArduPilot telemetry
(HUD, flight mode, GPS, battery, messages) received over an ELRS link in
MAVLink mode or other passthrough links.

xTelemetry is a modified version of the
[Yaapu Telemetry Script](https://github.com/yaapu/FrskyTelemetryScript)
2.1.0-dev (e83a693) by Alessandro Apostoli, distributed under the same
GNU General Public License v3.0 (see [LICENSE](LICENSE)).

## Changes from Yaapu

| File | Change |
|---|---|
| `src/yaapu7.lua` | Displayed name "Yaapu 2.1.0-dev" -> "xTelemetry v2.1"; default battery 1 cell count 0 (auto) -> 14 (14S) |
| `src/Yaapu/menu7.lua` | Menu title renamed; "batt[1] cells override" default 0 -> 14 |
| `src/Yaapu/right7.lua` | Battery panel shows total voltage and charge % in large digits, min cell voltage removed. Without mAh the % is linear on the average cell voltage: 3.5 V = 0 % (49.0 V on 14S) to 4.35 V = 100 % (60.9 V on 14S) |
| `SD/SCRIPTS/TOOLS/xTelemetry Config.lua` | Renamed from "Yaapu Config.lua", content unchanged |
| `SD/SOUNDS/yaapu0/en/yaapu.wav` | Startup voice says "X Telemetry" instead of "Yaapu Telemetry" (Windows speech synthesis, 32 kHz 16-bit mono like the original) |

Each changed file also carries a modification notice at the top. Everything
else is the unmodified upstream release.

Why the cell count matters: the ArduPilot passthrough battery frame carries
the pack voltage in 9 bits of 0.1 V, so above 51.1 V (12S) it wraps (52.6 V
arrives as 1.4 V). With a cell count of 12 or more set, the script adds the
lost 51.2 V back, so 14S packs read correctly.

## Install

Copy the contents of `SD/` onto the radio's SD card (merging with the existing
folders), then pick `yaapu7` as a telemetry screen script for the model.
The startup voice `SOUNDS/yaapu0/en/yaapu.wav` is in `SD/`; the other voice
files are the upstream ones (`OTX_ETX/bw_common/SD/SOUNDS/yaapu0` in the Yaapu
repository) and are not in this repository.

Per-model settings are saved in `MODELS/yaapu/<model name>.cfg` and can be
changed with the `xTelemetry Config` tool.

## Build

The radio runs the compiled `.luac` files. `SD/` already contains them.
After changing a file in `src/`, run:

```sh
./build.sh
```

It compiles `yaapu7`, `menu7` and `right7` into `SD/` with `tools/luac/luac-edgetx`,
building that first if needed (`tools/luac/build_luac.sh`: Lua 5.3.6 with
`LUA_32BITS` and the 32-bit `size_t` dump patch `ldump-edgetx.patch`, which
matches EdgeTX bytecode). For the unmodified upstream sources this luac
produces byte-identical `.luac` files to the upstream release.

The other `.luac` files in `SD/` are the upstream release builds.
`src/Yaapu/reset.lua` does not compile as published upstream (a missing
comma), so the upstream `reset.luac` is used as is.

## 한국어 요약

- Yaapu Telemetry Script(GPL-3.0)를 Rock 드론용으로 수정한 조종기 텔레메트리 스크립트입니다.
- 이름은 xTelemetry로 바꿨고(시작 음성도 "X Telemetry"), 14S 배터리를 기본으로 합니다.
- 오른쪽 패널에 전체 전압과 잔량 %를 크게 표시합니다. 잔량은 49.0V = 0%, 60.9V = 100%(14S 기준) 직선 계산입니다.
- 설치: `SD/` 폴더 내용을 조종기 SD 카드에 복사합니다.
- 수정 후 빌드: `./build.sh`
- 라이선스: GPL-3.0. 수정본을 배포할 때는 이 저장소의 소스와 LICENSE를 함께 제공해야 합니다.
