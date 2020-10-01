local AddOnName, AOTH = ...;
FRAME_DETECTION = false;
PETFOUND = flase
if(UnitClass("player") ~= "Hunter") then return end
function AOTH:CreateTargetButton(npcID)
    
    
    if not (InCombatLockdown()) then
        
        local BUTTON_WIDTH = 282;
        local BUTTON_HEIGHT = 97;
        
        for i = 1, #AOTH.test do
            if (AOTH.test[i]["id"] == npcID and FRAME_DETECTION == false) then
                PETFOUND = true
                ok = CreateFrame("Button", "secOK", UIParent, "SecureActionButtonTemplate")
                ok:SetWidth(BUTTON_WIDTH)
                ok:SetHeight(BUTTON_HEIGHT)
                ok:SetMovable(true)
                ok:SetPoint("RIGHT",-283,-63)
                ok:SetAttribute("type1", "macro")
                ok:SetAttribute("macrotext", "/cleartarget\n/target " .. AOTH.test[i]["name"])
                ok:RegisterForClicks("AnyUP")
                ok:HookScript("OnClick", function(self, button)
                    if (button == "RightButton") then
                        ok:Hide()
                        ok:SetAttribute("macrotext", "/cleartarget")
                        FRAME_DETECTION = false
                    end
                end)
                ok:SetUserPlaced(true)
                ok:RegisterForDrag("LeftButton")
                ok:HookScript("OnDragStart", ok.StartMoving)
                ok:HookScript("OnDragStop", ok.StopMovingOrSizing)
                PlaySoundFile("Interface\\AddOns\\AspectOfTheHunter\\Sounds\\Event_wardrum_ogre-1.ogg","Master")

                ok.petName = ok:CreateFontString("PET_NAME", "OVERLAY", "GameFontNormal")
                ok.petName:SetPoint("TOP", 5, -22)
                ok.petName:SetText(AOTH.test[i]["name"])

                ok.info = ok:CreateFontString("INFO", "OVERLAY", "GameFontWhite")
                ok.info:SetPoint("BOTTOM", 15, 30)
                ok.info:SetText("Left click to target\nRight click to close")
                
                background = ok:CreateTexture(nil, "ARTWORK")
                background:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                if (select(1, UnitFactionGroup("player")) == "Alliance") then
                    background:SetAtlas("loottoast-bg-alliance", true)
                else
                    background:SetAtlas("loottoast-bg-horde", true)
                end
                background:SetDesaturated(false)
                background:SetPoint("CENTER")
                
                
                petModel = CreateFrame("PlayerModel", "petModel", ok)
                petModel:ClearAllPoints()
                petModel:SetPoint("TOP", 0, 100)
                petModel:SetSize(120, 120)
                petModel:SetScale(1.25)
                petModel:SetDisplayInfo(AOTH.test[i]["displayID"])
                petModel:SetFacing(20 * math.pi / 180);
                petModel:Show()
                
                
                petIcon = CreateFrame("Frame", "PetIcon", ok)
                petIcon:SetWidth(54)
                petIcon:SetHeight(54)
                petIcon:SetPoint("LEFT", 28, 0)
                
                petIcon.bgframe = petIcon:CreateTexture(nil, "ARTWORK")
                petIcon.bgframe:SetSize(54, 54)
                
                petIcon.bgframe:SetAtlas("collections-itemborder-collected", true)
                
                petIcon.bgframe:SetDesaturated(false)
                petIcon.bgframe:SetPoint("CENTER")

                petIcon.bgIcon = petIcon:CreateTexture(nil, "BACKGROUND")
                petIcon.bgIcon:SetWidth(50)
                petIcon.bgIcon:SetHeight(50)
                petIcon.bgIcon:SetTexture("Interface\\AddOns\\AspectOfTheHunter\\Icons\\petFamilies\\" .. AOTH.test[i]["family"][2] .. ".blp")
                petIcon.bgIcon:SetPoint("CENTER")
                

                
                
                ok:Hide()
            end
        end
        
        
        
        
        if (FRAME_DETECTION == false and PETFOUND) then
            
            ok:Show()
            
            FRAME_DETECTION = true
        end
    else
        return
    end


end
