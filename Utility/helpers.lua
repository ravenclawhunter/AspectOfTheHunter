local AddOnName, AOTH = ...;

ADDON_VERSION = "1.8.1BETA"
if(UnitClass("player") ~= "Hunter") then return end
function AOTH:TableMerge(table1, table2)
    
    local pets = {}
    local k = 1
    for i = 1, (#table1 + #table2) do
        if (i <= #table1) then
            table.insert(pets, table1[i])
        else
            
            table.insert(pets, table2[k])
            k = k + 1
        end
    
    end
    
    return pets;

end

function AOTH:PetsInZone()
    
    local mapID = GetMapID()
    local pets = {}
    
    for i = 1, #AOTH.test do
        if (AOTH.test[i]["zoneID"] == mapID and AOTH.test[i]["class"] ~= "Stable Master") then
            table.insert(pets, AOTH.test[i]["id"])
        end
    end
    
    return pets;
end


function AOTH:GetZoneList()
    
    
    local res = {}
    for i = 1, #AOTH.test do
        
        res[AOTH.test[i]["zone_name"]] = AOTH.test[i]["zoneID"]
    end
    
    for k, v in pairs(res) do
        print(res[k])
    end
    
    return res
end

function AOTH:LoadPetModels()
    
    local petModels = {};
    
    for i = 1, #AOTH.test, 1 do
        
        petModels[AOTH.test[i]["id"]] = AOTH.test[i]["displayID"];
    
    end
    
    return petModels;
end

function AOTH:LoadPetModel(container)
    
    local petModel = AOTH:LoadPetModels();
    -- Create the dropdown, and configure its appearance
    local petModelFrame = CreateFrame("FRAME", nil, container, "UIPanelSquareButton")
    petModelFrame:SetFrameStrata("TOOLTIP")
    petModelFrame:SetPoint("BOTTOMLEFT", -100, 0)
    petModelFrame:SetHeight(100)
    petModelFrame:SetWidth(100)
    
    
    
    
    return petModelFrame;


end


function AOTH:SetSpellTooltip(self, spellID)
    
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetHyperlink("spell:" .. tostring(spellID))
    GameTooltip:Show()


end

function AOTH:Print(message)
    print("|cFF00FF00[" .. AOTH.constants["ADDON_NAME"] .. "]: |cFFFFFFFF" .. message);
end

function AOTH:Increment(value, flag)
    
    if (flag) then
        value = value + 1
        return value;
    else
        return 1
    end
    

end
