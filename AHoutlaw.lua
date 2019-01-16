-- Outlaw Rogue for 8.1 by AhFack - 2019
-- Talents: Everything is Usable. 
-- Mythic+ I'd recommend following: 
-- Raiding I'd recommend following: 
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
local vanishpercent = dark_addon.settings.fetch('dr_example_vanish.spin')
local shadow = dark_addon.settings.fetch('dr_example_shadow.check')
local shadowpercent = dark_addon.settings.fetch('dr_example_shadow.spin')
local intpercent = dark_addon.settings.fetch('dr_example_interrupt')
local tott = dark_addon.settings.fetch('dr_example_tott')
local vial = dark_addon.settings.fetch('dr_example_vial.check')
local vialpercent = dark_addon.settings.fetch('dr_example_vial.spin')
local feint = dark_addon.settings.fetch('dr_example_feint.check')
local feintpercent = dark_addon.settings.fetch('dr_example_feint.spin')
local healthstonepercent = dark_addon.settings.fetch('dr_example_healthstone.spin')
local healthstone = dark_addon.settings.fetch('dr_example_healthstone.check')


-- Experimental
    local AoE = 2
  

    local inRange = 0

      for i = 1, 40 do
            if UnitExists('nameplate' .. i) and IsSpellInRange('Sinister Strike', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then
                inRange = inRange + 1
            end
        end


print (rollthebonestotal)
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
        if -spell(SB.KidneyShot) == 0 and modifier.control and player.power.energy.actual >= 25 and player.power.combopoints.actual >= 4 then
      return cast(SB.KidneyShot)
    end



-------------
-- Cooldowns
-------------

   if cds == true and -spell(SB.AdrenalineRush) == 0 and player.power.energy.actual < 80 then
      return cast(SB.AdrenalineRush)
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

    if player.buff(SB.ShadowBlades).down and y == 1 and -spell(SB.ShadowBlades) == 1 then
      y = 99
      print ("Opener Done")
      return 
    end

  end



------------------------
-- Roll the Bones Logic 
-----------------------

  if -player.buff(SB.RuthlessPrecision) then rpb = 1 else rpb = 0 end
  if -player.buff(SB.GrandMelee) then gmb = 1 else gmb = 0 end
  if -player.buff(SB.Broadside) then bsb = 1 else bsb = 0 end
  if -player.buff(SB.SkullAndCrossbones) then scb = 1 else scb = 0 end
  if -player.buff(SB.BuriedTreasure) then btb = 1 else btb = 0 end
  if -player.buff(SB.TrueBearings) then scb = 1 else scb = 0 end
  rollthebonestotal = rpb + gmb + bsb + scb + btb + scb

    if -spell(SB.RollTheBones) == 0 and rollthebonestotal < 2 and player.power.combopoints.actual >= 3 and not -player.buff(SB.GrandMelee) and not -player.buff(SB.RuthlessPrecision) then
      print (rollthebonestotal)
      rpb = 0
      gmb = 0
      bsb = 0
      scb = 0 
      btb = 0
      scb = 0
    return cast(SB.RollTheBones)
  end

---------------------
-- Standard Rotation
---------------------

  if player.buff(SB.Opportunity).up and -spell(SB.PistolShot) == 0 and player.power.combopoints.actual <= 4 then
    return cast(SB.PistolShot)
  end
  if player.buff(SB.RuthlessPrecision).up and player.power.energy.actual >= 25 and player.power.combopoints.actual >= 5 and -spell(SB.BetweenTheEyes) == 0 then
    return cast(SB.BetweenTheEyes)
  end
  if talent(6,3) and player.power.energy.actual >= 25 and player.power.combopoints.actual >= 5 and -spell(SB.SliceAndDice) == 0 and not -buff(SB.SliceAndDice) then
    return cast(SB.SliceAndDice)
  end
--  if player.buff(SB.RuthlessPrecision).down or player.buff(SB.GrandMelee).down and not player.buff(SB.RuthlessPrecision).up or player.buff(SB.GrandMelee).up and player.power.energy.actual >= 25 and player.power.combopoints.actual >= 4 then
  --  return cast(SB.RollTheBones)
 -- end
-- if player.buff(SB.RuthlessPrecision).down and player.buff(SB.GrandMelee).down and not player.buff(SB.RuthlessPrecision).exists and not player.buff(SB.GrandMelee).exists and player.power.energy.actual >= 25 and player.power.combopoints.actual >= 4 then
  --  return cast(SB.RollTheBones)
  -- end
  if player.power.energy.actual >= 35 and player.power.combopoints.actual >= 5 and -spell(SB.Dispatch) == 0 then
    return cast(SB.Dispatch)
  end
  if cds == true and -spell(SB.AdrenalineRush) == 0 and player.power.energy.actual < 80 then
    return cast(SB.AdrenalineRush)
  end
  if -spell(SB.KillingSpree) == 0 and player.buff(SB.BladeFlurry).up and inRange >= AoE and not player.buff(SB.AdrenalineRush).exists and talent(7,3) then
    return cast(SB.KillingSpree)
  end
  if -spell(SB.BladeFlurry) == 0 and player.buff(SB.BladeFlurry).down and inRange >= AoE then 
    return cast(SB.BladeFlurry)
  end
  if inRange < AoE and not -buff(SB.AdrenalineRush) and -spell(SB.KillingSpree) and talent(7,3) and player.power.energy.actual < 30 then
    return cast(SB.KillingSpree)
  end
  if talent(7,2) and -spell(SB.BladeRush) == 0 and player.power.energy.actual < 80 then
    return cast(SB.BladeRush)
  end
  if player.power.energy.actual >= 60 and -spell(SB.Vanish) == 0 and -spell(SB.Ambush) == 0 then
    return cast(SB.Vanish)
  end
  if player.power.energy.actual >= 45 and -spell(SB.SinisterStrike) == 0 then
    return cast(SB.SinisterStrike)
  end








end
end


local function resting()

  if lastcast(SB.Vanish) and -spell(SB.Ambush) == 0 then
    return cast(SB.Ambush)
  end
  
  if player.buff(SB.Stealth).down and -spell(SB.Stealth) == 0 and player.alive then
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
      { key = 'interrupt', type = 'spinner', text = 'Interupt %', desc = 'What % you will be interupting at', min = 10, max = 100, step = 5 },
      { type = 'rule' },   

      { type = 'text', text = 'Defensives' },
      { key = 'vanish', type = 'checkspin', text = 'Vanish at HP%', desc = 'What % you will be using Vanish at', min = 10, max = 100, step = 5 },
      { key = 'shadow', type = 'checkspin', text = 'Cloak of Shadows HP%', desc = 'What % you will be using Cloak of Shadows at', min = 10, max = 100, step = 5 },
      { key = 'vial', type = 'checkspin', text = 'Vial of Crimson HP%', desc = 'What % you will be using Vial of Crimson at', min = 10, max = 100, step = 5 },
      { key = 'feint', type = 'checkspin', text = 'Feint at HP%', desc = 'What % you will be using Feint at', min = 10, max = 100, step = 5 },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone at HP%', desc = 'What % you will be using Healthstones at', min = 10, max = 100, step = 5 },
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
  spec = dark_addon.rotation.classes.rogue.outlaw,
  name = 'AHoutlaw',
  label = 'AhFack Rotations',
  combat = combat,
  resting = resting,
  interface = interface
})