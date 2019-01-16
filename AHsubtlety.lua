-- Subtlety Rogue for 8.1 by AhFack - 12/2018
-- Talents: Everything is Usable. 
-- Mythic+ I'd recommend following: 2-3-2-2-2-3-2
-- Raiding I'd recommend following: 2-3-3-2-2-3-1
-- Holding 
-- Holding 



local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.rogue
  local lftime = 0 -- Dungeon / LFG Queue Timers
  local x = 0 -- Counting seconds in resting
  local y = 0 -- Counter for opener
  local z = 0 -- Time in Combat



-- Locals

local function combat()
local multit = dark_addon.settings.fetch('dr_example_multit')
local cds = dark_addon.settings.fetch('dr_example_cds')
local vanish = dark_addon.settings.fetch('dr_example_vanish.check')
local vanishpercent = dark_addon.settings.fetch('dr_example_vanish.spin', 10)
local shadow = dark_addon.settings.fetch('dr_example_shadow.check')
local shadowpercent = dark_addon.settings.fetch('dr_example_shadow.spin', 20)
local intpercent = dark_addon.settings.fetch('dr_example_interrupt', 60)
local tott = dark_addon.settings.fetch('dr_example_tott')
local vial = dark_addon.settings.fetch('dr_example_vial.check')
local vialpercent = dark_addon.settings.fetch('dr_example_vial.spin', 50)
local feint = dark_addon.settings.fetch('dr_example_feint.check')
local feintpercent = dark_addon.settings.fetch('dr_example_feint.spin', 50)
local healthstonepercent = dark_addon.settings.fetch('dr_example_healthstone.spin', 35)
local healthstone = dark_addon.settings.fetch('dr_example_healthstone.check')


