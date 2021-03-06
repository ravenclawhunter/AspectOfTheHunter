local addon = LibStub("AceAddon-3.0"):GetAddon("AspectOfTheHunter", "AceEvent-3.0", "AceConsole-3.0", "AceGUI-3.0")
local AddOnName, AOTH = ...;



local NUM_OF_ENTRIES = 8
local maxSlots = NUM_PET_STABLE_PAGES * NUM_PET_STABLE_SLOTS;
local PETFOUND = false
local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGOUT")
eventFrame:RegisterEvent("PET_STABLE_SHOW")

function eventFrame:OnEvent(event, arg1)
    
    if (event == "ADDON_LOADED" and arg1 == "AspectOfTheHunter") then
        if (petlogDB == nil) then
            
            petlogDB = {}
        
        end
    end
    
    
    if (event == "PLAYER_LOGOUT" and arg1 == "AspectOfTheHunter") then
        
        petlogDB = petlogDB;
    end
    
    if (event == "PET_STABLE_SHOW") then
        --ScanStable()
    end


end

eventFrame:SetScript("OnEvent", eventFrame.OnEvent);

function UpdatePetLog()
    for i = 1, #petlogDB do
        HunterPetJournal2.text = HunterPetJournal2:CreateFontString("loggedPet" .. i, "ARTWORK")
        HunterPetJournal2.text:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
        HunterPetJournal2.text:SetText(petlogDB[i][2])
        if (i == 1) then
            HunterPetJournal2.text:SetPoint("TOPLEFT", 10, -45)
        else
            HunterPetJournal2.text:SetPoint("TOPLEFT", "loggedPet" .. i - 1, 0, -15)
        end
        HunterPetJournal2.text:Show()
    end
end

