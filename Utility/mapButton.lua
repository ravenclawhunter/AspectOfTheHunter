AspectOfTheHunter = LibStub("AceAddon-3.0"):GetAddon("AspectOfTheHunter")
AddOnName, AOTH = ...;

if(UnitClass("player") ~= "Hunter") then return end

local info = {};
local checkFamily = {}
local zonecheck = {}
local flag = false

function AOTH:initCheck()
    
    for i = 1, #AOTH.families do
        checkFamily[i] = false
        
    end
    
    
    --[[for i = 1, #AOTH.zones do
        zonecheck[i] = false
    
    end]]
end


local function getZones()
    
    local zones = {}
    
    for i = 1, #AOTH.test do
        
        if not (tContains(zones, AOTH.test[i]["zone_name"])) then
            
            if (AOTH.test[i]["class"] ~= "Stable Master") then
                table.insert(zones, AOTH.test[i]["zone_name"])
            end
        
        end
    
    
    end
    table.sort(zones)
    return zones;

end

local function getZoneID(zoneName)
  
    local zoneID

    for i=1, #AOTH.test do

        if(zoneName == AOTH.test[i]["zone_name"]) then

            zoneID = AOTH.test[i]["zoneID"]
            break
        end

    end

    return zoneID
end


function AOTH:CreateStaticMapButton()
    local menuButton = CreateFrame("Button", "AOTH_MENU", WorldMapFrame.ScrollContainer)
    menuButton:SetPoint("TOPRIGHT", -70, 0)
    menuButton:SetFrameStrata("TOOLTIP")
    menuButton:SetWidth(30)
    menuButton:SetHeight(30)
    
    local pinTexture = menuButton:CreateTexture(nil, "HIGH");
    menuButton.texture = pinTexture;
    pinTexture:SetAllPoints(menuButton)
    pinTexture:SetTexture("Interface\\ICONS\\INV_Misc_Book_09.blp");
    menuButton:SetHighlightTexture("Interface\\ICONS\\INV_Misc_Book_09.blp", true);
    menuButton:Hide()
    return menuButton;
end

function AOTH:CreateMovableMapButton()
    local menuButtonMovable = CreateFrame("Button", "AOTH_MENU2", WorldMapFrame.ScrollContainer)
    menuButtonMovable:SetPoint("TOPRIGHT", -70, 0)
    menuButtonMovable:SetFrameStrata("TOOLTIP")
    menuButtonMovable:SetWidth(30)
    menuButtonMovable:SetHeight(30)
    menuButtonMovable:SetMovable(true)
    
    menuButtonMovable:SetUserPlaced(true)
    menuButtonMovable:RegisterForDrag("LeftButton")
    menuButtonMovable:SetScript("OnDragStart", menuButtonMovable.StartMoving)
    menuButtonMovable:SetScript("OnDragStop", menuButtonMovable.StopMovingOrSizing)
    menuButtonMovable:SetClampedToScreen(true)
    
    local pinTexture = menuButtonMovable:CreateTexture(nil, "BACKGROUND");
    menuButtonMovable.texture = pinTexture;
    pinTexture:SetAllPoints(menuButtonMovable)
    pinTexture:SetTexture("Interface\\ICONS\\INV_Misc_Book_09.blp");
    menuButtonMovable:SetHighlightTexture("Interface\\ICONS\\INV_Misc_Book_09.blp", true);
    menuButtonMovable:Hide()
    
    
    return menuButtonMovable
end

local menuButtonMovable = AOTH:CreateMovableMapButton()
local menuButton = AOTH:CreateStaticMapButton()
WorldMapFrame:HookScript("OnShow", function()
        
        
        if (AOTH.db.general.MoveMapIcon) then
            
            local dropDown = CreateFrame("FRAME", "dropDown")
            dropDown.displayMode = "MENU"
            menuButtonMovable:SetScript("OnCLick", function()ToggleDropDownMenu(1, nil, dropDown, menuButtonMovable, 3, -3) end)
            menuButtonMovable:Show()
            AOTH:DropDown(dropDown)
            if (menuButton:IsVisible()) then menuButton:Hide() end
        else
            
            local dropDown2 = CreateFrame("FRAME", "dropDown")
            dropDown2.displayMode = "MENU"
            menuButton:SetScript("OnCLick", function()ToggleDropDownMenu(1, nil, dropDown2, menuButton, 3, -3) end)
            menuButton:Show()
            AOTH:DropDown(dropDown2)
            if (menuButtonMovable:IsVisible()) then menuButtonMovable:Hide() end
        end
end)

