-- by Marok (v2.12)

local numberOfDecimalPlaces = false
if aura_env.config.numberOfDecimalPlaces == 2 then
    numberOfDecimalPlaces = 0
elseif aura_env.config.numberOfDecimalPlaces == 3 then
    numberOfDecimalPlaces = 1
elseif aura_env.config.numberOfDecimalPlaces == 4 then
    numberOfDecimalPlaces = 2
elseif aura_env.config.numberOfDecimalPlaces == 5 then
    numberOfDecimalPlaces = 3
end

aura_env.setVisuals = function(r,g,b,a, glow)
    
    local region = aura_env.region
    
    if aura_env.config.colorText1 then
        region.stacks:SetTextColor(r,g,b,a)
    end
    
    if aura_env.config.colorText2 then
        region.text2:SetTextColor(r,g,b,a)
    end
    
    region:SetGlow(glow)
end

aura_env.shortenNumber = function(number)
    
    local shortenedNumber = number
    
    local wasNegative = false
    if number < 0 then
        number = number * -1
        wasNegative = true
    end
    
    local suffix = ""
    if number >= 1000000 then
        shortenedNumber = shortenedNumber / 1000000
        suffix = "m"
    elseif number >= 1000 then
        shortenedNumber = shortenedNumber / 1000
        suffix = "k"
    end
    
    if not numberOfDecimalPlaces then
        
        if number >= 100000 then
            shortenedNumber = string.format("%.0f", shortenedNumber)
        elseif number >= 10000 then
            shortenedNumber = string.format("%.1f", shortenedNumber)
        elseif number >= 1000 then
            shortenedNumber = string.format("%.2f", shortenedNumber)
        end
        
    else
        
        if number >= 1000 then
            shortenedNumber = string.format("%."..numberOfDecimalPlaces.."f", shortenedNumber)
        end
    end
    
    if aura_env.config.dontShortenThousands and (number >= 1000 and number < 10000) then
        if wasNegative then
           number = number * -1 
        end
        return number
    else
        return shortenedNumber..suffix
    end
end

aura_env.shortenPercent = function(number)
    
    local shortenedNumber = number
    
    shortenedNumber = string.format("%."..aura_env.config.percentNumOfDecimalPlaces.."f", shortenedNumber)
    
    if number <= 0 then
        shortenedNumber = 0
    end
    
    return shortenedNumber.."%"
end

-- Thank you to Buds on wago for this function.

aura_env.countAzeriteTrait = function(spellId)
    
    local count = 0
    local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
    if (not azeriteItemLocation) then return 0 end
    
    local azeritePowerLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
    local specID = GetSpecializationInfo(GetSpecialization())
    
    for slot = 1, 5, 2 do
        local item = Item:CreateFromEquipmentSlot(slot)
        if (not item:IsItemEmpty()) then
            local itemLocation = item:GetItemLocation()
            if (C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLocation)) then
                local tierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(itemLocation)
                for tier, info in next, tierInfo do
                    if (info.unlockLevel <= azeritePowerLevel) then
                        for _, powerID in next, info.azeritePowerIDs do
                            if C_AzeriteEmpoweredItem.IsPowerSelected(itemLocation, powerID)
                            and C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(powerID, specID)
                            then
                                local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
                                if powerInfo.spellID == spellId then
                                    count = count + 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return count
end
