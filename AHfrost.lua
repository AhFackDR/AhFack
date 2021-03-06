-- Frost Death Knight for 8.1 by AhFack - 12/2018
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

    local AoE = 2
  

    local inRange = 0

      for i = 1, 40 do
            if UnitExists('nameplate' .. i) and IsSpellInRange('Frost Strike', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then
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

  if grip == true and modifier.shift and -spell(SB.DeathGrip) == 0 then
   return cast(SB.DeathGrip)
   end

-----------
-- Opener
-----------
   if target.alive and target.enemy and player.alive and not player.channeling() and target.distance < 8 then
    auto_attack()



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



--------------
-- Cooldowns
--------------


if cds == true and -spell(SB.PillarOfFrost) == 0 then
  return cast(SB.PillarOfFrost)
end

if modifier.alt and -spell(SB.ChainsOfIce) == 0 and player.runes.count >= 1 then
  return cast(SB.ChainsOfIce)
end




-----------------
-- Single Target
-----------------

if enemies.around(8) < 2 then

if talent(1,2) and -buff(SB.IcyTalons).remains < 2 and -spell(SB.FrostStrike) == 0 and player.power.runicpower.actual >= 25 then 
  return cast(SB.FrostStrike)
end
if -spell(SB.RemorselessWinter) == 0 then
  return cast(SB.RemorselessWinter)
end
if talent(1,3) and player.buff(SB.ColdHeart).count > 15 and -spell(SB.ChainsOfIce) == 0 and player.power.runes.count >= 1 then 
  return cast(SB.ChainsOfIce)
end
if -buff(SB.RemorselessWinter).remains < 4 and talent(6,1) and -spell(SB.FrostStrike) == 0 then
  return cast(SB.FrostStrike)
end
if player.buff(SB.Rime).up and -spell(SB.HowlingBlast) == 0 then
  return cast(SB.HowlingBlast)
end
if talent(4,2) and -spell(SB.Obliterate) == 0 then
  return cast(SB.Obliterate)
end
if cds == true and -spell(SB.EmpowerRuneWeapon) == 0 then
  return cast(SB.EmpowerRuneWeapon)
end
if cds == true and -spell(SB.PillarOfFrost) == 0 then
  return cast(SB.PillarOfFrost)
end
if player.power.runicpower.actual >= 75 and -spell(SB.BreathOfSindragosa) == 0 and talent(7,3) then
  return cast(SB.BreathOfSindragosa)
end
if player.power.runicpower.actual >= 73 and -spell(SB.FrostStrike) == 0 and player.spell(SB.BreathOfSindragosa).cooldown == 1 then
  return cast(SB.FrostStrike)
end
if player.buff(SB.KillingMachine).up and talent(4,3) and -spell(SB.FrostScythe) == 0 then 
  return cast(SB.FrostScythe)
  elseif player.buff(SB.KillingMachine).up and -spell(SB.Obliterate) == 0 then
    return cast(SB.Obliterate)
  end
end
if player.power.runicpower.actual < 73 and -spell(SB.Obliterate) == 0 then
  return cast(SB.Obliterate)
end
if player.power.runicpower.actual >= 25 and -spell(SB.FrostStrike) == 0 then
  return cast(SB.FrostStrike)
end
end



---------------
-- Multitarget
---------------
if enemies.around(8) >= 2 then

if -buff(SB.IcyTalons).remains < 2 and talent(6,2) and talent(1,2) and -spell(SB.GlacialAdvance) == 0 then
  return cast(SB.GlacialAdvance)
  elseif -buff(SB.IcyTalons).remains < 2 and talent(1,2) and player.power.runicpower.actual >= 25 and -spell(SB.FrostStrike) == 0 then
    return cast(SB.FrostStrike)
  end
end
if talent(6,1) and -spell(SB.RemorselessWinter) == 0 then
  return cast(SB.RemorselessWinter)
end
if talent(7,3) and -spell(SB.BreathOfSindragosa) == 0 and player.power.runicpower.actual >= 75 and talent(7,3) then
  return cast(SB.BreathOfSindragosa)
end
if player.power.runicpower.actual >= 73 and talent(6,2) and -spell(SB.GlacialAdvance) == 0 then 
  return cast(SB.GlacialAdvance)
  elseif -buff(SB.RemorselessWinter).remains < 4 and talent(6,2) and -spell(SB.FrostStrike) == 0 then
    return cast(SB.FrostStrike)
end
if talent(6,3) and -spell(SB.FrostwyrmsFury) == 0 then
  return cast(SB.FrostwyrmsFury)
end
if player.buff(SB.Rime).up and -spell(SB.HowlingBlast) == 0 then
  return cast(SB.HowlingBlast)
end
if talent (4,3) and player.buff(SB.KillingMachine).up and -spell(SB.FrostScythe) == 0 then
  return cast(SB.FrostScythe)
  elseif -spell(SB.Obliterate) == 0 and player.buff(SB.KillingMachine).up then
    return cast(SB.Obliterate)
  end
if -spell(SB.RemorselessWinter) == 0 then
  return cast(SB.RemorselessWinter)
end
if -spell(SB.Obliterate) == 0 and player.power.runes.count >= 2 then
  return cast(SB.Obliterate)
end
if talent(6,2) and -spell(SB.GlacialAdvance) == 0 then
  return cast(SB.GlacialAdvance)
  elseif castable(SB.FrostStrike) then
    return cast(SB.FrostStrike)
  end





end


local function resting()





  -- Put great stuff here to do when your out of combat
end



local function interface()
   local example = {
    key = 'dr_example',
    title =                     'AhFack Rotations - Death Knight Frost',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = '               Frost Settings' },
      { type = 'text', text = 'Freeze your enemies with this wonderful Rotation!' },
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
      { key = 'grip', type = 'checkbox', text = 'Death Grip', desc = 'Grips target when holding SHIFT' },
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
  spec = dark_addon.rotation.classes.deathknight.frost,
  name = 'AHfrost',
  label = 'AhFack Rotations',
  combat = combat,
  resting = resting,
  interface = interface
})