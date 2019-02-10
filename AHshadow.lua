-- Shadow Priest 8.1 by AhFack - 12/2018
-- Holding Shift while you have Multi Target active, you will dot any target you have underneath your mouse. This requires a "Cast on Cursor" macro.
-- Holding Control casts Shadow Crash, on your Cursor. 
-- Holding Alt casts Mass Dispel on Cursor, this is enabled in the interface. This does not require a macro.

-- Macros used:

-- 


local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.priest
  local lftime = 0 -- Dungeon / LFG Queue Timers

local function combat()
local multidot = dark_addon.settings.fetch('dr_example_multidot')
local cds = dark_addon.settings.fetch('dr_example_cds')
local vampiricembrace = dark_addon.settings.fetch('dr_example_vamp.check')
local vamppercent = dark_addon.settings.fetch('dr_example_vamp.spin')
local dispersion = dark_addon.settings.fetch('dr_example_shadow.check')
local disppercent = dark_addon.settings.fetch('dr_example_disp.spin')
local intpercent = dark_addon.settings.fetch('dr_example_interrupt')
local healthstonepercent = dark_addon.settings.fetch('dr_example_healthstone.spin')
local healthstone = dark_addon.settings.fetch('dr_example_healthstone.check')
local massdispel = dark_addon.settings.fetch('dr_example_massdispel')
local autoleap = dark_addon.settings.fetch('dr_example_leap')
local autotarget = dark_addon.settings.fetch('dr_example_autotarget.check')
local mindsear = dark_addon.settings.fetch('dr_example_mindsear.check')
local mindsearmulti = dark_addon.settings.fetch('dr_exaple_mindsearmulti')
local pbs = dark_addon.settings.fetch('dr_example_pbs.check')
local multodotting = dark_addon.settings.fetch('dr_example_multidotting.check')

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
if modifier.alt and -spell(SB.MassDispel) == 0 and massdispel == true then
      return cast(SB.MassDispel, 'ground')
end
if modifier.lcontrol and -spell(SB.ShadowCrash) == 0 then
 return cast(SB.ShadowCrash, 'ground')
 end

 -- Auto Target
local nearest_target = enemies.match(function (unit)
  return unit.alive and unit.combat and unit.distance <= 8
end)

if (not target.exists or target.distance > 5) and nearest_target and nearest_target.name and autotarget == true then
  macro('/target ' .. nearest_target.name)
end

-- Auto Multi-DoTSWP
local enemies_around = enemies.around(8)
local enemy_for_mark = enemies.match(function (unit)
  return unit.alive and unit.combat and unit.distance <= 40 and unit.debuff(SB.ShadowWordPain).remains < 2
end)

if target.debuff(SB.ShadowWordPain).remains > 10 and enemy_for_mark and enemy_for_mark.name and multidotting == true then
  for i=1,enemies_around do
    macro('/target ' .. enemy_for_mark.name)
    if target.guid == enemy_for_mark.guid then break end
  end
end

-- Auto Multi-DoTVT
local enemies_around = enemies.around(8)
local enemy_for_mark = enemies.match(function (unit)
  return unit.alive and unit.combat and unit.distance <= 40 and unit.debuff(SB.VampiricTouch).remains < 2
end)

if target.debuff(SB.VampiricTouch).remains > 10 and enemy_for_mark and enemy_for_mark.name and multidotting == true then
  for i=1,enemies_around do
    macro('/target ' .. enemy_for_mark.name)
    if target.guid == enemy_for_mark.guid then break end
  end
end


-- Rotation

   if target.alive and target.enemy and player.alive and not player.channeling() then
   
   -- Interrupt

    if -spell(SB.Silence, 'target') == 0 and target.interrupt(intpercent, false) then
      return cast(SB.Silence, 'target')
      else
            if talent(4,3) and player.spell(SB.PsychicHorror).cooldown == 0 and not lastcast(SB.Silence) and target.interrupt(intpercent, false) and not -spell(SB.Silence) == 0 then
              return cast(SB.PsychicHorror, 'target')
            end
   end
   -- Damage
   
       if multidot == true and -target.debuff(SB.ShadowWordPain) and modifier.shift and -spell(SB.ShadowWordPain) == 0 then
      return cast(SB.ShadowWordPain, 'mouseover')
    end
    if -buff(SB.VoidForm) and player.spell(SB.VoidBolt).cooldown == 0 then 
      return cast(SB.VoidBolt, 'target')
   end
   if not -buff(SB.VoidForm) and player.spell(SB.VoidEruption).cooldown == 0 and player.power.insanity.actual > 90 then
    return cast(SB.VoidEruption, 'target')
  end

    if not target.debuff(SB.VampiricTouch) and -spell(SB.VampiricTouch) == 0 then
      return cast(SB.VampiricTouch, 'target')
   end
   if target.debuff(SB.VampiricTouch).remains <= 6.3 and -spell(SB.VampiricTouch) == 0 then
    return cast(SB.VampiricTouch, 'target')
  end

       if talent(3,3) and player.spell(SB.DarkVoid).cooldown == 0 and enemies.around(10) >= 2 and not -target.debuff(SB.ShadowWordPain) then
      return cast(SB.DarkVoid, 'target')
    end
    if not target.debuff(SB.ShadowWordPain) and -spell(SB.ShadowWordPain) == 0 then
      return cast(SB.ShadowWordPain, 'target')
   end
   if target.debuff(SB.ShadowWordPain).remains <= 4.8 and -spell(SB.ShadowWordPain) == 0 then
    return cast(SB.ShadowWordPain, 'target')
  end

    if cds == true and talent(6,2) and -spell(SB.MindbenderShadow) == 0 then
      return cast(SB.MindbenderShadow, 'target')
        else
          if player.spell(SB.ShadowFiend).cooldown == 0 
      and cds == true then
         return cast(SB.ShadowFiend, 'target')
      end 
    end
    if talent(5,2) and target.health <= 20 and player.spell(SB.ShadowWordDeath).cooldown == 0 then
      return cast(SB.ShadowWordDeath, 'target')
    end

    if talent(6,3) and -player.buff(SB.VoidForm) and player.spell(SB.VoidTorrent).cooldown == 0 and player.power.insanity.actual < 30 then
      return cast(SB.VoidTorrent, 'target')
    end
    if not -player.buff(SB.VoidForm) and talent(7,2) and player.spell(SB.DarkAscension).cooldown == 0 then
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

