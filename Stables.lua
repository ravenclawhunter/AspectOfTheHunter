local AddOnName, AOTH = ...;



local maxSlots = NUM_PET_STABLE_PAGES * NUM_PET_STABLE_SLOTS;
local L = LibStub("AceLocale-3.0"):GetLocale("AOTH")

local NUM_PER_ROW = 10
local heightChange = 65
local offSet = 40;
local ICON_SIZE = 32
local ACTIVE_PETS = 5
local TEX_COUNT = 1


PetStableFrame:SetWidth(1200)
PetStableFrame:SetHeight(PetStableStabledPet1:GetHeight() / (NUM_PER_ROW + 1.6) * maxSlots)
PetStableFrame:SetMovable(true)
PetStableFrame:EnableMouse(true)
PetStableFrame:RegisterForDrag("LeftButton")
PetStableFrame:SetScript("OnDragStart", function(self)self:StartMoving() end)
PetStableFrame:SetScript("OnDragStop", function(self)self:StopMovingOrSizing() end)
PetStableFrame:SetClampedToScreen(true)


PetStableNextPageButton:Hide()
PetStablePrevPageButton:Hide()
PetStableFrameModelBg:Hide()
PetStableModelShadow:Hide()
PetStablePetInfo:Hide()

PetStableFrameModelBg:SetWidth(PetStableFrameInset:GetWidth() - (PetStableStabledPet1:GetWidth() * 9))
PetStableFrameModelBg:SetHeight(PetStableFrame:GetHeight() - offSet)

PetStablePetInfo:ClearAllPoints()
PetStablePetInfo:SetPoint("TOP", PetStableFrameInset, (-PetStableStabledPet1:GetWidth() * 2), 0)

PetStableActiveBg:SetHeight(PetStableLeftInset:GetHeight())

local PetStableInfo = CreateFrame("Frame", "PetInfo", PetStableFrameInset, "ShadowOverlaySmallTemplate");
PetStableInfo:SetFrameStrata("HIGH")
PetStableInfo:SetWidth(PetStableFrameInset:GetWidth() - (PetStableStabledPet1:GetWidth() * (NUM_PER_ROW * 1.2)))
PetStableInfo:SetHeight(80)
PetStableInfo:SetPoint("TOPRIGHT", PetStableFrameInset, -(PetStableStabledPet1:GetWidth() * 10), -5)


local PstTex = PetStableInfo:CreateTexture(nil, "BACKGROUND")
PstTex:SetAllPoints(PetStableInfo)
PstTex:SetTexture("Interface\\BlackMarket\\BlackMarketBackground-Tile")


local PetStableBorder = CreateFrame("Frame", "Border", PetStableInfo, "InsetFrameTemplate2");
PetStableBorder:SetAllPoints(PetStableInfo)
PetStableBorder:Show()
PetStableInfo:Show()


local PetIcon = CreateFrame("Frame", "PetIcon");
PetIcon:SetWidth(ICON_SIZE)
PetIcon:SetHeight(ICON_SIZE)
PetIcon:SetPoint("TOPLEFT", PetStableInfo, 10, -10)
PetIcon:SetFrameStrata("HIGH")
PetIcon:Show()
local PPI = PetIcon:CreateTexture(nil, "BACKGROUND")
PPI:SetAllPoints(PetIcon)

local FONT_SIZE = 14;

PetStableInfo.type = PetStableInfo:CreateFontString(nil, "ARTWORK")
PetStableInfo.type:SetFont("Fonts\\ARIALN.ttf", FONT_SIZE, "OUTLINE")

PetStableInfo.level = PetStableInfo:CreateFontString(nil, "ARTWORK")
PetStableInfo.level:SetFont("Fonts\\ARIALN.ttf", FONT_SIZE, "OUTLINE")

PetStableInfo.name = PetStableInfo:CreateFontString(nil, "ARTWORK")
PetStableInfo.name:SetFont("Fonts\\ARIALN.ttf", FONT_SIZE, "OUTLINE")

PetStableInfo.family = PetStableInfo:CreateFontString(nil, "ARTWORK")
PetStableInfo.family:SetFont("Fonts\\ARIALN.ttf", FONT_SIZE, "OUTLINE")


local temp = {}
local function HideDetails()
    PetStableInfo.family:Hide()
    PetStableInfo.type:Hide()
    PetStableInfo.level:Hide()
    PetStableInfo.name:Hide()
    
    for index = 1, #temp do
        
        temp[index]:Hide()
    
    end
    wipe(temp)
end

local containers = 3

