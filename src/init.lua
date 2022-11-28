aura_env.IPSpellId = 190456
aura_env.isIPUp = false
aura_env.IPCastType = ""
aura_env.text1 = ""
aura_env.text2 = ""

local numberOfDecimalPlacesOptions = {false, 0, 1, 2, 3}
local numberOfDecimalPlaces = numberOfDecimalPlacesOptions[aura_env.config.textOptions.numberOfDecimalPlaces]

aura_env.getCastIP = function()
    local IPDescription = GetSpellDescription(aura_env.IPSpellId) or ""
    local castIPString = IPDescription:match("%%.+%d") or ""
    castIPString = castIPString:gsub("%D", "")
    local castIP = tonumber(castIPString) or 0
    return castIP
end

aura_env.getIPCost = function()
    local cost = 35
    local costTables = GetSpellPowerCost(aura_env.IPSpellId);
    -- Currently, there are 4 cost tables for IP, one for each spec aura (and base warrior). The table where hasRequiredAura is true has the correct cost.
    for _, costTable in pairs(costTables) do
        if costTable.hasRequiredAura then
            cost = costTable.cost
            break
        end
    end
    return cost
end

aura_env.setTextColor = function(r,g,b,a)
    local subRegions = aura_env.region.subRegions
    if (not subRegions) then return end
    
    local text1 = subRegions[2] and subRegions[2].type == "subtext" and subRegions[2].text
    local text2 = subRegions[3] and subRegions[3].type == "subtext" and subRegions[3].text
    
    if aura_env.config.textOptions.colorText1 then text1:SetTextColor(r,g,b,a) end
    if aura_env.config.textOptions.colorText2 then text2:SetTextColor(r,g,b,a) end
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
        if shortenedNumber >= 100 then shortenedNumber = string.format("%.0f", shortenedNumber)
        elseif shortenedNumber >= 10 then shortenedNumber = string.format("%.1f", shortenedNumber)
        elseif shortenedNumber >= 1 then shortenedNumber = string.format("%.2f", shortenedNumber)
        end
    else
        if number >= 1000 then shortenedNumber = string.format("%."..numberOfDecimalPlaces.."f", shortenedNumber) end
    end
    
    if aura_env.config.textOptions.dontShortenThousands and (number >= 1000 and number < 10000) then
        if wasNegative then number = number * -1 end
        return number
    else
        return shortenedNumber..suffix
    end
end

aura_env.shortenPercent = function(number)
    local shortenedNumber = number
    shortenedNumber = string.format("%."..aura_env.config.textOptions.percentNumOfDecimalPlaces.."f", shortenedNumber)
    if number <= 0 then shortenedNumber = 0 end
    return shortenedNumber.."%"
end
