--[[
  MIT License

  Copyright (c) 2018 Michael Wiesendanger

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
]]--

--[[
  To run the tests make sure to include this file into LogParser.toc.

  start test by calling from the game with /run [functionName]
]]--
local mod = lp
local me = {}
mod.testSpellPeriodicHostilePlayerDamageEn = me

me.tag = "TestSpellPeriodicHostilePlayerDamageEn"

-- global
local _G = getfenv(0)
local eventName = "SpellPeriodicHostilePlayerDamage"

--[[
  global function to start all tests
]]--
function _G.__PVPW__TEST_SPELL_PERIODIC_HOSTILE_PLAYER_DAMAGE_EN__Test()
  mod.testReporter.StartTestRun("global_spell_periodic_hostile_player_damage_en_all")
  mod.testReporter.StartTestEventSet(eventName)

  -- silence logging to errorlevel
  mod.logger.logLevel = 1

  me.RunAll()
end

--[[
  @param {boolean} playManual
    true if testqueue is started manually
    false if testqueue should be started
]]--
function me.RunAll()
  mod.testReporter.AddToTestQueue(me.TestParseNormalSpellName)
  mod.testReporter.AddToTestQueue(me.TestParseMultiwordSpellName)
  mod.testReporter.AddToTestQueue(me.TestParseSpecialCharacterSpellName)

  mod.testReporter.PlayTestQueue()
end

function me.TestParseNormalSpellName()
  mod.testHelper.TestParse(
    eventName,
    "TestParseNormalSpellName",
    "dummyspell",
    "$player$ is afflicted by Dummyspell.",
    mod.testHelper.eventTypeSpellPeriodicSpellHostilePlayerDamage
  )
end

function me.TestParseMultiwordSpellName()
  mod.testHelper.TestParse(
    eventName,
    "TestParseMultiwordSpellName",
    "dummy_spell",
    "$player$ is afflicted by Dummy Spell.",
    mod.testHelper.eventTypeSpellPeriodicSpellHostilePlayerDamage
  )
end

function me.TestParseSpecialCharacterSpellName()
  mod.testHelper.TestParse(
    eventName,
    "TestParseSpecialCharacterSpellName",
    "dummy_spell",
    "$player$ is afflicted by Dummy (Spell):-'s.",
    mod.testHelper.eventTypeSpellPeriodicSpellHostilePlayerDamage
  )
end