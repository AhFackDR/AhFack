-- Shadow Priest 8.1 by AhFack - 12/2018
-- Holding Shift while you have Multi Target active, you will dot any target you have underneath your mouse. This requires a "Cast on Cursor" macro.
-- Holding Control casts Leap of Faith, this is enabled in the interface. This requires a macro for leap of faithing focus. 
-- Holding Alt casts Mass Dispel on Cursor, this is enabled in the interface. This does not require a macro.

-- Macros used:

-- 


local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.priest

local function combat()
local multit = dark_addon.settings.fetch('dr_example_multit')
local multidot = dark_addon.settings.fetch('dr_example_multidot')
local cds = dark_addon.settings.fetch('dr_example_cds')
local vampiricembrace = dark_addon.settings.fetch('dr_example_vamp.check')
local vamppercent = dark_addon.settings.fetch('dr_example_vamp.spin', 20)
local dispersion = dark_addon.settings.fetch('dr_example_disp.check')
local disppercent = dark_addon.settings.fetch('dr_example_disp.spin', 10)
local intpercent = dark_addon.settings.fetch('dr_example_interrupt', 60)
local healthstonepercent = dark_addon.settings.fetch('dr_example_healthstone.spin', 35)
local healthstone = dark_addon.settings.fetch('dr_example_healthstone.check')
local massdispel = dark_addon.settings.fetch('dr_example_massdispel')
local autoleap = dark_addon.settings.fetch('dr_example_leap')

-- Defensives

  if vampiricembrace == true and -spell(SB.VampiricEmbrace) == 0 and player.health.percent < vamppercent and vampiricembrace == true then
      return cast(SB.VampiricEmbrace)
  end
  if dispersion == true and -spell(SB.Dispersion) == 0 and player.health.percent < disppercent and dispersion == true then 
      return cast(SB.Dispersion)
  end

  if healthstone == true and player.health.percent < healthstonepercent and GetItemCount(5512) >= 1 and GetItemCooldown(5512) == 0 then
     macro('/use Healthstone')
  end


-- Utility

if fade == true and -spell(SB.Fade) == 0 and player.health < fadepercent then
  return cast(SB.Fade)
end
if modifier.alt and -spell(SB.MassDispell) == 0 and massdispel == true then
      return cast(SB.MassDispell, 'ground')
end
-- if modifier.ctrl and -spell(LeapOfFaith) == 0 and autoleap == true then
 -- return RunMacro('Leap')
-- end


-- Rotation

   if target.alive and target.enemy and player.alive and not player.channeling() then

    if -spell(SB.Silence, 'target') == 0 and target.interrupt(intpercent, false) then
      return cast(SB.Silence, 'target')
      else
            if talent(4,3) and player.spell(SB.PsychicHorror).cooldown == 0 and not lastcast(SB.Silence) and target.interrupt(intpercent, false) and not -spell(SB.Silence) == 0 then
              return cast(SB.PsychicHorror, 'target')
            end
   end
       if multidot == true and -target.debuff(SB.ShadowWordPain) and modifier.shift and -spell(SB.ShadowWordPain) == 0 then
      return RunMacro('Pain')
    end
    if player.buff(SB.VoidForm).up and player.spell(SB.VoidBolt).cooldown == 0 then 
      return cast(SB.VoidBolt, 'target')
   end
   if player.buff(SB.VoidForm).down and player.spell(SB.VoidEruption).cooldown == 0 and player.power.insanity.actual > 90 then
    return cast(SB.VoidEruption, 'target')
  end

    if not -target.debuff(SB.VampiricTouch) and -spell(SB.VampiricTouch) == 0 then
      return cast(SB.VampiricTouch, 'target')
   end
       if talent(3,3) and player.spell(SB.DarkVoid).cooldown == 0 and multit == true then
      return cast(SB.DarkVoid)
    end
    if not -target.debuff(SB.ShadowWordPain) and -spell(SB.ShadowWordPain) == 0 then
      return cast(SB.ShadowWordPain, 'target')
   end
    if cds == true and talent(6,2) and -spell(SB.MindbenderShadow) == 0 then
      return cast(SB.MindbenderShadow, 'target')
        else
          if player.spell(SB.ShadowFiend).cooldown == 0 then
         return cast(SB.ShadowFiend, 'target')
      end 
    end
    if talent(5,2) and target.health < 20 and player.spell(SB.ShadowWordDeath).cooldown == 0 then
      return cast(SB.ShadowWordDeath, 'target')
    end
    if multit == true and talent(5,3) and player.spell(SB.ShadowCrash).cooldown == 0 then
      return cast(SB.ShadowCrash, 'target')
    end
    if talent(6,3) and player.buff(SB.VoidForm).up and player.spell(SB.VoidTorrent).cooldown == 0 and player.power.insanity.actual < 30 then
      return cast(SB.VoidTorrent, 'target')
    end
    if player.buff(SB.VoidForm).down and talent(7,2) and player.spell(SB.DarkAscension).cooldown == 0 then
      return cast(SB.DarkAscension, 'target')
    end
    if  player.spell(SB.MindBlast).cooldown == 0 then
      return cast(SB.MindBlast, 'target')
      else
            if talent(1,3) and player.spell(SB.ShadowWordVoid).cooldown == 0 then
              return cast(SB.ShadowWordVoid, 'target')
            end
    end

