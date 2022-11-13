---- Condition 1 ----

--- Event(s) ---

UNIT_POWER_UPDATE:player

--- Custom Check ---

function()
  -- Desaturate if player does not have enough rage to cast IP
  if aura_env.config.iconOptions.saturateBasedOnRage then
      local rage = UnitPower("player") or 0
      local IPCost = aura_env.getIPCost()
      return not (rage >= IPCost)
  end
  
  -- Otherwise, desaturate if IP is not active
  return not aura_env.isIPUp
end

---- Condition 2 ----

--- Event(s) ---

UNIT_POWER_UPDATE:player

--- Custom Check ---

function()
  -- Do not apply glow if Require Rage is enabled and player does not have enough rage to cast IP
  if aura_env.config.iconOptions.glowRage then
      local rage = UnitPower("player") or 0
      local IPCost = aura_env.getIPCost()
      if not (rage >= IPCost) then return false end
  end
  
  local glowOnFullCast = aura_env.config.iconOptions.glowConditions[1]
  local glowOnPartialCast = aura_env.config.iconOptions.glowConditions[2]
  
  if glowOnFullCast and aura_env.IPCastType == "full" then return true end
  if glowOnPartialCast and aura_env.IPCastType == "partial" then return true end
  
  return false
end