function OnTooltipSetUnit(self)
    
    if not (AOTH.db.general.BeastLoreTooltip) then
        local unitID = UnitGUID("mouseover")
        if not (unitID == nil or select(1, ("-"):split(unitID)) == "Pet") then
            
            if (unitID ~= nil) then
                
                local creatureFamily = UnitCreatureFamily("mouseover")
                local npc_id = select(6, ("-"):split(unitID));
                local spellList = ""
                for i = 1, #AOTH.tamablePets do
                    if (AOTH.tamablePets[i] == tonumber(npc_id)) then
                        PETFOUND = true
                        GameTooltip:AddDoubleLine("|cFF00FF00TAMEABLE!|r");
                        for family, data in pairs(AOTH.families) do
                            if (creatureFamily == data[1] and data[3]) then
                                GameTooltip:AddLine("|cFFFFFF00EXOTIC: |cFFFFFFFFBM ONLY!");
                            end
                            if (creatureFamily == data[1]) then
                                GameTooltip:AddLine("|cFFFFFF00Specialization: |cFFFFFFFF" .. data[2]);
                            end
                        end
                        for p = 1, #AOTH.test do
                            if (AOTH.test[p]["family"][2] == creatureFamily) then
                                local spells = AOTH.test[p]["familySkills"];
                                for k = 1, #spells do
                                    spellList = spellList .. " " .. select(1, GetSpellInfo(spells[k])) .. ",";
                                end
                                GameTooltip:AddLine("|cFFFFFF00Tamed Abilities:|cFFFFFFFF" .. spellList);
                                
                                break;
                            end
                        end
                        if (petlogDB ~= nil and #petlogDB >= 1) then
                            for k = 1, #petlogDB do
                                
                                if (npc_id == petlogDB[k][1]) then
                                    GameTooltip:AddLine("|cFFFF0000Already Tamed!");
                                end
                            
                            end
                        end
                    end
                end
                
                CanBeTamed(PETFOUND)
                PETFOUND = false
            end

            
        else
            if (unitID ~= nil) then
                local petID = select(6, ("-"):split(unitID))
                
                for i = 1, #AOTH.test do
                    if (tonumber(petID) == AOTH.test[i]["id"]) then
                        GameTooltip:AddLine(" ");
                        GameTooltip:AddLine("|cFFFFFF00Pet Name: |cFFFFFFFF" .. AOTH.test[i]["name"]);
                        GameTooltip:AddLine("|cFFFFFF00Found in: |cFFFFFFFF" .. AOTH.test[i]["zone_name"]);
                        GameTooltip:AddLine("|cFFFFFF00Family: |cFFFFFFFF" .. AOTH.test[i]["family"][2]);
                        GameTooltip:AddLine("|cFFFFFF00Max Wild Level: |cFFFFFFFF" .. AOTH.test[i]["maxlevel"]);
                    
                    
                    end
                end
            end
        end
    end
end

function CanBeTamed(PETFOUND)
    local creatureType = UnitCreatureType("mouseover")
    local creatureFamily = UnitCreatureFamily("mouseover")
    if (C_QuestLog.IsQuestFlaggedCompleted(46337) == false and creatureFamily == "Feathermane") then
            
        GameTooltip:AddLine("|cFFFF0000You Cannot Tame this pet because you\nhave not completed|r [Night of the Wilds]");
        
    end

    if (PETFOUND == false and creatureType == "Beast") then
                        
        
            GameTooltip:AddLine("|cFFFF0000Cannot Be Tamed!");
            
        
    end

   
end


local function LogPet(npc_id, spellID, pet_name)
    
    
    local petFound = false;
    if (select(2, HasPetUI())) then
        
        if (petlogDB ~= nil) then
            for i = 1, #petlogDB do
                
                if (npc_id == petlogDB[i][1]) then
                    petFound = true;
                end
            
            end
        end
        
        if not (petFound) then
            local pet_family = UnitCreatureFamily("pet")
            local date = date("%d/%m/%y %H:%M:%S")
            print("|cFF00FF00[Aspect Of The Hunter]:|r Pet tamed and logged!")
            table.insert(petlogDB, {npc_id, pet_name .. " " .. pet_family .. " " .. date})
        else
            print("|cFFFF0000[Aspect Of The Hunter]:|r Pet already tamed!")
        end
    
    end
end

function ScanStable()
    -- DEBUG LOCK FOR NEW EXPERIMENTAL CODE
    if AOTH.constants.DEBUG then return end
    
    
    
    
    for i = 1, maxSlots + 5 do
        if (i <= 5) then
            local selectedActivePet = _G["PetStableActivePet" .. i]
            if (_G["PetStableActivePet" .. i].tooltip ~= "Empty Stable Slot") then
                SetPetStablePaperdoll(PetStableModel, selectedActivePet.petSlot)
                petinfo = PetStableModel:GetDisplayInfo()
                local icon, name, level, family, talent = GetStablePetInfo(selectedActivePet.petSlot)
                
                for i = 1, #AOTH.petscan do
                    
                    if (petinfo == AOTH.petscan[i][1]) then print("PET FOUND") end
                
                end
            
            --print("ACTIVE Pet: [SLOT ".. i .. "] |cFF00FF00" .. name .. " " .. family .. "  ICON " .. petinfo )
            end
        else
            
            local selectedStabledPet = _G["PetStableStabledPet" .. i - 5]
            if (_G["PetStableStabledPet" .. i - 5].tooltip ~= "Empty Stable Slot") then
                SetPetStablePaperdoll(PetStableModel, selectedStabledPet.petSlot)
                petinfo = PetStableModel:GetDisplayInfo()
                local icon, name, level, family, talent = GetStablePetInfo(selectedStabledPet.petSlot)
                
                for i = 1, #AOTH.petscan do
                    
                    if (petinfo == AOTH.petscan[i][1]) then print("PET FOUND") end
                
                end
            
            -- print("STABLED Pet: [SLOT ".. i .. "]|cFF00FF00" .. name .. " " .. family)
            end
        end
    
    end
    AOTH:Print("Stables have been scanned!")
end

GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

local petFrame = CreateFrame("Frame");

petFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
petFrame:SetScript("OnEvent", function(self, event, ...)
        
        local spell = select(3, ...)
        local unitID = UnitGUID("target")
        if (unitID ~= nil) then
            local npc_id = select(6, ("-"):split(unitID));
            local pet_name = UnitFullName("target")
            if (spell == 1515) then
                C_Timer.After(1, function()LogPet(npc_id, spell, pet_name) end)
            end
        end
end)
