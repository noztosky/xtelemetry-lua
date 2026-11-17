--
-- A FRSKY SPort/FPort/FPort2 and TBS CRSF telemetry script for the Taranis class radios
-- based on ArduPilot's passthrough telemetry protocol
--
-- Author: Alessandro Apostoli, https://github.com/yaapu
--
-- Modified by Rock Robotics (xTelemetry), 2026-11-17:
--   - battery panel shows total voltage and charge % in large digits; min cell voltage removed
--   - without mAh, % is linear on average cell voltage: 3.5V = 0% (49.0V on 14S), 4.35V = 100% (60.9V on 14S)
-- Based on Yaapu Telemetry Script 2.1.0-dev (e83a693), https://github.com/yaapu/FrskyTelemetryScript
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY, without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, see <http://www.gnu.org/licenses>.
--

-----------------------
-- UNIT SCALING
-----------------------
local unitScale = getGeneralSettings().imperial == 0 and 1 or 3.28084
local unitLabel = getGeneralSettings().imperial == 0 and "m" or "ft"
local unitLongScale = getGeneralSettings().imperial == 0 and 1/1000 or 1/1609.34
local unitLongLabel = getGeneralSettings().imperial == 0 and "km" or "mi"

local function doGarbageCollect()
    collectgarbage()
    collectgarbage()
end


-- remaining charge from the average cell voltage, used when there is no
-- current sensor (no mAh): linear from 3.5V (0%, 49.0V on 14S, the FC's
-- critical voltage) to 4.35V (100%, 60.9V on 14S, LiHV full)
local function cellPercent(v)
  return math.min(math.max((v - 3.5) / (4.35 - 3.5) * 100, 0), 100)
end

local function drawPane(x,drawLib,conf,telemetry,status,battery,battId,getMaxValue,gpsStatuses)
  local perc = 0
  if battery[13+battId] > 0 and battery[10+battId] > 0 then
    perc = math.min(math.max((1 - (battery[10+battId]/battery[13+battId]))*100,0),99)
  elseif battery[1+battId] > 0 then
    -- battery[1+battId] is the average cell voltage in cV
    perc = math.floor(cellPercent(battery[1+battId]/100) + 0.5)
  end
  local flags = 0
  local dimFlags = 0
  if status.showMinMaxValues == false then
    if status.battAlertLevel2 == true then
      flags = BLINK
      dimFlags = BLINK
    elseif status.battAlertLevel1 == true then
      dimFlags = BLINK+INVERS
    end
  end
  -- total battery voltage, big
  lcd.drawNumber(x+1, 7, battery[4+battId], MIDSIZE+PREC1+flags)
  if status.showMinMaxValues == true then
    drawLib.drawVArrow(x+1+26, 7+2,6,false,true)
  else
    lcd.drawText(lcd.getLastRightPos()-1, 11, "V", dimFlags+SMLSIZE)
  end
  -- battery percentage, big
  lcd.drawNumber(x+1, 21, perc, MIDSIZE+flags)
  lcd.drawText(lcd.getLastRightPos()+1, 25, "%", SMLSIZE)
  -- battery current
  lcd.drawText(x+30, 36, "A", SMLSIZE+RIGHT)
  lcd.drawNumber(lcd.getLastLeftPos(), 36, getMaxValue(battery[7+battId],7+battId),PREC1+SMLSIZE+RIGHT)
  -- battery mah
  lcd.drawNumber(x+1, 44, battery[10+battId]/10, SMLSIZE+PREC2)
  lcd.drawText(lcd.getLastRightPos(), 44, "Ah", SMLSIZE)
  -- battery cap
  lcd.drawNumber(x+1, 44+7, battery[13+battId]/10, SMLSIZE+PREC2)
  lcd.drawText(lcd.getLastRightPos(), 44+7, "Ah", SMLSIZE)
end

return {
  drawPane=drawPane,
}
