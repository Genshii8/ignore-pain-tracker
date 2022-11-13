--- Event(s) ---

UNIT_MAXHEALTH:player,TRIGGER:1

--- Custom Trigger ---

-- This trigger watches trigger 1 (IP aura) in order to update the various IP-related values needed by other parts of this WeakAura.
function()
    local maxHealth = UnitHealthMax("player") or 1
    
    local currentIP = select(16, WA_GetUnitBuff("player", aura_env.IPSpellId)) or 0
    aura_env.isIPUp = currentIP > 0
    local castIP = tonumber((GetSpellDescription(aura_env.IPSpellId):match("%%.+%d"):gsub("%D", ""))) or 0
    local IPCap = math.floor(maxHealth * 0.3)
    
    -- maxAdditionalAbsorb can't be less than 0. Even if IPCap becomes lower than currentIP (resulting in a negative value), you won't lose absorb by casting IP.
    local maxAdditionalAbsorb = math.max(0, IPCap - currentIP)
    -- additionalAbsorb is castIP or the max amount of absorb that can be gained, whichever is lower.
    -- For example, if IPCap is 100 and currentIP is 70, a max of 30 absorb can be gained. If castIP is lower than that (say 25), that's what will be gained, otherwise it's that max value (if castIP is 35, you will still only gain 30).
    local additionalAbsorb = math.min(maxAdditionalAbsorb, castIP)
    
    -- e.g. if additionalAbsorb is 160 and castIP is 200, that cast will only grant 160 of its 200 absorb which is 80%, hence the name percentOfCast.
    local percentOfCast = additionalAbsorb / castIP
    
    -- A full cast is when a given cast of IP grants all its absorb or at least 80% (set by thresholdPerc) of its absorb.
    -- Partial cast when IP grants at least 20% (inverse of thresholdPerc) of its absorb.
    -- Otherwise, capped cast.
    if (currentIP + castIP <= IPCap) or (percentOfCast >= aura_env.config.textOptions.thresholdPerc) then
        aura_env.IPCastType = "full"
        aura_env.setTextColor(unpack(aura_env.config.textOptions.fullCastColor))
    elseif percentOfCast >= 1 - aura_env.config.textOptions.thresholdPerc then
        aura_env.IPCastType = "partial"
        aura_env.setTextColor(unpack(aura_env.config.textOptions.partialCastColor))
    else
        aura_env.IPCastType = "capped"
        aura_env.setTextColor(unpack(aura_env.config.textOptions.cappedCastColor))
    end
    
    local percentOfCap = aura_env.shortenPercent(currentIP / IPCap * 100)
    local percentOfMaxHP = aura_env.shortenPercent(currentIP / maxHealth * 100)
    
    if aura_env.config.textOptions.shortenText then
        currentIP = aura_env.shortenNumber(currentIP)
        additionalAbsorb = aura_env.shortenNumber(additionalAbsorb)
    end
    
    local textOutputs = {currentIP, percentOfCap, additionalAbsorb, percentOfMaxHP}
    aura_env.text1 = textOutputs[aura_env.config.textOptions.text1] or ""
    aura_env.text2 = textOutputs[aura_env.config.textOptions.text2] or ""
    
    return true
end
