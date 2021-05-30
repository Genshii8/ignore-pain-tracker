function()
    
    -- Never Surrender
    local curHP = UnitHealth("player")
    local maxHP = UnitHealthMax("player")
    local _, _, _, hasNS = GetTalentInfoByID(22384, 1)
    local NSPerc = hasNS and (1.4 + (0.6 * (1 - curHP / maxHP))) or 1
    
    local currentIP = select(16, WA_GetUnitBuff("player", 190456)) or 0
    
    local descriptionAmount = GetSpellDescription(190456):match("%%.+%d")
    -- On game restart, the returned description is sometimes an empty
    -- string, so the match is 'nil'.  When it is, use an arbitrary,
    -- nonzero amount.
    if descriptionAmount == nil then
        descriptionAmount = 1
    else
        descriptionAmount = descriptionAmount:gsub("%D","")
        descriptionAmount = tonumber(descriptionAmount)
    end
    
    local castIP = math.floor(descriptionAmount * NSPerc)
    
    local IPCap = castIP * 2
    
    local percentOfCap = currentIP / IPCap * 100
    percentOfCap = aura_env.shortenPercent(percentOfCap)
    
    local additionalAbsorb = math.min(math.max(0, IPCap - currentIP), castIP)
    
    local percentOfMaxHP = currentIP / maxHP * 100
    percentOfMaxHP = aura_env.shortenPercent(percentOfMaxHP)
    
    aura_env.canCastIP = UnitPower("player") >= GetSpellPowerCost(190456)[4].cost
    
    if aura_env.config.iconOptions.saturateBasedOnRage then
        
        if canCastIP then
            aura_env.region:SetDesaturated(false)
        else
            aura_env.region:SetDesaturated(true)
        end
        
    else
        
        if currentIP == 0 then
            aura_env.region:SetDesaturated(true)
        else
            aura_env.region:SetDesaturated(false)
        end
    end
    
    local percentOfCast = additionalAbsorb / castIP
    local glow = false
    
    if (currentIP + castIP <= IPCap) or (percentOfCast >= aura_env.config.textOptions.thresholdPerc) then -- full cast
        glow = aura_env.config.iconOptions.glowCondition == 2 or aura_env.config.iconOptions.glowCondition == 4
        
        aura_env.setVisuals(aura_env.config.textOptions.fullCastColor[1],aura_env.config.textOptions.fullCastColor[2],
            aura_env.config.textOptions.fullCastColor[3],aura_env.config.textOptions.fullCastColor[4],glow)
    elseif percentOfCast >= 1 - aura_env.config.textOptions.thresholdPerc then -- cap cast
        glow = aura_env.config.iconOptions.glowCondition == 3 or aura_env.config.iconOptions.glowCondition == 4
        
        aura_env.setVisuals(aura_env.config.textOptions.capColor[1],aura_env.config.textOptions.capColor[2],
            aura_env.config.textOptions.capColor[3],aura_env.config.textOptions.capColor[4],glow)
    else -- capped
        aura_env.setVisuals(aura_env.config.textOptions.cappedColor[1],aura_env.config.textOptions.cappedColor[2],
            aura_env.config.textOptions.cappedColor[3],aura_env.config.textOptions.cappedColor[4],glow)
    end
    
    if aura_env.config.textOptions.shortenText then
        currentIP = aura_env.shortenNumber(currentIP)
        additionalAbsorb = aura_env.shortenNumber(additionalAbsorb)
    end
    
    local text1 = ""
    
    if aura_env.config.textOptions.text1 == 1 then
        text1 = currentIP
    elseif aura_env.config.textOptions.text1 == 2 then
        text1 = percentOfCap
    elseif aura_env.config.textOptions.text1 == 3 then
        text1 = additionalAbsorb
    elseif aura_env.config.textOptions.text1 == 4 then
        text1 = percentOfMaxHP
    end
    
    local text2 = ""
    
    if aura_env.config.textOptions.text2 == 1 then
        text2 = currentIP
    elseif aura_env.config.textOptions.text2 == 2 then
        text2 = percentOfCap
    elseif aura_env.config.textOptions.text2 == 3 then
        text2 = additionalAbsorb
    elseif aura_env.config.textOptions.text2 == 4 then
        text2 = percentOfMaxHP
    end
    
    return text1, text2
end
