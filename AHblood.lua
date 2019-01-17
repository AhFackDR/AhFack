-- Unholy Death Knight for 8.1 by AhFack - 12/2018
-- Talents: 2 3 3 x x 3 1
-- Holding ALT will Grip current Target.
-- Holding SHIFT will Death and Decay on Mouse.

local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.deathknight
  local x = 0 -- counting seconds in resting
  local y = 0 -- counter for opener
  local z = 0 -- time in combat

local function combat()
local multit = dark_addon.settings.fetch('dr_example_multit')
local cds = dark_addon.settings.fetch('dr_example_cds')
local intpercent = dark_addon.settings.fetch('dr_example_interrupt')
local grip = dark_addon.settings.fetch('dr_example_grip')
local icefort = dark_addon.settings.fetch('dr_example_icefort.check')
local icepercent = dark_addon.settings.fetch('dr_example_icefort.spin', 50)
local antimagic = dark_addon.settings.fetch('dr_example_antimagic.check')
local antimagicpercent = dark_addon.settings.fetch('dr_example_antimagic.spin', 45)
local healthstonepercent = dark_addon.settings.fetch('dr_example_healthstone.spin', 35)
local healthstone = dark_addon.settings.fetch('dr_example_healthstone.check')
local ressally = dark_addon.settings.fetch('dr_example_pet.check')
local ds = dark_addon.settings.fetch('dr_example_ds.check')
local deathstrike = dark_addon.settings.fetch('dr_example_ds.spin', 70)
local vamp = dark_addon.settings.fetch('dr_example_vamp.check')
local vamppercent = dark_addon.settings.fetch('dr_example_vamp.spin', 60)
local dsaoe = dark_addon.settings.fetch('dr_example_dsaoe.check')
local deathstrikeaoe = dark_addon.settings.fetch('dr_example_dsaoe.spin', 70)
local massgrip = dark_addon.settings.fetch('dr_example_massgrip.check')
local dance = dark_addon.settings.fetch('dr_example_dance.check')
local taunt = dark_addon.settings.fetch('dr_example_taunt.check')