if enemies.around(10) >= 3 and -spell(SB.MindSear) == 0 and mindsear == true and not -player.buff(SB.ThoughtHarvester) then
  return cast(SB.MindSear, 'target')
end

if player.spell(SB.MindSear).cooldown == 0 and mindsear == true and -player.buff(SB.ThoughtHarvester) then
  return cast(SB.MindSear, 'target')
end

if player.spell(SB.MindFlay).cooldown == 0 and enemies.around(10) <= 3 and mindsear == true and not -player.buff(SB.ThoughtHarvester) then
  return cast(SB.MindFlay, 'target')
end

if player.spell(SB.MindSear).cooldown == 0 and mindsear == nil and -player.buff(SB.ThoughtHarvester) then
  return cast(SB.MindSear, 'target')
end

if player.spell(SB.MindFlay).cooldown == 0 and mindsear == nil and not -player.buff(SB.ThoughtHarvester) then
  return cast(SB.MindFlay, 'target')
end
   
end
end
local function resting()
  
if not -player.buff(SB.ShadowForm) and player.spell(SB.ShadowForm).cooldown == 0 then
   return cast(SB.ShadowForm)
 end
if not -player.buff(SB.PowerWordFortitude) and -spell(SB.PowerWordFortitude, 'player') == 0 then
   return cast(SB.PowerWordFortitude, 'player')
 end
 --if not -player.debuff(SB.WeakenedSoul) and -spell(SB.PowerWordShield, 'player') == 0 and pbs == true then
 --   return cast(SB.PowerWordShield, 'player')
--end


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
      { key = 'multidot', type = 'checkbox', text = 'Multi Dotting', desc = 'Hold down Shift to use your Macro to Mouseover DoT' },
      { key = 'cds', type = 'checkbox', text = 'Cooldowns', desc = 'Use Mindbender / Shadowfiend in Combat' },
      { key = 'interrupt', type = 'spinner', text = 'Interupt %', desc = 'What % you will be interupting at', default_spin = 30, min = 10, max = 100, step = 5 },
      { key = 'autotarget', type = 'checkbox', text = 'Auto-Target', desc = 'Auto Targets Nearest Target'},
      { key = 'multidotting', type = 'checkbox', text = 'Auto DoT', desc = 'Auto DoTs Targets in Area close to Target'},
      { key = 'mindsear', type = 'checkbox', text = 'Use Mind Sear', desc = 'Mind Sear on AoE / Proccs.'},
      --{ key = 'mindsearmulti', type = 'spinner', text = 'Mind Sear Targets', desc = 'Auto MindSear when X in Range', default_spin = 3, min = 1, max = 20, step = 1 },
      { type = 'rule' },   

      { type = 'text', text = 'Defensives' },
      { key = 'dispersion', type = 'checkspin', text = 'Dispersion at HP%', desc = 'What % you will be using Dispersion at', default_spin = 10, min = 10, max = 100, step = 5 },
      { key = 'vampiricembrace', type = 'checkspin', text = 'Vampiric Embrace HP%', desc = 'What % you will be using Vampiric Emb at', default_spin = 10, min = 10, max = 100, step = 5 },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone at HP%', desc = 'What % you will be using Healthstones at', default_spin = 35, min = 10, max = 100, step = 5 },
      { type = 'rule' },

      { type = 'text', text = 'Utility' },
      { key = 'massdispel', type = 'checkbox', text = 'Mass Dispel', desc = 'Use Mass Dispel on Cursor when Alt is held down.' },
      { key = 'fade', type = 'checkspin', text = 'Fade', desc = 'Use Fade when hit a certain amount of health.' },
      { key = 'autoleap', type = 'checkbox', text = 'Leap of Faith', desc = 'Use Leap of Faith macro when Ctrl is held down.' },
      { key = 'autoaccept', type = 'checkbox', text = 'Auto Accept Queue', desc = 'Auto Accepts any Queue for BGs and DGs'},
      { key = 'pbs', type = 'checkbox', text = 'Auto-Shield for Movementspeed', desc = 'Auto Power Word: Shield for Movementspeed out of combat.'},



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