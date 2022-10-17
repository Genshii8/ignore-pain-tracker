local numberOfDecimalPlaces = false
if aura_env.config.textOptions.numberOfDecimalPlaces == 2 then
    numberOfDecimalPlaces = 0
elseif aura_env.config.textOptions.numberOfDecimalPlaces == 3 then
    numberOfDecimalPlaces = 1
elseif aura_env.config.textOptions.numberOfDecimalPlaces == 4 then
    numberOfDecimalPlaces = 2
elseif aura_env.config.textOptions.numberOfDecimalPlaces == 5 then
    numberOfDecimalPlaces = 3
end

aura_env.setVisuals = function(r,g,b,a,glow)
    
    local region = aura_env.region
    
    if aura_env.config.textOptions.colorText1 then
        region.stacks:SetTextColor(r,g,b,a)
    end
    
    if aura_env.config.textOptions.colorText2 then
        region.text2:SetTextColor(r,g,b,a)
    end
    
    if aura_env.config.iconOptions.glowCondition ~= 1 then
        
        if aura_env.config.iconOptions.glowRage and not aura_env.canCastIP then
            glow = false
        end
        
        if glow then
            WeakAuras.ShowOverlayGlow(region)
        else
            WeakAuras.HideOverlayGlow(region)
        end
    end
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
        
        if shortenedNumber >= 100 then
            shortenedNumber = string.format("%.0f", shortenedNumber)
        elseif shortenedNumber >= 10 then
            shortenedNumber = string.format("%.1f", shortenedNumber)
        elseif shortenedNumber >= 1 then
            shortenedNumber = string.format("%.2f", shortenedNumber)
        end
        
    else
        
        if number >= 1000 then
            shortenedNumber = string.format("%."..numberOfDecimalPlaces.."f", shortenedNumber)
        end
    end
    
    if aura_env.config.textOptions.dontShortenThousands and (number >= 1000 and number < 10000) then
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
    
    shortenedNumber = string.format("%."..aura_env.config.textOptions.percentNumOfDecimalPlaces.."f", shortenedNumber)
    
    if number <= 0 then
        shortenedNumber = 0
    end
    
    return shortenedNumber.."%"
end 

aura_env.round = function(number)
    return math.floor(number + 0.5)
end
