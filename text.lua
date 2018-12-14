function()
    
    -- Never Surrender
    local curHP = UnitHealth("player")
    local maxHP = UnitHealthMax("player")
    local percHPMissing = (maxHP - curHP) / maxHP
    local _, _, _, hasNS = GetTalentInfo(4, 2, 1)
    local NSPerc = hasNS and (1 + percHPMissing) or 1
    
    local currentIP = select(16, WA_GetUnitBuff("player", 190456)) or 0
    
    local castIP = tonumber((GetSpellDescription(190456):match("%%.+%d"):gsub("%D",""))) * NSPerc
    
    local IPCap = math.floor(castIP * 1.3)
    if aura_env.countAzeriteTrait(279172) >= 1 then
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
    
    if aura_env.config.saturateBasedOnRage then
        
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
    
    if currentIP + castIP <= IPCap then
        
        aura_env.setVisuals(aura_env.config.fullCastColor[1],aura_env.config.fullCastColor[2],aura_env.config.fullCastColor[3],aura_env.config.fullCastColor[4], aura_env.config.glowEffect)
        
    elseif IPCap - currentIP > 0 then
        
        aura_env.setVisuals(aura_env.config.capColor[1],aura_env.config.capColor[2],aura_env.config.capColor[3],aura_env.config.capColor[4], false)
        
    elseif IPCap - currentIP <= 0 then
        
        aura_env.setVisuals(aura_env.config.clipColor[1],aura_env.config.clipColor[2],aura_env.config.clipColor[3],aura_env.config.clipColor[4], false)
    end
    
    if aura_env.config.shortenText then
        currentIP = aura_env.shortenNumber(currentIP)
        additionalAbsorb = aura_env.shortenNumber(additionalAbsorb)
    end
    
    local text1 = ""
    
    if aura_env.config.text1 == 1 then
        text1 = currentIP
    elseif aura_env.config.text1 == 2 then
        text1 = percentOfCap
    elseif aura_env.config.text1 == 3 then
        text1 = additionalAbsorb
    elseif aura_env.config.text1 == 4 then
        text1 = percentOfMaxHP
    end
    
    local text2 = ""
    
    if aura_env.config.text2 == 1 then
        text2 = currentIP
    elseif aura_env.config.text2 == 2 then
        text2 = percentOfCap
    elseif aura_env.config.text2 == 3 then
        text2 = additionalAbsorb
    elseif aura_env.config.text2 == 4 then
        text2 = percentOfMaxHP
    end
    
    return text1, text2
end