-- Fillers

    if multit == true and -spell(SB.MindSear) == 0 then
      return cast(SB.MindSear, 'target')
    end

    if player.spell(SB.MindFlay).cooldown == 0 then
      return cast(SB.MindFlay, 'target')
    end
   
end
end
local function resting()
  
if player.buff(SB.ShadowForm).down and player.spell(SB.ShadowForm).cooldown == 0 then
   return cast(SB.ShadowForm)
 end
if not -player.buff(SB.PowerWordFortitude) and -spell(SB.PowerWordFortitude, 'player') == 0 then
  return cast(SB.PowerWordFortitude, 'player')
end


  -- Put great stuff here to do when your out of combat
end



local function interface()
   local example = {
    key = 'dr_example',
    title =                     'AhFack Rotations - Shadow Priest',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = '               Shadow Settings' },
      { type = 'text', text = 'Wop and DoT your enemies with this wonderful Rotation!' },
      { type = 'rule' },   
      { type = 'text', text = 'Class Specific' },
      { key = 'multit', type = 'checkbox', text = 'Multitarget', desc = 'Use Mind Sear in Multitarget' },
      { key = 'multidot', type = 'checkbox', text = 'Multi Dotting', desc = 'Hold down Shift to use your Macro to Mouseover DoT' },
      { key = 'cds', type = 'checkbox', text = 'Cooldowns', desc = 'Use Mindbender / Shadowfiend in Combat' },
      { key = 'interrupt', type = 'spinner', text = 'Interupt %', desc = 'What % you will be interupting at', default_spin = 60, min = 10, max = 100, step = 5 },
      { type = 'rule' },   

      { type = 'text', text = 'Defensives' },
      { key = 'dispersion', type = 'checkspin', text = 'Dispersion at HP%', desc = 'What % you will be using Dispersion at', default_spin = 10, min = 10, max = 100, step = 5 },
      { key = 'vampiricembrace', type = 'checkspin', text = 'Vampiric Embrace HP%', desc = 'What % you will be using Vampiric Emb at', default_spin = 20, min = 10, max = 100, step = 5 },
      { type = 'rule' },

      { type = 'text', text = 'Utility' },
      { key = 'massdispel', type = 'checkbox', text = 'Mass Dispel', desc = 'Use Mass Dispel on Cursor when Alt is held down.' },
      { key = 'fade', type = 'checkspin', text = 'Fade', desc = 'Use Fade when hit a certain amount of health.' },
      { key = 'autoleap', type = 'checkbox', text = 'Leap of Faith', desc = 'Use Leap of Faith macro when Ctrl is held down.' },



  }
  } 
      configWindow = dark_addon.interface.builder.buildGUI(example) 
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
  spec = dark_addon.rotation.classes.priest.shadow,
  name = 'AHshadow',
  label = 'AhFack Rotations',
  combat = combat,
  resting = resting,
  interface = interface
})