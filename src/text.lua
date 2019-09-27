function()
    
    -- Never Surrender
    local curHP = UnitHealth("player")
    local maxHP = UnitHealthMax("player")
    local percHPMissing = (maxHP - curHP) / maxHP
    local _, _, _, hasNS = GetTalentInfo(4, 2, 1)
    local NSPerc = hasNS and (1 + percHPMissing) or 1
    
    local currentIP = select(16, WA_GetUnitBuff("player", 190456)) or 0
    
    local castIP = tonumber((GetSpellDescription(190456):match("%%.+%d"):gsub("%D",""))) * NSPerc or 0
    
    local IPCap = math.floor(castIP * 1.3)
    if aura_env.hasBloodsport then
        IPCap = math.floor(castIP * 1.295)
    end
    
    if IPCap - currentIP == -1 or IPCap - currentIP == -2 then
        IPCap = currentIP
    end
    
    local percentOfCap = currentIP / IPCap * 100
    percentOfCap = aura_env.shortenPercent(percentOfCap)
    
    local additionalAbsorb = IPCap - currentIP
    
    local percentOfMaxHP = currentIP / UnitHealthMax("player") * 100
    percentOfMaxHP = aura_env.shortenPercent(percentOfMaxHP)
    
    if aura_env.config.iconOptions.saturateBasedOnRage then
        
        if UnitPower("player") >= GetSpellPowerCost(190456)[1].cost then
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
    
    if (currentIP + castIP <= IPCap) or ((IPCap - currentIP) / castIP >= aura_env.config.textOptions.thresholdPerc) then -- full cast
        
        aura_env.setVisuals(aura_env.config.textOptions.fullCastColor[1],aura_env.config.textOptions.fullCastColor[2],aura_env.config.textOptions.fullCastColor[3],aura_env.config.textOptions.fullCastColor[4],
        aura_env.config.iconOptions.glowCondition == 2 or aura_env.config.iconOptions.glowCondition == 4)
        
    elseif IPCap - currentIP > 0 then -- cap cast
        
        aura_env.setVisuals(aura_env.config.textOptions.capColor[1],aura_env.config.textOptions.capColor[2],aura_env.config.textOptions.capColor[3],aura_env.config.textOptions.capColor[4],
        aura_env.config.iconOptions.glowCondition == 3 or aura_env.config.iconOptions.glowCondition == 4)
        
    elseif IPCap - currentIP <= 0 then -- clip cast
        
        aura_env.setVisuals(aura_env.config.textOptions.clipColor[1],aura_env.config.textOptions.clipColor[2],aura_env.config.textOptions.clipColor[3],aura_env.config.textOptions.clipColor[4], false)
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
