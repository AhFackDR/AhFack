-- AhFack Rotations, Rogue Subtlety -- PvE
-- Functions: Auto-Queue Accepter, Auto-Stealth, Auto-Poison. 
-- Modifiers: 
		-- CTRL = Kidney Shot at 4 Points. I'd suggest using this in High M+ quite frequently.
-- Macros: 
-- Suggested Talents:
	-- Mythic+ - 2-2-1-x-x-3-1
	-- Raiding - 2-2-1-x-x-2-1
-- 
--
--



local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.rogue
  local lftime = 0 -- Dungeon / LFG Queue Timers
  local x = 0 -- Counting seconds in resting
  local y = 0 -- Counter for opener
  local z = 0 -- Time in Combat
  local v = 0 -- Smart Exsanguinate

----------
-- Locals
----------

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
local exsanguinate = dark_addon.settings.fetch('dr_example_exsanguinate.check')

---------------
-- Experimental
---------------


    local AoE = 3
  

    local inRange = 0

      for i = 1, 40 do
            if UnitExists('nameplate' .. i) and IsSpellInRange('Mutilate', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then
                inRange = inRange + 1
            end
        end




-------------
-- Defensives
-------------

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


-------------
-- Interrupts
-------------

   if target.alive and target.enemy and player.alive and not player.channeling() and target.distance < 8 then
    auto_attack()
-- print (v)
-- print (z)
--print (x)
--print (y) 

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

   if cds == true and -spell(SB.Vendetta) == 0 then
      return cast(SB.Vendetta, 'target')
    end

-----------
-- Utility
-----------

  if tott == true and -spell(SB.TricksOfTheTrade) == 0 then
    return RunMacro("Aggro")
  end

---------------------
-- Opener Toxic Blade
----------------------

-- if toggle('opener', false) and talent(6,2) and y ~= 99 then
 --   if target.castable(SB.Garrote) and y == 0 and player.power.energy.actual >= 45 then
  --    y = y + 1
  --    print ("Starting Opener")
   --    return cast(SB.Garrote)
  --    end
 --	if castable(SB.Rupture) and player.power.energy.actual >= 25 then
 --		cast(SB.Rupture)
 	-- end
 --	if castable(SB.Garrote) and player.power.energy.actual >= 45 then
 --		cast(SB.Garrote)
 --	end
 --	if castable(SB.Vendetta) then
 --	 	cast(SB.Vendetta)
--	end
 --	if castable(SB.ToxicBlade) and player.power.energy.actual >= 20 then
 --		cast(SB.Toxicblade)
 --	end
 --	if castable
--
  --  if y == 1 and player.spell(SB.Vendetta).cooldown > 0 then
 --     y = 99
 --     print ("Opener Done")
  --    return 
-- end
 -- end




-----------------------
 -- Smart Exsanguinate
 ----------------------
if talent (6,3) and v ~= 99 and -spell(SB.Exsanguinate) == 0 and exsanguinate == true then

	if -spell(SB.Exsanguinate) == 0 and -spell(SB.Rupture) == 0 and player.power.combopoints.actual >= 4 and target.debuff(SB.Rupture).remains < 6 and player.power.energy.actual >= 25 and v == 0 then
		v = v + 1
		print ("EXSANGUINATE START")
		return cast(SB.Rupture)
	end
	if -spell(SB.Exsanguinate) == 0 and -spell(SB.Garrote) == 0 and target.debuff(SB.Garrote).remains < 5.4 and player.power.energy.actual >= 45 and v == 1 then
		return cast(SB.Garrote)
	end
	if -spell(SB.Exsanguinate) == 0 and target.debuff(SB.Garrote).remains > 15 and target.debuff(SB.Rupture).remains > 25 and v == 1 then
		v = 99
		print ("EXSANGUINATE DONE")
		return cast(Exsanguinate)
	end

end




---------------------
-- Exsanguinate Build
---------------------
if talent(6,3) and exsanguinate == true then

   if not target.debuff(SB.Rupture).exists and player.power.combopoints.actual >= 4 and player.power.energy.actual >= 25 and not lastcast(SB.Exsanguinate) then
   	v = 0
     return cast(SB.Rupture, 'target')
    end
   if not target.debuff(SB.Garrote).exists and -spell(SB.Garrote) == 0 and player.power.combopoints.actual <= 4 and player.power.energy.actual >= 45 and not lastcast(SB.Exsanguinate) then
   	v = 0
   	return cast(SB.Garrote)
   end
   if target.debuff(SB.Rupture).remains < 2 and player.power.combopoints.actual >= 4 and player.power.energy.actual >= 25 and v == 0 and -spell(SB.Rupture) == 0 then
   	return cast(SB.Rupture)
   end
   if target.debuff(SB.Garrote).remains < 5.4 and player.power.energy.actual >= 45 and v == 0 and -spell(SB.Garrote) == 0 then
   	return cast(SB.Garrote)
   end

   if not -buff(SB.Subterfuge) and -spell(SB.Vanish) == 0 and player.power.energy.actual >= 45 and -spell(SB.Garrote) == 0 and target.debuff(SB.Garrote).remains < 5.4 then 
   	return cast(SB.Vanish)
   end
   if -buff(SB.Subterfuge) and player.power.energy.actual >= 45 and -spell(SB.Garrote) == 0 and target.debuff(SB.Garrote).remains < 5.4 then
   	return cast(SB.Garrote)
   end
--   if target.debuff(SB.Rupture).remains >= 20 and target.debuff(SB.Garrote).remains >= 10 and -spell(SB.Exsanguinate) == 0 and player.power.energy.actual >= 25 then
--   	return cast(SB.Exsanguinate)
--   end
   if talent(7,3) and player.power.energy.actual >= 35 and not -target.debuff(SB.CrimsonTempest) and player.power.combopoints >= 4 and -spell(SB.CrimsonTempest) == 0 then
   	return cast(SB.CrimsonTempest)
   end
   if -spell(SB.Envenom) == 0 and player.power.combopoints.actual >= 4 and player.power.energy.actual >= 35 then
   	return cast(SB.Envenom) 
   end
   if -spell(SB.FanOfKnives) == 0 and player.power.energy.actual >= 35 and inRange >= 4 then
   	return cast(SB.FanOfKnives)
   end
   if -spell(SB.Mutilate) == 0 and player.power.energy.actual >= 50 and inRange <= 3 then
   	return cast(SB.Mutilate)
   end



end


---------------------
-- Toxic Blade Build
---------------------
if talent(6,2) then

	  if player.buff(SB.Stealth).up and player.spell(SB.Garrote).cooldown == 0 and player.power.energy.actual >= 45 then 
      return cast(SB.Garrote)
    end
   if target.debuff(SB.Rupture).down and player.power.combopoints.actual >= 4 and player.power.energy.actual >= 25 then
     return cast(SB.Rupture, 'target')
    end
   if target.debuff(SB.Garrote).down and player.power.combopoints.actual <= 4 and player.power.energy.actual >= 45 and -spell(SB.Garrote) == 0 then
   	return cast(SB.Garrote)
   end
   if player.buff(SB.Subterfuge).down and -spell(SB.Vanish) == 0 and player.power.energy.actual >= 45 and -spell(SB.Garrote) == 0 and target.debuff(SB.Garrote).remains <= 5.4 then 
   	return cast(SB.Vanish)
   end
   if player.buff(SB.Subterfuge).up and player.power.energy.actual >= 45 and -spell(SB.Garrote) == 0 and target.debuff(SB.Garrote).remains <= 5 then
   	return cast(SB.Garrote)
   end
     if target.debuff(SB.Rupture).remains < 2 and player.power.combopoints.actual >= 4 and player.power.energy.actual >= 25 then
   	return cast(SB.Rupture)
   end
   if target.debuff(SB.Garrote).remains < 5 and player.power.energy.actual >= 45 and -spell(SB.Garrote) == 0 then
   	return cast(SB.Garrote)
   end
   if -spell(SB.ToxicBlade) == 0 and player.power.energy.actual >= 20 then
   	return cast(SB.ToxicBlade)
   end
   if talent(7,3) and player.power.energy.actual >= 35 and target.debuff(SB.CrimsonTempest).down and player.power.combopoints >= 4 and -spell(SB.CrimsonTempest) == 0 then
   	return cast(SB.CrimsonTempest)
   end
   if -spell(SB.Envenom) == 0 and player.power.combopoints.actual >= 4 and player.power.energy.actual >= 35 then
   	return cast(SB.Envenom) 
   end
   if -spell(SB.FanOfKnives) == 0 and player.power.energy.actual >= 35 and inRange > AoE then
   	return cast(SB.FanOfKnives)
   end
   if -spell(SB.Mutilate) == 0 and player.power.energy.actual >= 50 and inRange <= AoE then
   	return cast(SB.Mutilate)
   end



end
end
end


local function resting()
--print (v)
-- print (z)
--print (x)
--print (y)
 
 	if lastcast(SB.Vanish) and -spell(SB.Garrote) == 0 and player.power.energy.actual >= 45 then
 		return cast(SB.Garrote, 'target')
 	end

  
  if not -player.buff(SB.Stealth) and player.spell(SB.Stealth).cooldown == 0 and player.alive then
  	y = 0
    return cast(SB.Stealth)
  end

  if player.buff(SB.DeadlyPoison).down and -spell(SB.DeadlyPoison) == 0 and player.alive then
      return cast(SB.DeadlyPoison)
  end
  if player.buff(SB.CripplingPoison).down and -spell(SB.CripplingPoison) == 0 and player.alive then
      return cast(SB.CripplingPoison)
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
    title =                     'AhFack Rotations - Rogue Assassination',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = '               Assassination Settings' },
      { type = 'text', text = 'Poison and Bleed your enemies with this wonderful Rotation!' },
      { type = 'rule' },   
      { type = 'text', text = 'Class Specific' },
      { key = 'cds', type = 'checkbox', text = 'Cooldowns', desc = 'Use Vendetta in Combat' },
      { key = 'interrupt', type = 'spinner', text = 'Interupt %', desc = 'What % you will be interupting at', min = 10, max = 100, step = 5 },
      { key = 'exsanguinate', type = 'checkbox', text = 'Exsanguinate Talented', desc = 'Check if you have Exsanguinate Talented.'},
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
  spec = dark_addon.rotation.classes.rogue.assassination,
  name = 'AHassassination',
  label = 'AhFack Rotations',
  combat = combat,
  resting = resting,
  interface = interface
})