-- Experimental
    local AoE = 3
  

    local inRange = 0

      for i = 1, 40 do
            if UnitExists('nameplate' .. i) and IsSpellInRange('Backstab', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then
                inRange = inRange + 1
            end
        end



-- print(inRange)

--------------
-- Defensives
--------------
  if vanish == true and -spell(SB.Vanish) == 0 and player.health.percent < vanishpercent and vanish == true then
      return cast(SB.Vanish)
  end
  if shadow == true and -spell(SB.CloakOfShadows) == 0 and player.health.percent < shadowpercent and shadow == true then 
      return cast(SB.CloakOfShadows)
  end
  if vial == true and -spell(SB.CrimsonVial) == 0 and player.health.percent < vialpercent and vial == true and player.power.energy.actual >= 30 then 
      return cast(SB.CrimsonVial)
  end
  if feint == true and -spell(SB.Feint) == 0 and player.health.percent < feintpercent and feint == true and player.power.energy.actual >= 35 then 
      return cast(SB.Feint)
  end
  if healthstone == true and player.health.percent < healthstonepercent and GetItemCount(5512) >= 1 and GetItemCooldown(5512) == 0 then
     macro('/use Healthstone')
  end

------------
-- Utility
------------

  if tott == true and castable(SB.TricksOfTheTrade) then
    return RunMacro("Aggro")
  end


---------------
-- Interrupts
---------------

   if target.alive and target.enemy and player.alive and not player.channeling() and target.distance < 8 then
    auto_attack()

    if -spell(SB.Kick, 'target') == 0 and target.interrupt(intpercent, false) then
      return cast(SB.Kick, 'target')
      else
            if -spell(SB.Blind, 'target') == 0 and not -spell(SB.Kick, 'target') == 0 and not lastcast(SB.Kick) and target.interrupt(intpercent, false) then
              return cast(SB.Blind, 'target')
            end
    end


-------------
-- Cooldowns
-------------

   if cds == true and -spell(SB.ShadowBlades) == 0 then
      return cast(SB.ShadowBlades, 'target')
    end




    

-----------
-- Opener
-----------
  if toggle('opener', false) and y ~= 99 then
    if -spell(SB.Backstab) == 0 and y == 0 and player.power.energy.actual >= 28 then
      y = y + 1
      print ("Starting Opener")
       return cast(SB.Backstab)
      end
    if player.spell(SB.SymbolsOfDeath).cooldown == 0 and y == 1 and player.power.energy.actual <= 65 then 
      return cast(SB.SymbolsOfDeath)
   end
    if talent(3,3) and player.spell(SB.MarkedforDeath).cooldown == 0 and y == 1 and player.power.combopoints.actual <= 2 then
      return cast(SB.MarkedforDeath)
    end
    if -spell(SB.Nightblade) == 0 and y == 1 and (not target.debuff(SB.Nightblade).exists or target.debuff(SB.Nightblade).remains < 4) then
      return cast(SB.Nightblade)
    end
   if -spell(SB.ShadowBlades) == 0 and y == 1 then
     return cast(SB.ShadowBlades)
    end
    if talent(7,2) and player.power.energy.actual >= 30 and player.power.combopoints.actual >= 5 and y == 1 and -spell(SB.SecretTechnique) == 0 then
     return cast(SB.SecretTechnique)
    else
      if player.power.energy.actual >= 35 and player.power.combopoints.actual >= 4 and -spell(SB.Eviscerate) == 0 and y == 1 then
        return cast(SB.Eviscerate)
      end
    end
    if talent(7,2) and player.power.energy.actual >= 35 and player.power.combopoints.actual >= 4 and -spell(SB.SecretTechnique) == 1 then
    	return cast(SB.Eviscerate)
    end
    if spell(SB.ShadowDance).fractionalcharges >= 1.75 and not -buff(SB.ShadowDance) and y == 1 then
      return cast(SB.ShadowDance)
    end
    if -player.buff(SB.ShadowDance) and -spell(SB.ShadowStrike) == 0 and player.power.energy.actual >= 40 and y == 1 then 
     return cast(SB.ShadowStrike)
    end
    if -spell(SB.Backstab) == 0 and player.power.energy.actual >= 35 and y == 1 then
      return cast(SB.Backstab)
    end
    if player.buff(SB.ShadowBlades).down and y == 1 and -spell(SB.ShadowBlades) == 1 then
      y = 99
      print ("Opener Done")
      return 
    end

  end


    




---------------------
-- Standard Rotation
---------------------

    if -buff(SB.Stealth) and -spell(SB.ShadowStrike) == 0 and player.power.energy.actual >= 40 then 
      return cast(SB.ShadowStrike)
    end
    if not -target.debuff(SB.Nightblade) and player.power.combopoints.actual >= 3 and player.power.energy.actual >= 20 then
     return cast(SB.Nightblade, 'target')
    end
    if target.debuff(SB.Nightblade).remains < 4 and player.power.combopoints.actual >= 3 and player.power.energy.actual >= 20 then
      return cast(SB.Nightblade)
    end
    if inRange >= AoE and talent(7,3) and player.power.energy.actual >= 60 and player.spell(SB.ShurikenTornado).cooldown == 0 then 
      return cast(SB.ShurikenTornado)
    end
    if talent(7,2) and talent(3,2) and -spell(SB.SecretTechnique) == 0 and player.power.energy.actual >= 24 and player.power.combopoints.actual >= 6 then
        return cast(SB.SecretTechnique)
       else
      if talent(7,2) and talent(3,1) or talent (3,3) and -spell(SB.SecretTechnique) == 0 and player.power.energy.actual >= 24 and player.power.combopoints.actual >= 4 and not talent(3,2) then
      return cast(SB.SecretTechnique)
    end
  end
    if talent(3,2) and -spell(SB.Eviscerate) == 0 and player.power.energy.actual >= 35 and player.power.combopoints.actual >= 5 then
      return cast(SB.Eviscerate)
    else 
     if talent(3,1) or talent(3,3) and player.power.combopoints.actual >= 4 and -spell(SB.Eviscerate) == 0 and player.power.energy.actual >= 35 and not talent(3,2) then
      return cast(SB.Eviscerate)
    end
    end
    if spell(SB.ShadowDance).fractionalcharges >= 1.75 and not -buff(SB.ShadowDance) and inRange < AoE then
      return cast(SB.ShadowDance)
    end
    if -buff(SB.ShadowDance) and -spell(SB.ShadowStrike) == 0 and player.power.energy.actual >= 40 and inRange < AoE then 
      return cast(SB.ShadowStrike)
    end
    if -spell(SB.SymbolsOfDeath) == 0 and player.power.energy.actual <= 65 then 
      return cast(SB.SymbolsOfDeath)
    end
    if  -spell(SB.MarkedforDeath) == 0 and player.power.combopoints.actual <=  2 and talent(3,3) then
      return cast(SB.MarkedforDeath)
    end
    if -spell(SB.ShurikenStorm) == 0 and player.power.energy.actual >= 28 and inRange >= 2 then
      return cast(SB.ShurikenStorm, 'target')
    end

    if -spell(SB.Backstab) == 0 and player.power.energy.actual >= 28 and inRange < 2 then
      return cast(SB.Backstab, 'target')
    end
   






end
end


local function resting()
  
  if not -buff(SB.Stealth) and -spell(SB.Stealth) == 0 and player.alive then
  	y = 0
    return cast(SB.Stealth)
  end

-- Auto Join
local lfg = GetLFGProposal();
local hasData = GetLFGQueueStats(LE_LFG_CATEGORY_LFD);
local hasData2 = GetLFGQueueStats(LE_LFG_CATEGORY_LFR);
local hasData3 = GetLFGQueueStats(LE_LFG_CATEGORY_RF);
local hasData4 = GetLFGQueueStats(LE_LFG_CATEGORY_SCENARIO);
local hasData5 = GetLFGQueueStats(LE_LFG_CATEGORY_FLEXRAID);
local hasData6 = GetLFGQueueStats(LE_LFG_CATEGORY_WORLDPVP);
local bgstatus = GetBattlefieldStatus(1);
local autoaccept = dark_addon.settings.fetch('dr_example_autoaccept.check')

-- print (bgstatus)
if hasData == true or hasData2 == true or hasData4 == true or hasData5 == true or hasData6 == true or bgstatus == "queued" then
 SetCVar ("Sound_EnableSoundWhenGameIsInBG",1)
elseif hasdata == nil or hasData2 == nil or hasData3 == nil or hasData4 == nil or hasData5 == nil or hasData6 == nil or bgstatus == "none" then
 SetCVar ("Sound_EnableSoundWhenGameIsInBG",0)
end

if lfg == true or bgstatus == "confirm" and autoaccept == true then
  PlaySound(SOUNDKIT.IG_PLAYER_INVITE, "Dialog", false);
  lftime = lftime + 1
end

if lftime >=math.random(20,35) and autoaccept == true then
  SetCVar ("Sound_EnableSoundWhenGameIsInBG",0)
  macro('/click LFGDungeonReadyDialogEnterDungeonButton')
  lftime = 0
end


  -- Put great stuff here to do when your out of combat
end



local function interface()
   local example = {
    key = 'dr_example',
    title =                     'AhFack Rotations - Rogue Subtlety',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = '               Subtlety Settings' },
      { type = 'text', text = 'Hack and Slash your enemies with this wonderful Rotation!' },
      { type = 'rule' },   
      { type = 'text', text = 'Class Specific' },
      { key = 'cds', type = 'checkbox', text = 'Cooldowns', desc = 'Use Shadow Blades in Combat' },
      { key = 'interrupt', type = 'spinner', text = 'Interupt %', desc = 'What % you will be interupting at', default_spin = 60, min = 10, max = 100, step = 5 },
      { type = 'rule' },   

      { type = 'text', text = 'Defensives' },
      { key = 'vanish', type = 'checkspin', text = 'Vanish at HP%', desc = 'What % you will be using Vanish at', default_spin = 10, min = 10, max = 100, step = 5 },
      { key = 'shadow', type = 'checkspin', text = 'Cloak of Shadows HP%', desc = 'What % you will be using Cloak of Shadows at', default_spin = 20, min = 10, max = 100, step = 5 },
      { key = 'vial', type = 'checkspin', text = 'Vial of Crimson HP%', desc = 'What % you will be using Vial of Crimson at', default_spin = 50, min = 10, max = 100, step = 5 },
      { key = 'feint', type = 'checkspin', text = 'Feint at HP%', desc = 'What % you will be using Feint at', default_spin = 50, min = 10, max = 100, step = 5 },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone at HP%', desc = 'What % you will be using Healthstones at', default_spin = 35, min = 10, max = 100, step = 5 },
      { type = 'rule' },

      { type = 'text', text = 'Utility' },
      { key = 'tott', type = 'checkbox', text = 'Tricks of the Trade', desc = 'Use Macro to cast TotT on Focus/Tank' },
      { key = 'autoaccept', type = 'checkbox', text = 'Auto Accept Queue', desc = 'Auto Accepts any Queue for BGs and DGs'},
      


  }
  } 
      configWindow = dark_addon.interface.builder.buildGUI(example) 
   

       dark_addon.interface.buttons.add_toggle({
        name = 'opener',
        label = 'Opener',
        font = 'dark_addon_icon',
        on = {
            label = dark_addon.interface.icon('bars'),
            color = dark_addon.interface.color.green,
            color2 = dark_addon.interface.color.dark_green
        },
        off = {
            label = dark_addon.interface.icon('bars'),
            color = dark_addon.interface.color.grey,
            color2 = dark_addon.interface.color.dark_grey
        }
    })


    dark_addon.interface.buttons.add_toggle({
    name = 'settings',
    label = 'Rotation Settings',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('cog'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    },
    off = {
      label = dark_addon.interface.icon('cog'),
      color = dark_addon.interface.color.blue,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.blue, 0.7)

    },
    callback = function(self)
      if configWindow.parent:IsShown() then
          configWindow.parent:Hide()
      else
          
          configWindow.parent:Show()
      end
    end
  })
end
dark_addon.rotation.register({
  spec = dark_addon.rotation.classes.rogue.subtlety,
  name = 'AHsubtlety',
  label = 'AhFack Rotations',
  combat = combat,
  resting = resting,
  interface = interface
})