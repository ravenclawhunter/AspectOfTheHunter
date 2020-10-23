
AspectOfTheHunter = LibStub("AceAddon-3.0"):NewAddon("AspectOfTheHunter", "AceConsole-3.0", "AceEvent-3.0")
AddOnName, AOTH = ...;
local L = LibStub("AceLocale-3.0"):GetLocale("AOTH")

-- this is a branch test
AOTH.constants = {
    ADDON_NAME = "AspectOfTheHunter",
    DEBUG = false,
}

AOTH.colors = {
    Rare = {0.0, 0.44, 0.87},
    Rare_Elite = {0.64, 0.19, 0.79},
    Elite = {1, 0.4, 0},
    ["Stable Master"] = {1, 1, 1}
};


function AspectOfTheHunter:OnInitialize()
    
    local DEFAULTS = {
        profile = {
            general = {
                TargetSystem = true,
                MoveMapIcon = false,
                BeastLoreTooltip = false,
                ToggleMiniMapIcon = false,
                ResizeStableIcon = false,
                MinimalMapIcons = false
            }
        }
    }
    
    
    
    self.db = LibStub("AceDB-3.0"):New("AspectDB", DEFAULTS)
    AOTH.db = self.db.profile;
    AOTH:ResetCheck()
    self:InitializeZones();
    self:CheckZone();
    AOTH:LoadOptions()
    PET_MODELS = AOTH:LoadPetModels()




end

function AOTH:LoadOptions()
    
    
    local options = {
        name = L["ADDON_NAME"],
        handler = AspectOfTheHunter,
        type = "group",
        childGroups = "tab",
        args = {
            options_tab = {
                order = 0,
                name = "General",
                type = "group",
                desc = "Configure the basics of AOTH",
                args = {
                    TargetSystem = {
                        name = L["ENABLE_TARGET_SYSTEM"],
                        desc = L["ENABLE_TARGET_SYSTEM_DESC"],
                        type = "toggle",
                        order = 0,
                        get = function()
                            return AOTH.db.general.TargetSystem
                        end,
                        set = function(_, value)
                            AOTH.db.general.TargetSystem = value
                        end,
                        width = "full",
                    },
                    MoveMapIcon = {
                        name = L["MOVE_MAP_ICON"],
                        desc = L["MOVE_MAP_ICON_DESC"],
                        type = "toggle",
                        order = 1,
                        get = function()
                            
                            return AOTH.db.general.MoveMapIcon
                        end,
                        set = function(_, value)
                            AOTH.db.general.MoveMapIcon = value
                        end,
                        
                        width = "full",
                    },
                    ToggleMiniMapIcon = {
                        name = L["DISABLE_MINIMAP_ICONS"],
                        desc = L["DISABLE_MINIMAP_ICONS_DESC"],
                        type = "toggle",
                        order = 2,
                        get = function()
                            AspectOfTheHunter:UpdateMinimapPlugin()
                            return AOTH.db.general.ToggleMiniMapIcon
                        end,
                        set = function(_, value)
                            AspectOfTheHunter:UpdateMinimapPlugin()
                            AOTH.db.general.ToggleMiniMapIcon = value
                        
                        end,
                        width = "full",
                    },
                    BeastLoreTooltip = {
                        name = "Disable tooltip creature info",
                        desc = L["DISABLE_TOOTIP_DESC"],
                        type = "toggle",
                        order = 3,
                        get = function()
                            
                            return AOTH.db.general.BeastLoreTooltip
                        end,
                        set = function(_, value)
                            
                            AOTH.db.general.BeastLoreTooltip = value
                        
                        end,
                        width = "full",
                    },
                    ResizeStableIcon = {
                        name = L["SMALLER_STABLE_ICONS"],
                        desc = L["SMALLER_STABLE_ICONS_DESC"],
                        type = "toggle",
                        order = 4,
                        get = function()
                            
                            return AOTH.db.general.ResizeStableIcon
                        end,
                        set = function(_, value)
                            
                            AOTH.db.general.ResizeStableIcon = value
                        
                        end,
                        width = "full",
                    },
                    MinimalMapIcons = {
                        name = L["SMALLER_MAP_ICONS"],
                        desc = "Enabling this option will shrink and set a basic tooltip to all other pins except the first location of the pet you are after. This requires you to reload your UI... You can do so by typing |cFF00FF00 /rl",
                        type = "toggle",
                        order = 5,
                        get = function()
                            
                            return AOTH.db.general.MinimalMapIcons
                        end,
                        set = function(_, value)
                            
                            AOTH.db.general.MinimalMapIcons = value
                        
                        end,
                        width = "full",
                    },
                }
            },
            Supporters = {
                order = 1,
                name = "Supporters",
                type = "group",
                desc = "Patreons of AOTH",
                args = {
                    Header = {
                        name = "Patreon Supporters",
                        desc = "",
                        type = "header",
                        order = 0,
                        
                        width = "full",
                    },
                    Patreons = {
                        name = "Tiana A\njenn k\nBrian M\nRockkat\nMark G\nJesse R\nBeth S\nJames G\nDaniel B\nCathy R\nVictoria S\nDreadswarm",
                        fontSize = "large",
                        type = "description",
                        order = 1,
                        
                        width = "full",
                    },
                    ContHeader = {
                        name = "Contributors",
                        desc = "",
                        type = "header",
                        order = 2,
                        
                        width = "full",
                    },
                    contributors = {
                        name = "Hayleqwyn [Code Assistance]\nJustDan [Pet Icons]",
                        fontSize = "large",
                        type = "description",
                        order = 3,
                        
                        width = "full",
                    },
                }
            },
        }
    }
    
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Aspect Of The Hunter", options)
    self.configFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Aspect Of The Hunter", "Aspect Of The Hunter");