-- Experimental

    local AoE = 3
  

    local inRange = 0

      for i = 1, 40 do
            if UnitExists('nameplate' .. i) and IsSpellInRange('Heart Strike', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then
                inRange = inRange + 1
            end
        end

    -- print(inRange)


--------------
-- Defensives
--------------
  if icefort == true and -spell(SB.IceboundFortitude) == 0 and player.health.percent < icepercent then
      return cast(SB.IceboundFortitude)
  end
  if antimagic == true and -spell(SB.AntiMagicShell) == 0 and player.health.percent < antimagicpercent then 
      return cast(SB.AntiMagicShell)
  end
  if healthstone == true and player.health.percent < healthstonepercent and GetItemCount(5512) >= 1 and GetItemCooldown(5512) == 0 then
     macro('/use Healthstone')
  end
  if vamp == true and player.health.percent < vamppercent and -spell(SB.VampiricBlood) == 0 then
  	return cast(SB.VampiricBlood)
  end


------------
-- Utility
------------
	if grip == true and -spell(SB.DeathGrip) == 0 and modifier.control then
		return cast(SB.DeathGrip)
	end
	if massgrip == true and -spell(SB.GorefiendsGrasp) == 0 and modifier.alt then
		return cast(SB.GorefiendsGrasp)
	end
	if dance == true and -spell(SB.DancingRuneWeapon) == 0 then
		return cast(SB.DancingRuneWeapon)
	end
	if taunt == true and modifier.shift and -spell(SB.DarkCommand) == 0 then
		return cast(SB.DarkCommand)
	end


--------------
-- Interrupts
--------------

    if -spell(SB.MindFreeze, 'target') == 0 and target.interrupt(intpercent, false) then
      return cast(SB.MindFreeze, 'target')
    else
         if -spell(SB.Asphyxiate, 'target') == 0 and not -spell(SB.MindFreeze, 'target') == 0 and talent(3,3) and not lastcast(SB.MindFreeze) and target.interrupt(intpercent, false) then
           return cast(SB.Asphyxiate, 'target')
          end
   end

--------------
-- Cooldowns
--------------

	






-----------
-- Opener
-----------
 
  if target.alive and target.enemy and player.alive and not player.channeling() and target.distance < 8 then
    auto_attack()

--  if toggle('opener', false) and y ~= 99 then
--    if target.castable(SB.DarkCommand) and y == 0 then
 --     y = y + 1
 --     print ("Starting Opener")
--       return cast(SB.DarkCommand)
 --     end
--    if player.spell(SB.BloodDrinker).cooldown == 0 and talent(1,2) and player.power.runes.count >= 1 and y == 1 then 
--      return cast(SB.BloodDrinker)
--   end
--    if player.spell(SB.DancingRuneWeapon).cooldown == 0 and y == 1 then
--      return cast(SB.DancingRuneWeapon)
  --  end
--    if target.castable(SB.MarrowRend) and y == 1 and player.buff(SB.BoneShield).count < 6 then
 --     return cast(SB.MarrowRend)
--    end
--    if not target.debuff(SB.BloodPlague) and y == 1 and target.castable(SB.BloodBoil) then
--     return cast(SB.BloodBoil)
-- 	end
--    if target.debuff(SB.BloodPlague).exists and y == 1 and player.spell(SB.BloodBoil).cooldown == 0 then
 --     y = 99
 --     print ("Opener Done")
 --     return cast(SB.BloodBoil)
 --   end

 -- end


-----------------
-- Single Target
-----------------

	if player.health.percent < deathstrike and player.power.runicpower.actual >= 45 and player.spell(SB.DeathStrike).cooldown == 0 and inRange < AoE then
		return cast(SB.DeathStrike)
	end
  if player.power.runicpower.actual >= 100 and player.spell(SB.DeathStrike).cooldown == 0 and inRange < AoE then
    return cast(SB.DeathStrike)
  end
	if player.health.percent <= 60 and talent(1,2) and player.spell(SB.BloodDrinker).cooldown == 0 and inRange < AoE then
		return cast(SB.BloodDrinker)
	end
    if player.buff(SB.BoneShield).count < 2 and player.spell(SB.MarrowRend).cooldown == 0 and player.power.runes.count >= 2 and inRange > AoE then
      return cast(SB.MarrowRend)
    end
	if not target.debuff(SB.BloodPlague).exists and player.spell(SB.BloodBoil).cooldown == 0 and inRange < AoE then
		return cast(SB.BloodBoil)
	end
  if player.buff(SB.CrimsonScourge).up and player.spell(SB.DeathAndDecay).cooldown == 0 and inRange < AoE then
    return cast(SB.DeathAndDecay, 'player')
  end
	if player.spell(SB.BloodBoil).charges > 0 and inRange < AoE then
		return cast(SB.BloodBoil)
	end
	if player.power.runes.count >= 1 and player.spell(SB.HeartStrike).cooldown == 0 and inRange < AoE then
		return cast(SB.HeartStrike)
	end



  ---------------
  -- Multitarget
  ---------------

    if cds == true and player.spell(SB.DancingRuneWeapon).cooldown == 0 and inRange > AoE then
      return cast(SB.DancingRuneWeapon)
    end
  	if player.health.percent < deathstrikeaoe and player.power.runicpower.actual >= 45 and player.spell(SB.DeathStrike).cooldown == 0 and inRange > AoE then
  		return cast(SB.DeathStrike)
  	end

        if not -buff(SB.BoneStorm) and player.power.runicpower.actual >= 80 and player.spell(SB.BoneStorm).cooldown == 0 and talent(7,3) and inRange > AoE then
      return cast(SB.BoneStorm)
    end

    if player.power.runicpower.actual >= 100 and player.spell(SB.DeathStrike).cooldown == 0 and inRange > AoE then
      return cast(SB.DeathStrike)
    end
    if player.buff(SB.CrimsonScourge).up and player.spell(SB.DeathAndDecay).cooldown == 0 and inRange > AoE then
      return cast(SB.DeathAndDecay, 'player')
    end
    if player.spell(SB.BloodBoil).charges > 0 and inRange > AoE then
      return cast(SB.BloodBoil)
    end
  	if player.buff(SB.BoneShield).count < 2 and player.spell(SB.MarrowRend).cooldown == 0 and player.power.runes.count >= 2 and inRange > AoE then
  		return cast(SB.MarrowRend)
  	end
  	if -buff(SB.DancingRuneWeapon) and player.spell(SB.BloodBoil).charges > 0 and inRange > AoE then
  		return cast(SB.BloodBoil)
  	end
  	if player.health.percent < 75 and player.spell(SB.BloodDrinker).cooldown == 0 and inRange > AoE and talent(1,2) then
	   	return cast(SB.BloodDrinker)
	  end
  	if player.spell(SB.DeathAndDecay).cooldown == 0 and player.power.runes.count >= 1 and inRange > AoE then
  		return cast(SB.DeathAndDecay, 'player')
  	end
  	if player.power.runes.count >= 1 and inRange > AoE and player.spell(SB.HeartStrike).cooldown == 0 then
  		return cast(SB.HeartStrike)
  	end







end
end

  local function resting()
  

  -- Put great stuff here to do when your out of combat
end



local function interface()
   local example = {
    key = 'dr_example',
    title =                     'AhFack Rotations - Death Knight Blood',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = '               Blood Settings' },
      { type = 'text', text = 'Tank your worst fears, with this AH!Rotation' },
      { type = 'rule' },   
      { type = 'text', text = 'Class Specific' },
   --   { key = 'multit', type = 'checkbox', text = 'Multitarget', desc = 'Use Multitarget Rotation in Multitarget' },
      { key = 'cds', type = 'checkbox', text = 'Cooldowns', desc = 'Use various CDs in Combat' },
      { key = 'interrupt', type = 'spinner', text = 'Interupt %', desc = 'What % you will be interupting at', default_spin = 60, min = 10, max = 100, step = 5 },
      { type = 'rule' },   

      { type = 'text', text = 'Defensives' },
      { key = 'icefort', type = 'checkspin', text = 'Icebound Fortitude at HP%', desc = 'What % you will be using Icebound Fortitude at', default_spin = 50, min = 10, max = 100, step = 5 },
      { key = 'antimagic', type = 'checkspin', text = 'Anti-Magic Shell HP%', desc = 'What % you will be using Anti-Magic Shell at', default_spin = 45, min = 10, max = 100, step = 5 },
      { key = 'vamp', type = 'checkspin', text = 'Vampiric Blood HP%', desc = 'What % you will be using Vampiric Blood at', default_spin = 60, min = 10, max = 100, step = 5 },
      { type = 'rule' },

      { type = 'text', text = 'Utility' },
      { key = 'grip', type = 'checkbox', text = 'Death Grip', desc = 'Grip your current target, holding down Control' },
      { key = 'ds', type = 'checkspin', text = 'Death Strike ST', desc = 'What %HP you will use Death Strike Single Target', default_spin = 70, min = 10, max = 100, step = 5 },
      { key = 'dsaoe', type = 'checkspin', text = 'Death Strike MT', desc = 'What %HP you will use Death Strike MutliTarget', default_spin = 70, min = 10, max = 100, step = 5 },
      { key = 'taunt', type = 'checkbox', text = 'Taunt', desc = 'Taunt your current target, holding down Shift' },
      { key = 'massgrip', type = 'checkbox', text = 'Gorefiends Grasp', desc = 'Grip the whole group, holding down alt' },


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
  spec = dark_addon.rotation.classes.deathknight.blood,
  name = 'AHblood',
  label = 'AhFack Rotations',
  combat = combat,
  resting = resting,
  interface = interface
})