for i = 1, containers do
    
    container = CreateFrame("Frame", "Container_" .. i, PetStableInfo);
    
    container:SetHeight(PetStableInfo:GetHeight())
    container:SetFrameStrata("TOOLTIP")
    
    if (i == 1) then
        container:SetWidth(PetStableInfo:GetWidth() / 2.5)
        container:SetPoint("TOPLEFT", PetStableInfo, 0, 0)
    else
        container:SetWidth(PetStableInfo:GetWidth() / 3.5)
        container:SetPoint("TOPRIGHT", "Container_" .. i - 1, container:GetWidth(), 0)
    end
    
    container:Show()

end




local function PetStable_SetSelectedPetInfo(icon, name, level, family, talent)
    
    
    
    if (family) then
        
        PetStableInfo.family:SetText("Family: " .. family);
        PetStableInfo.family:SetPoint("BOTTOMLEFT", PetStableInfo.level, 0, -15)
        PetStableInfo.family:Show()
    
    end
    
    if (talent) then
        
        PetStableInfo.type:SetText("Spec: " .. talent);
        PetStableInfo.type:SetPoint("BOTTOMLEFT", PetStableInfo.family, 0, -15)
        PetStableInfo.type:Show()
    end
    
    if (level or level > 0) then
        PetStableInfo.level:SetText("Level: " .. level);
        PetStableInfo.level:SetPoint("BOTTOMLEFT", PetStableInfo.name, 0, -15)
        PetStableInfo.level:Show()
    end
    
    if (name) then
        PetStableInfo.name:SetText("Name: " .. name);
        PetStableInfo.name:SetPoint("TOPLEFT", PetIcon, PetIcon:GetWidth() + 20, 0)
        PetStableInfo.name:Show()
    end
    
    
    if (talent) then
        for index = 1, #AOTH.specSkills[talent] do
            
            local data = AOTH.specSkills[talent]
            
            local specIconFrame = CreateFrame("Frame", "specIconFrame" .. index)
            specIconFrame:SetFrameStrata("TOOLTIP")
            specIconFrame:SetWidth(ICON_SIZE / 2)
            specIconFrame:SetHeight(ICON_SIZE / 2)
            specIconFrame:SetScale(PetStableInfo:GetEffectiveScale())
            
            specIcon1 = specIconFrame:CreateTexture(nil, "ARTWORK")
            specIcon1:SetWidth(specIconFrame:GetWidth())
            specIcon1:SetHeight(specIconFrame:GetHeight())
            specIcon1:SetPoint("CENTER", 0, 0)
            if (index == 1) then
                specIconFrame:SetPoint("TOPLEFT", "Container_2", 0, -10)
            else
                specIconFrame:SetPoint("BOTTOMLEFT", "specIconFrame" .. index - 1, 0, -(specIconFrame:GetHeight()))
            end
            SI1 = PetStableInfo:CreateFontString(nil, "ARTWORK")
            SI1:SetFont("Fonts\\ARIALN.ttf", FONT_SIZE, "OUTLINE")
            
            local sN, sR, sI = GetSpellInfo(data[index]);
            
            specIcon1:SetTexture(sI);
            SI1:SetText(sN);
            
            SI1:SetPoint("LEFT", "specIconFrame" .. index, specIconFrame:GetWidth() + 5, 0)
            
            specIcon1:Hide()
            SI1:Hide()
            specIconFrame:Hide()
            specIconFrame:SetScript("OnEnter", function(self)
                    
                    AOTH:SetSpellTooltip(self, data[index])
            
            
            end)
            specIconFrame:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
            table.insert(temp, specIcon1)
            table.insert(temp, SI1)
            table.insert(temp, specIconFrame)
        
        end
        
        for i = 1, #AOTH.famSkills[family] do
            
            local data = AOTH.famSkills[family]
            
            local icon = CreateFrame("Frame", "Icon" .. i)
            icon:SetFrameStrata("TOOLTIP")
            icon:SetWidth(ICON_SIZE / 2)
            icon:SetHeight(ICON_SIZE / 2)
            icon:SetScale(PetStableInfo:GetEffectiveScale())
            
            familyIcon = icon:CreateTexture(nil, "ARTWORK")
            familyIcon:SetWidth(icon:GetWidth())
            familyIcon:SetHeight(icon:GetHeight())
            familyIcon:SetPoint("CENTER", 0, 0)
            if (i == 1) then
                icon:SetPoint("TOPLEFT", "Container_3", 0, -10)
            else
                icon:SetPoint("BOTTOMLEFT", "Icon" .. i - 1, 0, -(icon:GetHeight()))
            end
            FI = PetStableInfo:CreateFontString(nil, "ARTWORK")
            FI:SetFont("Fonts\\ARIALN.ttf", FONT_SIZE, "OUTLINE")
            
            local sN, sR, sI = GetSpellInfo(data[i]);
            
            familyIcon:SetTexture(sI);
            FI:SetText(sN);
            
            FI:SetPoint("LEFT", icon, 20, 0)
            
            familyIcon:Hide()
            FI:Hide()
            icon:Hide()
            icon:SetScript("OnEnter", function(self)
                    
                    AOTH:SetSpellTooltip(self, data[i])
            
            
            end)
            icon:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
            table.insert(temp, familyIcon)
            table.insert(temp, FI)
            table.insert(temp, icon)
        
        end
    end
    
    for index = 1, #temp do
        
        temp[index]:Show()
    
    end
    
    if (level == 0) then
        HideDetails()
    end
    PPI:SetTexture(icon);
    
    PPI:Show()
    PetIcon:Show()