function AOTH:DropDown(frame)
    UIDropDownMenu_Initialize(frame, function(self, level, menuList)
            
            if not level then return end
            wipe(info)
            if level == 1 then
                -- Create the title of the menu
                info.isTitle = 1
                info.text = "Hunter Pets:"
                info.notCheckable = 1
                UIDropDownMenu_AddButton(info, level)
                
                info.isTitle = false
                info.text = " "
                info.notCheckable = 1
                UIDropDownMenu_AddButton(info, level)
                
                info.disabled = nil
                info.isTitle = nil
                info.text = "Search for Family: "
                info.notCheckable = true
                info.keepShownOnClick = true
                info.hasArrow = true
                info.value = "family"
                UIDropDownMenu_AddButton(info, level)
                
                info.disabled = nil
                info.isTitle = nil
                info.text = "Search In Zone: "
                info.notCheckable = true
                info.keepShownOnClick = true
                info.hasArrow = true
                info.value = "zone"
                UIDropDownMenu_AddButton(info, level)
                
                info.disabled = nil
                info.isTitle = nil
                info.text = "Exotics: "
                info.notCheckable = true
                info.keepShownOnClick = true
                info.hasArrow = true
                info.value = "Exotics"
                UIDropDownMenu_AddButton(info, level)
                
                
                
                info.disabled = nil
                info.isTitle = nil
                info.text = "Scan Current Zone "
                info.notCheckable = true
                info.keepShownOnClick = true
                info.hasArrow = false
                info.func = function()
                        
                        local zone = C_Map.GetBestMapForUnit("player");
                        AspectOfTheHunter:SetFamilyToFind(zone, 0)
                        local PetAlert = 0
                        if not (flag) then
                            AspectOfTheHunter:ShowWorldMapPins()
                            flag = true
                        
                        elseif (WorldMapFrame:GetMapID() == zone) then
                            AspectOfTheHunter:HideWorldMapPins()AspectOfTheHunter:ResetMenu()AspectOfTheHunter:HideMinimapPins()
                            flag = false
                        end
                
                
                
                end
                
                UIDropDownMenu_AddButton(info, level)
                
                
                
                
                info.disabled = nil
                info.isTitle = nil
                info.text = "Reset Menu"
                info.notCheckable = true
                info.keepShownOnClick = true
                info.hasArrow = false
                info.func = function()AspectOfTheHunter:HideWorldMapPins()AspectOfTheHunter:ResetMenu()AOTH:initCheck()AspectOfTheHunter:HideMinimapPins(); end
                UIDropDownMenu_AddButton(info, level)
                
                info.isTitle = false
                info.text = " "
                info.notCheckable = 1
                UIDropDownMenu_AddButton(info, level)
                
                -- Close menu item
                info.hasArrow = nil
                info.value = nil
                info.notCheckable = 1
                info.text = "CLOSE"
                info.func = function()CloseDropDownMenus() end
                UIDropDownMenu_AddButton(info, level)
            
            elseif level == 2 then
                
                if UIDROPDOWNMENU_MENU_VALUE == "zone" then
                    
                    --local zones = AOTH:GetZoneList()
                    info.isTitle = 1
                    info.text = "Rare Pets:"
                    info.notCheckable = 1
                    UIDropDownMenu_AddButton(info, level)
                    
                    info.disabled = nil
                    info.isTitle = nil
                    info.text = "A to E: "
                    info.notCheckable = true
                    info.keepShownOnClick = true
                    info.hasArrow = true
                    info.value = "zoneSubAtoE"
                    UIDropDownMenu_AddButton(info, level)
                    
                    info.disabled = nil
                    info.isTitle = nil
                    info.text = "F  to M: "
                    info.notCheckable = true
                    info.keepShownOnClick = true
                    info.hasArrow = true
                    info.value = "zoneSubFtoM"
                    UIDropDownMenu_AddButton(info, level)
                    
                    info.disabled = nil
                    info.isTitle = nil
                    info.text = "N  to S: "
                    info.notCheckable = true
                    info.keepShownOnClick = true
                    info.hasArrow = true
                    info.value = "zoneSubNtoS"
                    UIDropDownMenu_AddButton(info, level)

                    info.disabled = nil
                    info.isTitle = nil
                    info.text = "T  to U: "
                    info.notCheckable = true
                    info.keepShownOnClick = true
                    info.hasArrow = true
                    info.value = "zoneSubTtoU"
                    UIDropDownMenu_AddButton(info, level)

                    info.disabled = nil
                    info.isTitle = nil
                    info.text = "V  to Z: "
                    info.notCheckable = true
                    info.keepShownOnClick = true
                    info.hasArrow = true
                    info.value = "zoneSubVtoZ"
                    UIDropDownMenu_AddButton(info, level)
                
                
                
                elseif UIDROPDOWNMENU_MENU_VALUE == "family" then
                    
                    info.isTitle = 1
                    info.text = "Rare Pets:"
                    info.notCheckable = 1
                    UIDropDownMenu_AddButton(info, level)
                    
                    info.disabled = nil
                    info.isTitle = nil
                    info.text = "Ferocity"
                    info.notCheckable = true
                    info.keepShownOnClick = true
                    info.hasArrow = true
                    info.value = "Ferocity"
                    UIDropDownMenu_AddButton(info, level)
                    
                    info.disabled = nil
                    info.isTitle = nil
                    info.text = "Tenacity"
                    info.notCheckable = true
                    info.keepShownOnClick = true
                    info.hasArrow = true
                    info.value = "Tenacity"
                    UIDropDownMenu_AddButton(info, level)
                    
                    info.disabled = nil
                    info.isTitle = nil
                    info.text = "Cunning"
                    info.notCheckable = true
                    info.keepShownOnClick = true
                    info.hasArrow = true
                    info.value = "Cunning"
                    UIDropDownMenu_AddButton(info, level)
                
                elseif UIDROPDOWNMENU_MENU_VALUE == "Exotics" then
                    
                    for id, petName in pairs(AOTH.families) do
                        
                        if (petName[3] == true) then
                            info.text = petName[1]
                            info.func = AOTH.toggle
                            info.arg1 = petName[1]
                            info.arg2 = id
                            info.checked = checkFamily[id]
                            info.hasArrow = nil
                            info.isNotRadio = true
                            info.keepShownOnClick = true
                            info.value = "ExoticPets"
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                
                end
            
            elseif level == 3 then
                
                
                
                
                if UIDROPDOWNMENU_MENU_VALUE == "zoneSubAtoE" then
                    for id, zones in pairs(getZones()) do
                        
                        local key = string.sub(zones, 1)
                        local numKey = string.byte(key)
                        
                        if (numKey >= 65 and numKey <= 69) then
                            info.text = zones
                            info.isTitle = nil
                            info.notCheckable = false
                            info.keepShownOnClick = true
                            info.func = AOTH.toggle
                            info.arg1 = getZoneID(zones)
                            info.arg2 = id
                            info.checked = zonecheck[id]
                            info.hasArrow = nil
                            info.isNotRadio = true
                            info.value = "petZones"
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                end
                
                if UIDROPDOWNMENU_MENU_VALUE == "zoneSubFtoM" then
                    for id, zones in pairs(getZones()) do
                        
                        local key = string.sub(zones, 1)
                        local numKey = string.byte(key)
                        
                        if (numKey >= 70 and numKey <= 77) then
                            info.text = zones
                            info.isTitle = nil
                            info.notCheckable = false
                            info.keepShownOnClick = true
                            info.func = AOTH.toggle
                            info.arg1 = getZoneID(zones)
                            info.arg2 = id
                            info.checked = zonecheck[id]
                            info.hasArrow = nil
                            info.isNotRadio = true
                            info.value = "petZones"
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                end
                
                if UIDROPDOWNMENU_MENU_VALUE == "zoneSubNtoS" then
                    for id, zones in pairs(getZones()) do
                        
                        local key = string.sub(zones, 1)
                        local numKey = string.byte(key)
                        
                        if (numKey >= 78 and numKey <= 83) then
                            info.text = zones
                            info.isTitle = nil
                            info.notCheckable = false
                            info.keepShownOnClick = true
                            info.func = AOTH.toggle
                            info.arg1 = getZoneID(zones)
                            info.arg2 = id
                            info.checked = zonecheck[id]
                            info.hasArrow = nil
                            info.isNotRadio = true
                            info.value = "petZones"
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                end

                if UIDROPDOWNMENU_MENU_VALUE == "zoneSubTtoU" then
                    for id, zones in pairs(getZones()) do
                        
                        local key = string.sub(zones, 1)
                        local numKey = string.byte(key)
                        
                        if (numKey >= 84 and numKey <= 85) then
                            info.text = zones
                            info.isTitle = nil
                            info.notCheckable = false
                            info.keepShownOnClick = true
                            info.func = AOTH.toggle
                            info.arg1 = getZoneID(zones)
                            info.arg2 = id
                            info.checked = zonecheck[id]
                            info.hasArrow = nil
                            info.isNotRadio = true
                            info.value = "petZones"
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                end

                if UIDROPDOWNMENU_MENU_VALUE == "zoneSubVtoZ" then
                    for id, zones in pairs(getZones()) do
                        
                        local key = string.sub(zones, 1)
                        local numKey = string.byte(key)
                        
                        if (numKey >= 86 and numKey <= 90) then
                            info.text = zones
                            info.isTitle = nil
                            info.notCheckable = false
                            info.keepShownOnClick = true
                            info.func = AOTH.toggle
                            info.arg1 = getZoneID(zones)
                            info.arg2 = id
                            info.checked = zonecheck[id]
                            info.hasArrow = nil
                            info.isNotRadio = true
                            info.value = "petZones"
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                end
                if UIDROPDOWNMENU_MENU_VALUE == "Ferocity" then
                    
                    
                    for id, petName in pairs(AOTH.families) do
                        
                        if (petName[2] == "Ferocity") then
                            for i = 1, #AOTH.test do
                                if (WorldMapFrame:GetMapID() == AOTH.test[i]["zoneID"] and AOTH.test[i]["family"][2] == petName[1]) then
                                    info.text = "|cFF00FF00" .. petName[1]
                                    break
                                else
                                    info.text = petName[1]
                                end
                            end
                            info.func = AOTH.toggle
                            info.arg1 = petName[1]
                            info.arg2 = id
                            info.checked = checkFamily[id]
                            info.hasArrow = nil
                            info.isNotRadio = true
                            info.keepShownOnClick = true
                            info.value = "FerocityPet"
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                end
                
                if UIDROPDOWNMENU_MENU_VALUE == "Tenacity" then
                    
                    
                    for id, petName in pairs(AOTH.families) do
                        
                        if (petName[2] == "Tenacity") then
                            
                            for i = 1, #AOTH.test do
                                if (WorldMapFrame:GetMapID() == AOTH.test[i]["zoneID"] and AOTH.test[i]["family"][2] == petName[1]) then
                                    info.text = "|cFF00FF00" .. petName[1]
                                    break
                                else
                                    info.text = petName[1]
                                end
                            end
                            info.func = AOTH.toggle
                            info.arg1 = petName[1]
                            info.arg2 = id
                            info.checked = checkFamily[id]
                            info.hasArrow = nil
                            info.isNotRadio = true
                            info.keepShownOnClick = true
                            info.value = "TenacityPet"
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                end
                
                if UIDROPDOWNMENU_MENU_VALUE == "Cunning" then
                    
                    
                    for id, petName in pairs(AOTH.families) do
                        
                        if (petName[2] == "Cunning") then
                            for i = 1, #AOTH.test do
                                if (WorldMapFrame:GetMapID() == AOTH.test[i]["zoneID"] and AOTH.test[i]["family"][2] == petName[1]) then
                                    info.text = "|cFF00FF00" .. petName[1]
                                    break
                                else
                                    info.text = petName[1]
                                end
                            end
                            info.func = AOTH.toggle
                            info.arg1 = petName[1]
                            info.arg2 = id
                            info.checked = checkFamily[id]
                            info.hasArrow = nil
                            info.isNotRadio = true
                            info.keepShownOnClick = true
                            info.value = "CunningPet"
                            UIDropDownMenu_AddButton(info, level)
                        end
                    end
                end
            end
    end)