end

AspectDB = {};



function AOTH:LoadDB()
    
    return AspectDB;

end

local addon = LibStub("AceGUI-3.0")


local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("AspectOfTheHunter", {
    type = "data source",
    text = "AspectOfTheHunter",
    icon = "Interface\\AddOns\\AspectOfTheHunter\\Icons\\mini_map_icon.blp",
})

local popup;
local active = false
MyModData = {}

function ldb.OnClick(self, button)
    
    local shift_key = IsShiftKeyDown()
    tinsert(UISpecialFrames, PetStableFrame:GetName())
    if button == "RightButton" then
        if (shift_key) then
            InterfaceOptionsFrame_OpenToCategory("Aspect Of The Hunter")InterfaceOptionsFrame_OpenToCategory("Aspect Of The Hunter")
        elseif (PetStableFrame:IsVisible()) then
            
            PetStableFrame:Hide()
        else
            PetStableFrame:Show()
        end
    
    else
        

        if not (active and popup) then
            
            popup = addon:Create("Frame")
            popup:SetTitle(UnitName("player") .. "'s Information")
            popup:SetStatusText("You're on version: " .. ADDON_VERSION)
            popup:SetCallback("OnClose", function(widget)
                addon:Release(widget)
                active = false
                if (links) then
                    links:Hide()
                
                end
            
            end)
            active = true
            popup:SetLayout("Flow")
            
            test = addon:Create("InlineGroup")
            test:SetTitle("TAMED PETS")
            
            test:SetLayout("Flow")
            popup:AddChild(test)
            
            scroll = addon:Create("ScrollFrame")
            scroll:SetHeight(350)
            scroll:SetFullWidth(true)
            scroll:SetLayout("Flow")
            scroll:SetScroll(1)
            
            test:AddChild(scroll)
            MyMod_OnLoad()
            LoadList(scroll)

            
            
            
            local announce = addon:Create("InteractiveLabel")
            announce:SetFontObject(SystemFont_Outline)
            announce:SetWidth(700)
            
            announce:SetText("|c00ffff00Keep up to date on discord at: |c0000ccff https://discord.gg/GzHEU5k |c00ffff00or on the socials @ravenclawthehunter")
            announce:SetCallback("OnClick", function()
                    
                    
                    if not (links:IsShown()) then
                        links:Show()
                        copyBox:Show()
                    end
            
            
            end)
            popup:AddChild(announce)
            PlaySound(6521, "master")
        
        else
            popup:Hide()
            PlaySound(799, "master")
        end
    
    
    
    end
end

MyModData = {}
function MyMod_OnLoad()
    
    if not (petlogDB == nil) then
        for i = 1, #petlogDB do
            MyModData[i] = petlogDB[i]
        end
    end
end

function LoadList(frame)
    
    for i = 1, #MyModData do
        local loggedPetItem = addon:Create("InteractiveLabel")
        loggedPetItem:SetWidth(280)
        
        loggedPetItem:SetFontObject(SystemFont_Outline)
        loggedPetItem:SetText(i .. ": " .. MyModData[i][2])
        loggedPetItem:SetCallback("OnEnter", function(widget)widget:SetColor(1, 1, 0) end)
        loggedPetItem:SetCallback("OnLeave", function(widget)widget:SetColor(1, 1, 1) end)
        
        frame:AddChild(loggedPetItem)
    end
end

local icon = LibStub("LibDBIcon-1.0")

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
    icon = LibStub("LibDBIcon-1.0", true)
    if not icon then return end
    if not AOTHLDBIconDB then AOTHLDBIconDB = {} end
    icon:Register(AddOnName, ldb, AOTHLDBIconDB)
end)
f:RegisterEvent("PLAYER_LOGIN")


function HunterInfo()
    
    HunterInfoPanel = CreateFrame("Frame", "InfoPanel", UIParent, "TooltipBorderedFrameTemplate")
    HunterInfoPanel:SetWidth(800)
    HunterInfoPanel:SetHeight(600)
    HunterInfoPanel:SetPoint("CENTER")
    HunterInfoPanel:SetMovable(false)
    HunterInfoPanel:SetResizable(false)
    HunterInfoPanel:SetFrameStrata("TOOLTIP")
    HunterInfoPanel:Hide()



end