end





PetStableInfo:SetScript("OnHide", function()
    HideDetails()
    PetIcon:Hide()
end)


for i = 1, maxSlots do
    
    
    CreateFrame("Button", "PetStableStabledPet" .. i, PetStableFrame, "PetStableSlotTemplate", i)
    _G["PetStableStabledPet" .. i]:HookScript("OnClick", function()
        HideDetails()
        
        local selectedPet = _G["PetStableStabledPet" .. i]
        local icon, name, level, family, talent = GetStablePetInfo(selectedPet.petSlot)
        for index = 1, #temp do
            
            
            
            temp[index]:Hide()
        
        end
        PetStable_SetSelectedPetInfo(icon, name, level, family, talent)
    
    end)

end

for i = 1, ACTIVE_PETS do
    
    _G["PetStableActivePet" .. i]:HookScript("OnClick", function()
        HideDetails()
        
        local selectedPet = _G["PetStableActivePet" .. i]
        local icon, name, level, family, talent = GetStablePetInfo(selectedPet.petSlot)
        
        PetStable_SetSelectedPetInfo(icon, name, level, family, talent)
    end)

end

for i = 1, maxSlots do
    local frame = _G["PetStableStabledPet" .. i]
    if i > 1 then
        frame:ClearAllPoints()
        frame:SetPoint("LEFT", _G["PetStableStabledPet" .. i - 1], "RIGHT", 7.3, 0)
    end
    frame:SetFrameLevel(PetStableFrame:GetFrameLevel() + 1)
    frame:SetScale(7 / 10)
end

PetStableStabledPet1:ClearAllPoints()
PetStableStabledPet1:SetPoint("TOPRIGHT", PetStableFrameInset, -PetStableStabledPet1:GetWidth() * NUM_PER_ROW - PetStableStabledPet1:GetWidth() * 1.4, -9)




for i = NUM_PER_ROW + 1, maxSlots do
    
    _G["PetStableStabledPet" .. i]:ClearAllPoints()
    _G["PetStableStabledPet" .. i]:SetPoint("TOPLEFT", _G["PetStableStabledPet" .. i - NUM_PER_ROW], "BOTTOMLEFT", 0, -5)
end


PetStableFrameInset:SetPoint("BOTTOMRIGHT", PetStableFrame, "BOTTOMRIGHT", -5, 5)
PetStableBottomInset:Hide()

PetStableFrameStableBg:SetHeight(116 + heightChange)



NUM_PET_STABLE_SLOTS = maxSlots
NUM_PET_STABLE_PAGES = 1
PetStableFrame.page = 1


local function AnimalCompAlert(frame)
    
    local animalCompFrame = frame:CreateTexture(nil, "TOOLTIP")
    animalCompFrame:SetPoint("CENTER")
    animalCompFrame:SetTexture("Interface\\Artifacts\\ArtifactPower-QuestBorder.blp")
    animalCompFrame:Hide()
    
    hooksecurefunc("PetStable_UpdateSlot", function(button, petSlot)
        local id, name, _, Selected = GetTalentInfo(1, 2, 1)
            
            if (petSlot == 6 and Selected) then
                
                animalCompFrame:Show()
                local icon, name, level, family, talent = GetStablePetInfo(petSlot)
                if not family or family == "" then return "" end
                
                
                
                local tooltipstr = format(STABLE_PET_INFO_TOOLTIP_TEXT, level, family, talent) .. "|n"
                
                
                tooltipstr = tooltipstr .. L["ANIMAL_COMPANION_SLOT"]
                
                button.tooltipSubtext = tooltipstr
                
                if GameTooltip:IsOwned(button) then button:GetScript("OnEnter")(button) end

            end
            if not (Selected) then
        
                animalCompFrame:Hide()
            end
            
    end)
    
   

end

AnimalCompAlert(PetStableStabledPet1)