end

function AOTH.toggle(dropdownbutton, arg1, arg2, checked)
    
    if checked then
        
        if (dropdownbutton.value == "FerocityPet"
            or dropdownbutton.value == "TenacityPet"
            or dropdownbutton.value == "CunningPet") then
            AspectOfTheHunter:SetFamilyToFind(arg1, arg2)AspectOfTheHunter:ShowWorldMapPins()
            checkFamily[arg2] = true;
        elseif (dropdownbutton.value == "petZones") then
            
            AspectOfTheHunter:SetFamilyToFind(arg1, arg2)AspectOfTheHunter:ShowWorldMapPins()
            WorldMapFrame:SetMapID(arg1)
            zonecheck[arg2] = true;
        elseif (dropdownbutton.value == "ExoticPets") then
            AspectOfTheHunter:SetFamilyToFind(arg1, arg2)AspectOfTheHunter:ShowWorldMapPins()
            checkFamily[arg2] = true;
        elseif (dropdownbutton.value == "Scan") then
            AspectOfTheHunter:SetFamilyToFind(arg1, arg2)AspectOfTheHunter:ShowWorldMapPins()
        
        end
    
    else
        
        if (dropdownbutton.value == "FerocityPet"
            or dropdownbutton.value == "TenacityPet"
            or dropdownbutton.value == "CunningPet") then
            AspectOfTheHunter:SetFamilyToHide(arg1)AspectOfTheHunter:HidePets(arg1)AspectOfTheHunter:HideMinimapPins()
            
            checkFamily[arg2] = false;
        elseif (dropdownbutton.value == "petZones") then
            AspectOfTheHunter:SetFamilyToHide(arg1)AspectOfTheHunter:HidePets(arg1)AspectOfTheHunter:HideMinimapPins()
            
            zonecheck[arg2] = false;
        elseif (dropdownbutton.value == "ExoticPets") then
            AspectOfTheHunter:SetFamilyToHide(arg1)AspectOfTheHunter:HidePets(arg1)AspectOfTheHunter:HideMinimapPins()
            
            checkFamily[arg2] = false;
        end
    
    end
end
