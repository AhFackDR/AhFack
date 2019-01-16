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
local army = dark_addon.settings.fetch('dr_example_army.check')
local intpercent = dark_addon.settings.fetch('dr_example_interrupt', 60)
local grip = dark_addon.settings.fetch('dr_example_grip')
local icefort = dark_addon.settings.fetch('dr_example_icefort.check')
local icefortperc = dark_addon.settings.fetch('dr_example_icefort.spin', 50)
local antimagic = dark_addon.settings.fetch('dr_example_antimagic.check')
local antimagicperc = dark_addon.settings.fetch('dr_example_antimagic.spin', 40)
local healthstonepercent = dark_addon.settings.fetch('dr_example_healthstone.spin', 35)
local healthstone = dark_addon.settings.fetch('dr_example_healthstone.check')
local callpet = dark_addon.settings.fetch('dr_example_pet.check')
local ds = dark_addon.settings.fetch('dr_example_ds.check')
local dsperc = dark_addon.settings.fetch('dr_example_ds.spin', 70)

-- Experimental

    local AoE = 3
  

    local inRange = 0

      for i = 1, 40 do
            if UnitExists('nameplate' .. i) and IsSpellInRange('Scourge Strike', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then
                inRange = inRange + 1
            end
        end

    -- print(inRange)

--------------
-- Defensives
--------------
    if -spell(SB.IceboundFortitude) == 0 and player.health.percent < icefortperc and icefort == true then 
      return cast(SB.IceboundFortitude)
    end

    if -spell(SB.AntiMagicShell) == 0 and player.health.percent < antimagicperc and antimagic == true then 
      return cast(SB.AntiMagicShell)
    end
  if healthstone == true and player.health.percent < healthstonepercent and GetItemCount(5512) >= 1 and GetItemCooldown(5512) == 0 then
     macro('/use Healthstone')
  end
    if -spell(SB.DeathStrike) == 0 and player.health.percent < dsperc and ds == true and -buff(SB.DarkSuccor) then 
      return cast(SB.DeathStrike)
    end


------------
-- Utility
------------

  if grip == true and modifier.alt and -spell(SB.DeathGrip) == 0 then
   return cast(SB.DeathGrip)
   end

-----------
-- Opener
-----------
   if target.alive and target.enemy and player.alive and not player.channeling() then
    auto_attack()

  if toggle('opener', false) and y ~= 99 then
    if -spell(SB.Outbreak) == 0 and y == 0 and player.power.runes.count >= 1 then
      y = y + 1
      print ("Starting Opener")
       return cast(SB.Outbreak)
      end
    if player.buff(SB.SuddenDoom).up and player.spell(SB.DeathCoil).cooldown == 0 then
      return cast(SB.DeathCoil)
    end
    if player.spell(SB.DarkTransformation).cooldown == 0 and y == 1 and pet.exists then 
      return cast(SB.DarkTransformation)
   end
    if talent(7,2) and player.spell(SB.UnholyFrenzy).cooldown == 0 and y == 1 then
      return cast(SB.UnholyFrenzy)
    end
    if -spell(SB.DeathCoil) == 0 and y == 1 and player.power.runicpower.actual >= 40 then
      return cast(SB.DeathCoil)
    end
    if target.debuff(SB.FesteringWounds).count >= 6 and y == 1 and -spell(SB.Apocalypse) == 0 then
     return cast(SB.Apocalypse)
    end
    if -spell(SB.ScourgeStrike) == 0 and target.debuff(SB.FesteringWounds).count >= 3 and player.power.runes.count >= 1 and -spell(SB.Apocalypse) == 1 and y == 1 then
      return cast(SB.ScourgeStrike)
    else
      if -spell(SB.ClawingShadows) == 0 and target.debuff(SB.FesteringWounds).count >= 3 and player.power.runes.count >= 1 and -spell(SB.Apocalypse) == 1 and y == 1 then
      return cast(SB.ClawingShadows)
    end
  end

    if -spell(SB.FesteringStrike) == 0 and y == 1 and player.power.runes.count >= 1 then
      return cast(SB.FesteringStrike)
    end
    if player.buff(SB.UnholyFrenzy).down and y == 1 and -spell(SB.UnholyFrenzy) == 1 then
      y = 99
      print ("Opener Done")
      return 
    end

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


--------------------------
-- High Priority Spells
--------------------------


   if (not target.debuff(SB.VirulentPlague).exists or target.debuff(SB.VirulentPlague).remains <= 2) and player.power.runes.count >= 1 and -spell(SB.Outbreak) == 0 then
      return cast(SB.Outbreak, 'target')
    end

   if player.buff(SB.SuddenDoom).up and -spell(SB.DeathCoil) == 0 then
    return cast(SB.DeathCoil, 'target')
  end
  if modifier.shift and -spell(SB.DeathAndDecay) == 0 and player.power.runes.count >= 1 then
    return cast(SB.DeathAndDecay, 'ground')
    else
            if modifier.shift and -spell(SB.Defile) == 0 and talent(6,2) and player.power.runes.count >= 1 then
              return cast(SB.Defile, 'ground')
            end
  end


--------------
-- Cooldowns
--------------

  if cds == true and -spell(SB.DarkTransformation) == 0 and pet.exists then
    return cast(SB.DarkTransformation)
  end
  if cds == true and talent(7,2) and -spell(SB.UnholyFrenzy) == 0 then
    return cast(SB.UnholyFrenzy)
  end
  if cds == true and talent(7,3) and -spell(SB.SummonGargoyle) == 0 then
    return cast(SB.SummonGargoyle)
  end



-----------------
-- Single Target
-----------------

  if -spell(SB.DeathCoil) == 0 and player.power.runicpower.actual >= 80 and inRange < AoE then
    cast(SB.DeathCoil)
  end
  if talent(4,3) and -spell(SB.SoulReaper) == 0 and inRange < AoE then
    return cast(SB.SoulReaper, 'target')
  end
  if talent(6,3) and target.debuff(SB.VirulentPlague).exists and -spell(SB.Epidemic) == 0 and player.power.runicpower.actual >= 30 and inRange < AoE then
    return cast(SB.Epidemic)
  end
  if target.debuff(SB.FesteringWounds).count >= 1 and -spell(SB.ScourgeStrike) == 0 and player.power.runes.count >= 1 and inRange < AoE then
    return cast(SB.ScourgeStrike, 'target')
  else 
    if talent(1,3) and target.debuff(SB.FesteringWounds).count >= 1 and -spell(SB.ClawingShadows) == 0 and player.power.runes.count >= 1 and -spell(SB.Apocalypse) == 1 and inRange < AoE then
      return cast(SB.ClawingShadows, 'target')
    end
  end
  if -pell(SB.Apocalypse) == 0 and target.debuff(SB.FesteringWounds).count >= 6  and inRange < AoE then
    return cast(SB.Apocalypse, 'target')
  end
  if -spell(SB.FesteringStrike) == 0 and player.power.runes.count >= 2  and inRange < AoE then
    return cast(SB.FesteringStrike)
  end


  ---------------
  -- Multitarget
  ---------------


 if player.buff(SB.DeathAndDecay).up and player.power.runes.count >= 1 and -spell(SB.ScourgeStrike) == 0 and target.debuff(SB.FesteringWounds).count >= 3 and inRange >= AoE and not talent(1,3) then
    return cast(SB.ScourgeStrike)
     else
      if player.buff(SB.DeathAndDecay).up and player.power.runes.count >= 1 and player.spell(SB.ClawingShadows).cooldown == 0 and target.debuff(SB.FesteringWounds).count >= 3 and inRange >= AoE and talent(1,3) then
        return cast(SB.ClawingShadows)
      end
   end
     if talent(6,3) and target.debuff(SB.VirulentPlague).exists and -spell(SB.Epidemic) == 0 and player.power.runicpower.actual >= 30 and inRange >= AoE then
    return cast(SB.Epidemic)
  end
     if -spell(SB.DeathAndDecay) == 0 and player.power.runes.count >= 1 and inRange >= AoE then
    return cast(SB.DeathAndDecay, 'player')
  else 
    if talent(6,2) and -spell(SB.Defile) == 0 and player.power.runes.count >= 1 and inRange >= AoE then
      return cast(SB.Defile)
    end
  end
   if target.debuff(SB.FesteringWounds).count >= 4 and player.power.runes.count >= 1 and inRange >= AoE and -spell(SB.Apocalypse) == 1 then
   	return cast(SB.ScourgeStrike)
   end
     if -spell(SB.Apocalypse) == 0 and target.debuff(SB.FesteringWounds).count >= 6  and inRange >= AoE then
    return cast(SB.Apocalypse, 'target')
  end
   if -spell(SB.FesteringStrike) == 0 and player.power.runes.count >= 2 and inRange >= AoE then
    return cast(SB.FesteringStrike)
    end
  if -spell(SB.DeathCoil) == 0 and player.power.runicpower.actual >= 80 and inRange >= AoE then
    return cast(SB.DeathCoil)
  end




   
end
end
local function resting()
	local callpet = dark_addon.settings.fetch('dr_example_pet.check')
	local army = dark_addon.settings.fetch('dr_example_army.check')


   if not pet.exists and player.alive and -spell(SB.RaiseDead) == 0 then 
    return cast(SB.RaiseDead)
  end

     if army == true and modifier.control and -spell(SB.ArmyOfTheDead) == 0 then
    return cast(SB.ArmyOfTheDead)
  end
  

  -- Put great stuff here to do when your out of combat
end



local function interface()
   local example = {
    key = 'dr_example',
    title =                     'AhFack Rotations - Death Knight Unholy',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = '               Unholy Settings' },
      { type = 'text', text = 'Plague your enemies with this wonderful Rotation!' },
      { type = 'rule' },   
      { type = 'text', text = 'Class Specific' },
      { key = 'cds', type = 'checkbox', text = 'Cooldowns', desc = 'Use Cooldowns in Combat' },
      { key = 'interrupt', type = 'spinner', text = 'Interupt %', desc = 'What % you will be interupting at', default_spin = 60, min = 10, max = 100, step = 5 },
      { type = 'rule' },   

      { type = 'text', text = 'Defensives' },
      { key = 'icefort', type = 'checkspin', text = 'Icebound Fortitude at HP%', desc = 'What % you will be using Icebound Fortitude at', default_spin = 50, min = 10, max = 100, step = 5 },
      { key = 'antimagic', type = 'checkspin', text = 'Anti-Magic Shell HP%', desc = 'What % you will be using Anti-Magic Shell at', default_spin = 40, min = 10, max = 100, step = 5 },
      { key = 'ds', type = 'checkspin', text = 'Death Strike HP%', desc = 'What % you will be using Death Strike with Dark Succor at', default_spin = 70, min = 10, max = 100, step = 5 },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone at HP%', desc = 'What % you will be using Healthstones at', default_spin = 35, min = 10, max = 100, step = 5 },
      { type = 'rule' },

      { type = 'text', text = 'Utility' },
      { key = 'grip', type = 'checkbox', text = 'Death Grip', desc = 'Grips target when holding ALT' },
      { key = 'callpet', type = 'checkbox', text = 'Auto-Call Pet', desc = 'Automaticly calls Pet' },
      { key = 'army', type = 'checkbox', text = 'Army of the Dead', desc = 'Casts Army of the Dead when holding CTRL in Resting' },

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
  spec = dark_addon.rotation.classes.deathknight.unholy,
  name = 'AHunholy',
  label = 'AhFack Rotations',
  combat = combat,
  resting = resting,
  interface = interface
})