--[[
  MIT License

  Copyright (c) 2019 Michael Wiesendanger

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

local mod = lp
local me = {}
mod.parser = me

me.tag = "Parser"


local SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS1
local SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS2

local SPELL_HOSTILE_PLAYER_BUFF1
local SPELL_HOSTILE_PLAYER_BUFF2
local SPELL_HOSTILE_PLAYER_BUFF3
local SPELL_HOSTILE_PLAYER_BUFF4
local SPELL_HOSTILE_PLAYER_BUFF5

local SPELL_PERIODIC_SELF_DAMAGE

local SPELL_HOSTILEPLAYER_DAMAGE1
local SPELL_HOSTILEPLAYER_DAMAGE2
local SPELL_HOSTILEPLAYER_DAMAGE3
local SPELL_HOSTILEPLAYER_DAMAGE4
local SPELL_HOSTILEPLAYER_DAMAGE5
local SPELL_HOSTILEPLAYER_DAMAGE6
local SPELL_HOSTILEPLAYER_DAMAGE7
local SPELL_HOSTILEPLAYER_DAMAGE8
local SPELL_HOSTILEPLAYER_DAMAGE9

local SPELL_PERIODIC_HOSTILE_PLAYER_DAMAGE

local SPELL_AURA_GONE_OTHER

local SPELL_SELF_DAMAGE1
local SPELL_SELF_DAMAGE2
local SPELL_SELF_DAMAGE3
local SPELL_SELF_DAMAGE4
local SPELL_SELF_DAMAGE5
local SPELL_SELF_DAMAGE6

local SPELL_FAILED_LOCALPLAYER1
local SPELL_FAILED_LOCALPLAYER2

local COMBAT_HOSTILE_DEATH

if (GetLocale() == "deDE") then
  --[[
    Matching spells with umlaute:

    Ä : \195\132
    Ö : \195\150
    Ü : \195\156
    ü : \195\188
    ä : \195\164
    ö : \195\182
    ß : \195\159

    example pattern:

    [%a%s\195\159\195\132\195\150\195\156\195\188\195\164\195\182]
  ]]--

  --[[
    CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS
    [source] [keyword] [spell]

    examples:
      $player$ bekommt 'Berserkerwut'.
      $player$ bekommt 'Todeswunsch'.
      $player$ bekommt 'Tollkühnheit'.
      $player$ bekommt 'Verteidigungshaltung'.
      $player$ bekommt 'Kampfhaltung'.
      $player$ bekommt 'Berserkerhaltung'.
      $player$ bekommt 'Schildwall'.
      $player$ bekommt 'Elunes Anmut'.
  ]]--
  SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS1 = "^(%a+)%s(bekommt)%s'([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)'%.$"

  --[[
    CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS
    [source] [keyword] [spell] [charges]

    Charges can be going up or down

    e.g. $player$ bekommt 'Ruhelose Stärke' (20).
    e.g. $player$ bekommt 'Ruhelose Stärke' (19).
    e.g. $player$ bekommt 'Ruhelose Stärke' (19).
    etc.

    e.g $player$ bekommt 'Verbrennung'.
    e.g $player$ bekommt Combustion (2).

    examples:
      $player$ bekommt 'Ruhelose Stärke' (20).
      $player$ bekommt 'Verbrennung' (2).
  ]]--
  SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS2 = "^(%a+)%s(bekommt)%s'([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)'%s([%d+%(%)]+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [source] [spell] [keyword] [source] [number]

    examples:
      $player$s Schwacher Gesundheitsstein heilt $player$ um $amount$.
  ]]--
  SPELL_HOSTILE_PLAYER_BUFF1 = "^(%a+)s%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%s(heilt)%s(%a+)%sum%s(%d+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [source] [keyword] [spell]

    examples:
      $player$ wirkt Sprengfalle.
      $player$ wirkt Frostfalle.
  ]]--
  SPELL_HOSTILE_PLAYER_BUFF2 = "^(%a+)%s(wirkt)%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [source] [keyword] [spell] [keyword]

    examples:
      $player$ beginnt Entfesselungskünstler auszuführen.
      $player$ beginnt Kriegsdonner auszuführen.
  ]]--
  SPELL_HOSTILE_PLAYER_BUFF3 = "^(%a+)%s(beginnt)%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%s(auszuf\195\188hren)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [keyword] [source] [spell] [keyword] [target] [amount]

    examples:
      Kritische Heilung: $player$s Handauflegung heilt $player$ um $amount$ Punkte.

  ]]--
  SPELL_HOSTILE_PLAYER_BUFF4 = "^(Kritische Heilung):%s(%a+)s%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%s(heilt)%s(%a+)%sum%s(%d+)%sPunkte%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [source] [keyword] [number] [resource] [keyword] [source] [spell]

    examples:
      $player$ bekommt $amount$ Energie durch $player$s Energie wiederherstellen
      $player$ bekommt $amount$ Wut durch $player$s Blutrausch.

  ]]--
  SPELL_HOSTILE_PLAYER_BUFF5 = "^(%a+)%s(bekommt)%s(%d+)%s([%a]+)%s(durch)%s(%a+)s%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%.$"

  --[[
    CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE
    [target] [spell] [keyword]

    examples:
      Ihr seid von Furcht betroffen.
      Ihr seid von Fluch der Sprachen betroffen.
      Ihr seid von Verwandlung betroffen
      Ihr seid von Verwandlung: Schwein betroffen.
      Ihr seid von Gegenzauber - zum Schweigen gebracht betroffen.
      Ihr seid von Feenfeuer (Tiergestalt) betroffen.

  ]]--
  SPELL_PERIODIC_SELF_DAMAGE = "^(Ihr)%sseid%svon%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%s(betroffen)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [keyword] [target] [spell] [keyword] [amount]

    examples:
      $player$ trifft Euch (mit Zuschlagen). Schaden: $amount$.
      $player$ trifft Euch (mit Tritt). Schaden: $amount$.

  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE1 = "^(%a+)%s(trifft)%s(Euch)%s%(mit%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%)%.%s(Schaden):%s(%d+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [keyword] [target] [keyword] [spell] [keyword] [amount]

    examples:
      $player$ trifft Euch kritisch (mit Zuschlagen). Schaden: $amount$.
      $player$ trifft Euch kritisch (mit Tritt). Schaden: $amount$.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE2 = "^(%a+)%s(trifft)%s(Euch)%s(kritisch)%s%(mit%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%)%.%s(Schaden):%s(%d+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [keyword] [spell] [keyword]

    examples:
      $player$ beginnt Hammer des Zorns zu wirken.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE3 = "^(%a+)%s(beginnt)%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%szu%s(wirken)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [keyword] [spell] [keyword] [target]

    examples:
      $player$ greift an (mit Blenden) und verfehlt euch.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE4 = "^(%a+)%s(greift)%san%s%(mit%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%)%sund%s(verfehlt)%s(euch)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword]

    examples:
      $player$s Tritt wurde ausgewichen.
      $player$s Tödlicher Stoß wurde ausgewichen.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE5 = "^(%a+)s%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%swurde%s(ausgewichen)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [spell] [source] [keyword]

    examples:
      Tritt von $player$ wurde pariert.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE6 = "^([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%svon%s(%a+)%swurde%s(pariert)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword]

    examples:
      $player$s Tritt wurde geblockt.
      $player$s Zurechtstutzen wurde geblockt.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE7 = "^(%a+)s%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%swurde%s(geblockt)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [keyword] [spell] [keyword]

    examples:
      $player$ versucht es mit Gegenzauber - zum Schweigen gebracht... widerstanden.
      $player$ versucht es mit Feenfeuer (Tiergestalt)... widerstanden.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE8 = "^(%a+)%s(versucht)%ses%smit%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%.%.%.%s(widerstanden)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [keyword] [spell] [keyword] [keyword]

    examples:
      $player$ versucht es mit Blenden... ein Fehlschlag. Ihr seid immun.
      $player$ versucht es mit Feenfeuer (Tiergestalt)... ein Fehlschlag. Ihr seid immun.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE9 = "^(%a+)%s(versucht)%ses%smit%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%.%.%.%sein%s(Fehlschlag)%.%sIhr%sseid%s(immun)%.$"

  --[[
    CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword]

    examples:
      $player$ ist von Vorahnung betroffen.
      $player$ ist von Todeswunsch betroffen.
  ]]--
  SPELL_PERIODIC_HOSTILE_PLAYER_DAMAGE = "^(%a+)%sist%svon%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%s(betroffen)%.$"

  --[[
    CHAT_MSG_SPELL_AURA_GONE_OTHER
    [spell] [keyword] [source]

    examples:
      Feuerreflektor schwindet von $player$.
  ]]--
  SPELL_AURA_GONE_OTHER = "^([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%s(schwindet)%svon%s(%a+)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [target] [keyword]

    examples:
      Tritt wurde von $player$ geblockt.
      Finsterer Stoß wurde von $player$ geblockt.
      Ausweiden wurde von $player$ geblockt.
  ]]--
  SPELL_SELF_DAMAGE1 = "^([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%swurde%svon%s(%a+)%s(geblockt)%.$"


  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [keyword] [target] [keyword]

    examples:
      Ihr habt es mit Zorn versucht, aber $player$ hat widerstanden.
      Ihr habt es mit Feenfeuer versucht, aber $player$ hat widerstanden.
      Ihr habt es mit Feenfeuer (Tiergestalt) versucht, aber $player$ hat widerstanden.

  ]]--
  SPELL_SELF_DAMAGE2 = "^Ihr%shabt%ses%smit%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%s(versucht),%saber%s(%a+)%shat%s(widerstanden)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [keyword] [target] [keyword]

    examples:
      Feenfeuer war ein Fehlschlag. $player$ ist immun.
      Feenfeuer (Tiergestalt) war ein Fehlschlag. $player$ ist immun.
      Gegenzauber war ein Fehlschlag. $player$ ist immun.

  ]]--
  SPELL_SELF_DAMAGE3 = "^([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%swar%sein%s(Fehlschlag)%.%s(%a+)%sist%s(immun)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [target] [keyword]

    example:
      Gezielter Schuss hat $player$ verfehlt.
      Hieb hat $player$ verfehlt.

  ]]--
  SPELL_SELF_DAMAGE4 = "^([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%shat%s(%a+)%s(verfehlt)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [target] [spell] [keyword]

    examples:
      $player$ ist Zurechtstutzen ausgewichen.
      $player$ ist Entwaffnen ausgewichen.
  ]]--
  SPELL_SELF_DAMAGE5 = "^(%a+)%sist%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%s(ausgewichen)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [target] [keyword]

    examples:
      Zuschlagen wurde von $player$ pariert.
      Entwaffnen wurde von $player$ pariert.

  ]]--
  SPELL_SELF_DAMAGE6 = "^([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+)%swurde%svon%s(%a+)%s(pariert)%.$"

  --[[
    CHAT_MSG_SPELL_FAILED_LOCALPLAYER
    [keyword] [keyword] [spell] [reason]

    Lots off different forms of failed spell attacks. The following examples where tested
    and are supported by this Addon

    examples:
      Ihr scheitert beim Wirken von Geringes Heilen: Unterbrochen.
      Ihr scheitert beim Wirken von Geringes Heilen: Es wird gerade eine andere Aktion ausgeführt.
      Ihr scheitert beim Wirken von Magiebannung: Es gibt nichts zu bannen.
      Ihr scheitert beim Wirken von Geringes Heilen: Nicht genug Mana.
      Ihr scheitert beim Wirken von Göttliche Pein: Kein Ziel.
      Ihr scheitert beim Wirken von Göttliche Pein: Das ist während einer Bewegung nicht möglich.

    patterns that were encountered but not specifically tested:
      Ihr scheitert beim Wirken von Wiedergeburt: Fehlendes Reagenz: Hornbeam Seed.
  ]]--
  SPELL_FAILED_LOCALPLAYER1 = "^Ihr%s(scheitert)%sbeim%s(Wirken)%svon%s([[\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+):%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%a%s]+)%.$"

  --[[
    CHAT_MSG_SPELL_FAILED_LOCALPLAYER
    [keyword] [keyword] [spell] [reason]

    Lots off different forms of failed meele attacks. The following examples where tested
    and are supported by this Addon

    examples:
      Ihr scheitert beim Ausführen von Solarplexus: Kein Ziel.
      Ihr scheitert beim Ausführen von Solarplexus: Außer Reichweite.
      Ihr scheitert beim Ausführen von Solarplexus: Ihr müsst vor eurem Ziel stehen...
      Ihr scheitert beim Ausführen von Solarplexus: Ungültiges Ziel.
      Ihr scheitert beim Ausführen von Solarplexus: Nicht genug Energie.
      Ihr scheitert beim Ausführen von Solarplexus: Noch nicht erholt.
      Ihr scheitert beim Ausführen von Sturmangriff: Das geht nicht, während Ihr desorientiert seid..
      Ihr scheitert beim Ausführen von Sturmangriff: Ziel ist zu nah..
      Ihr scheitert beim Ausführen von Sturmangriff: Ihr seid in einen Kampf verwickelt..
      Ihr scheitert beim Ausführen von Kopfnuss: Muss in Verstohlenheit sein..
      Ihr scheitert beim Ausführen von Kopfnuss: Ziel befindet sich im Kampf..

    patterns that were encountered but not specifically tested:
      Ihr scheitert beim Ausführen von Abfangen: Nicht genug Wut.
      Ihr scheitert beim Ausführen von Sturmangriff: Muss in Kampfhaltung sein..
      Ihr scheitert beim Ausführen von Abfangen: Muss in Berserkerhaltung sein..
      Ihr scheitert beim Ausführen von Schildwall: Muss in Verteidigungshaltung sein..
      Ihr scheitert beim Ausführen von Schildwall: Schild muss angelegt sein..
      Ihr scheitert beim Ausführen von Knurren: Muss in Bärengestallt, Terrorbärengestalt sein..
      Ihr scheitert beim Ausführen von Klaue: Muss in Katzengestalt sein..
      Ihr scheitert beim Ausführen von Wassergestalt: Kann nur beim Schwimmen benutzt werden..
  ]]--
  SPELL_FAILED_LOCALPLAYER2 = "^Ihr%s(scheitert)%sbeim%s(Ausführen)%svon%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%(%)%a%s-:]+):%s([\195\159\195\132\195\150\195\156\195\188\195\164\195\182%a%s,]+)%.?%.?%.$"

  --[[
     CHAT_MSG_COMBAT_HOSTILE_DEATH
     [source] [keyword]

     examples:
      $player$ stirbt.
  ]]--
  COMBAT_HOSTILE_DEATH = "^(%a+)%s(stirbt)%.$"
else
  --[[
    CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS
    [source] [keyword] [spell]

    examples:
      $player$ gains Berserker Rage.
      $player$ gains Death Wish.
      $player$ gains Recklessness.
      $player$ gains Defensive Stance.
      $player$ gains Battle Stance.
      $player$ gains Berserker Stance.
      $player$ gains Shield Wall.
      $player$ gains Elune's Grace.
  ]]--
  SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS1 = "^(%a+)%s(gains)%s([%(%)%a%s'-:]+)%.$"

  --[[
    CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS
    [source] [keyword] [spell] [charges]

    Charges can be going up or down

    e.g. $player$ gains Restless Strength (20).
    e.g. $player$ gains Restless Strength (19).
    e.g. $player$ gains Restless Strength (18).
    etc.

    e.g $player$ gains Combustion (0).
    e.g $player$ gains Combustion (1).

    examples:
      $player$ gains Restless Strength (20).
      $player$ gains Combustion (0).
  ]]--
  SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS2 = "^(%a+)%s(gains)%s([%(%)%a%s'-:]+)%s([%d+%(%)]+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [source] [spell] [keyword] [source] [number]

    examples:
      $player$'s Minor Healthstone heals $player$ for $amount$.
  ]]--
  SPELL_HOSTILE_PLAYER_BUFF1 = "^(%a+)'s%s([%(%)%a%s'-:]+)%s(heals)%s(%a+)%sfor%s(%d+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [source] [keyword] [spell]

    examples:
      $player$ casts Explosive Trap.
      $player$ casts Freezing Trap.
  ]]--
  SPELL_HOSTILE_PLAYER_BUFF2 = "^(%a+)%s(casts)%s([%(%)%a%s'-:]+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [source] [keyword] [spell]

    examples:
      $player$ begins to perform Escape Artist.
  ]]--
  SPELL_HOSTILE_PLAYER_BUFF3 = "^(%a+)%s(begins to perform)%s([%(%)%a%s'-:]+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [source] [spell] [keyword] [target] [amount]

    examples:
      $player$'s Lay on Hands critically heals $player$ for $amount$.

  ]]--
  SPELL_HOSTILE_PLAYER_BUFF4 = "^(%a+)'s%s([%(%)%a%s'-:]+)%s(critically heals)%s(%a+)%sfor%s(%d+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF
    [source] [keyword] [number] [resource] [keyword][source] [spell]

    examples:
      $player$ gains $amount$ Energy from $player$'s Restore Energy.
      $player$ gains $amount$ Rage from $player$'s Bloodrage.
  ]]--
  SPELL_HOSTILE_PLAYER_BUFF5 = "^(%a+)%s(gains)%s(%d+)%s([%a]+)%s(from)%s(%a+)'s%s([%(%)%a%s'-:]+)%.$"

  --[[
    CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE
    [target] [keyword] [spell]

    examples:
      You are afflicted by Fear.
      You are afflicted by Curse of Tongues.
      You are afflicted by Polymorph.
      You are afflicted by Polymorph: Pig.
      You are afflicted by Counterspell - Silenced.
      You are afflicted by Faerie Fire (Feral).
  ]]--
  SPELL_PERIODIC_SELF_DAMAGE = "^(You)%sare%s(afflicted)%sby%s([%(%)%a%s'-:]+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword] [target] [number]

    examples:
      $player$'s Pummel hits you for $amount$.
      $player$'s Kick hits you for $amount$.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE1 = "^(%a+)'s%s([%(%)%a%s'-:]+)%s(hits)%s(you)%sfor%s(%d+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword] [target] [number]

    examples:
      $player$'s Pummel crits you for $amount$.
      $player$'s Kick crits you for $amount$.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE2 = "^(%a+)'s%s([%(%)%a%s'-:]+)%s(crits)%s(you)%sfor%s(%d+)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [keyword] [spell]

    examples:
      $player$ begins to cast Hammer of Wrath.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE3 = "^(%a+)%s(begins to cast)%s([%(%)%a%s'-:]+)%.$"


  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword]

    examples:
      $player$'s Mortal Strike misses you.
      $player$'s Blind misses you.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE4 = "^(%a+)'s%s([%(%)%a%s'-:]+)%s(misses)%syou%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword]

    examples:
      $player$'s Mortal Strike was dodged.
      $player$'s Kick was dodged.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE5 = "^(%a+)'s%s([%(%)%a%s'-:]+)%swas%s(dodged)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword]

    examples:
      $player$'s Kick was parried.
      $player$'s Gouge was parried.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE6 = "^(%a+)'s%s([%(%)%a%s'-:]+)%swas%s(parried)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword]

    examples:
      $player$'s Kick was blocked.
      $player$'s Wing Clip was blocked.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE7 = "^(%a+)'s%s([%(%)%a%s'-:]+)%swas%s(blocked)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword]

    examples:
      $player$'s Counterspell was resisted.
      $player$'s Faerie Fire (Feral) was resisted.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE8 = "^(%a+)'s%s([%(%)%a%s'-:]+)%swas%s(resisted)%.$"

  --[[
    CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword] [keyword]

    examples:
      $player$'s Blind failed. You are immune.
      $player$'s Faerie Fire (Feral) failed. You are immune.
  ]]--
  SPELL_HOSTILEPLAYER_DAMAGE9 = "^(%a+)'s%s([%(%)%a%s'-:]+)%s(failed)%.%sYou%sare%s(immune)%.$"

  --[[
    CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE
    [source] [spell] [keyword]

    examples:
      $player$ is afflicted by Forbearance.
      $player is afflicted by Death Wish.
  ]]--
  SPELL_PERIODIC_HOSTILE_PLAYER_DAMAGE = "^(%a+)%sis%s(afflicted)%sby%s([%(%)%a%s'-:]+)%.$"

  --[[
    CHAT_MSG_SPELL_AURA_GONE_OTHER
    [spell] [keyword] [source]

    examples:
      Fire Reflector fades from $player$.
  ]]--
  SPELL_AURA_GONE_OTHER = "^([%(%)%a%s'-:]+)%s(fades)%sfrom%s(%a+)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [keyword] [target]

    examples:
      Your Kick was blocked by $player$.
      Your Sinister Strike was blocked by $player$.
      Your Eviscerate was blocked by $player$.
  ]]--
  SPELL_SELF_DAMAGE1= "^Your%s([%(%)%a%s'-:]+)%swas%s(blocked)%sby%s(%a+)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [keyword] [target]

    examples:
      Your Wrath was resisted by $player$.
      Your Faerie Fire was resisted by $player$.
      Your Faerie Fire (Feral) was resisted by $player$.

  ]]--
  SPELL_SELF_DAMAGE2 = "^Your%s([%(%)%a%s'-:]+)%swas%s(resisted)%sby%s(%a+)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [keyword] [target] [keyword2]

    examples:
      Your Faerie Fire failed. $player$ is immune.
      Your Silence failed. $player$ is immune.
      Your Faerie Fire (Feral) failed. $player$ is immune.
  ]]--
  SPELL_SELF_DAMAGE3 = "^Your%s([%(%)%a%s'-:]+)%s(failed)%.%s(%a+)%sis%s(immune)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [keyword] [target]

    example:
      Your Bash missed $player$.
      Your Aimed Shot missed $player$.
  ]]--
  SPELL_SELF_DAMAGE4 = "^Your%s([%(%)%a%s'-:]+)%s(missed)%s(%a+)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [keyword] [target]

    examples:
      Your Wing Clip was dodged by $player$.
      Your Disarm was dodged by $player$.
  ]]--
  SPELL_SELF_DAMAGE5 = "^Your%s([%(%)%a%s'-:]+)%swas%s(dodged)%sby%s(%a+)%.$"

  --[[
    CHAT_MSG_SPELL_SELF_DAMAGE
    [spell] [keyword] [target]

    examples:
      Your Disarm is parried by $player$.
      Your Execute is parried by $player$.
  ]]--
  SPELL_SELF_DAMAGE6 = "^Your%s([%(%)%a%s'-:]+)%sis%s(parried)%sby%s(%a+)%.$"

  --[[
    CHAT_MSG_SPELL_FAILED_LOCALPLAYER
    [keyword] [keyword] [spell] [reason]

    examples:
    You fail to cast Lesser Heal: Interrupted.
    You fail to cast Dispel Magic: Another action is in progress.
    You fail to cast Dispel Magic: Nothing to dispel.
    You fail to cast Dispel Magic: Not enough mana.
    You fail to cast Shadow Word: Pain: No target.
    You fail to cast Lesser Heal: Can't do that while moving.
  ]]--
  SPELL_FAILED_LOCALPLAYER1 = "^You%s(fail)%sto%s(cast)%s([%(%)%a%s'-:]+):%s([%a%s']+)%.$"

  --[[
    CHAT_MSG_SPELL_FAILED_LOCALPLAYER
    [keyword] [keyword] [spell] [reason]

    examples:
      You fail to perform Gouge: No target.
      You fail to perform Gouge: Out of range.
      You fail to perform Gouge: You must be in front of your target.
      You fail to perform Gouge: Invalid target.
      You fail to perform Gouge: Not enough energy.
      You fail to perform Gouge: Not yet recovered.
      You fail to perform Charge: Can't do that while disoriented.
      You fail to perform Charge: Target to close.
      You fail to perform Charge: You are in combat.
      You fail to perform Sap: Must be in Stealth.
      You fail to perform Sap: Target is in combat.

    patterns that were encountered but not specifically tested:
      You fail to perform Intercept: Not enough rage.
      You fail to perform Charge: Must be in Battle Stance.
      You fail to perform Charge: Must be in Berserker Stance.
      You fail to perform Shield Wall: Must be in Defensive Stance.
      You fail to perform Shield Wall: Must have a Shield equipped.
      You fail to perform Growl: Must be in Bear Form, Dire Bear Form.
      You fail to perform Growl: Must be in Cat Form.
      You fail to perform Aquatic Form: Can only use while swimming.


  ]]--
  SPELL_FAILED_LOCALPLAYER2 = "^You%s(fail)%sto%s(perform)%s([%(%)%a%s'-:]+):%s([%a%s']+)%.$"

  --[[
     CHAT_MSG_COMBAT_HOSTILE_DEATH
     [source] [keyword]

     examples:
      $player$ dies.
  ]]--
  COMBAT_HOSTILE_DEATH = "^(%a+)%s(dies)%.$"
end

--[[
  @param {string} msg
  @param {string} eventType
  @return {number, table}
    1 if msg could be parsed
    0 if not able to parse msg
    nil if invalid parameters were passed
    nil if message eventType was unknown
]]--
function me.ParseCombatText(msg, eventType)
  if not msg or not eventType then return nil end

  mod.logger.LogDebug(me.tag, "Received combat text message: " .. msg)

  local status = 0, spellData

  if eventType == "CHAT_MSG_SPELL_FAILED_LOCALPLAYER" then
    status, spellData = me.ParseSpellFailedLocalPlayer(msg)
  elseif eventType == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
    status, spellData = me.ParseSpellPeriodicSelfDamage(msg)
  elseif eventType == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS" then
    status, spellData = me.ParseSpellPeriodicHostilePlayerBuffs(msg)
  elseif eventType == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then
    status, spellData = me.ParseSpellHostilePlayerBuff(msg)
  elseif eventType == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" then
    status, spellData = me.ParseSpellHostilePlayerDamage(msg)
  elseif eventType == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
    status, spellData = me.ParseSpellAuraGoneOther(msg)
  elseif eventType == "CHAT_MSG_SPELL_SELF_DAMAGE" then
    status, spellData = me.ParseSpellSelfDamage(msg)
  elseif eventType == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" then
    status, spellData = me.ParseSpellPeriodicHostilePlayerDamage(msg)
  elseif eventType == "CHAT_MSG_COMBAT_HOSTILE_DEATH" then
    status, spellData = me.ParseCombatHostileDeath(msg)
  else
    mod.logger.LogWarn(me.tag, "Received Unknown eventType: " .. eventType)
    return nil
  end

  if status == 1 then
    mod.logger.LogDebug(me.tag, "Successfully parsed combatText")
    return status, spellData
  end

  return status, spellData
end

if (GetLocale() == "deDE") then
  --[[
    Parse combat text for CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellPeriodicHostilePlayerBuffs(msg)
    local eventType = "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS"
    local _, _, source, keyword, spell = string.find(msg, SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS1)

    if source and keyword and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, keyword, spell, charges = string.find(msg, SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS2)

    if source and keyword and spell and charges then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell,
        ["charges"] = charges
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_AURA_GONE_OTHER event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellAuraGoneOther(msg)
    local eventType = "CHAT_MSG_SPELL_AURA_GONE_OTHER"
    local _, _, spell, keyword, source = string.find(msg, SPELL_AURA_GONE_OTHER)

    if spell and keyword and source then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL_DOWN,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["source"] = source,
        ["faded"] = true
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellHostilePlayerBuff(msg)
    local eventType = "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"
    local _, _, source, spell, keyword, _, amount = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF1)

    if source and spell and keyword and amount then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("player: %s spell: %s amount: %s", source, spell, amount))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["amount"] = amount
      }
    end

    local _, _, source, keyword, spell = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF2)

    if source and keyword and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, keyword1, spell, keyword2 = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF3)

    if source and keyword1 and spell and keyword2 then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword1"] = keyword1,
        ["spell"] = spell,
        ["keyword2"] = keyword2
      }
    end

    local _, _, keyword1, source, spell, keyword2, target, amount = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF4)

    if keyword1 and source and spell and keyword2 and target and amount then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s target: %s", source, spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["keyword1"] = keyword1,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword2"] = keyword2,
        ["target"] = target,
        ["amount"] = amount
      }
    end

    local _, _, source, keyword1, amount, resource, keyword2, _, spell = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF5)

    if source and keyword1 and amount and resource and keyword2 and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword1"] = keyword1,
        ["amount"] = amount,
        ["resource"] = resource,
        ["keyword2"] = keyword2,
        ["spell"] = spell
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellPeriodicSelfDamage(msg)
    local eventType = "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"
    local _, _, target, spell, keyword = string.find(msg, SPELL_PERIODIC_SELF_DAMAGE)

    if target and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("target: %s spell: %s", target, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["target"] = target,
        ["spell"] = spell,
        ["keyword"] = keyword
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellHostilePlayerDamage(msg)
    local eventType = "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE"
    local _, _, source, keyword1, target, spell, keyword2, amount = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE1)

    if source and keyword1 and target and spell and keyword2 and amount then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword1"] = keyword1,
        ["target"] = target,
        ["spell"] = spell,
        ["keyword2"] = keyword2,
        ["amount"] = amount
      }
    end

    local _, _, source, keyword1, target, keyword2, spell, keyword3, amount = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE2)

    if source and keyword1 and target and keyword2 and spell and keyword3 and amount then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword1"] = keyword1,
        ["target"] = target,
        ["keyword2"] = keyword2,
        ["spell"] = spell,
        ["keyword3"] = keyword3,
        ["amount"] = amount
      }
    end

    local _, _, source, keyword1, spell, keyword2 = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE3)

    if source and keyword1 and spell and keyword2 then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword1"] = keyword1,
        ["spell"] = spell,
        ["keyword2"] = keyword2
      }
    end

    local _, _, source, keyword1, spell, keyword2, target = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE4)

    if source and keyword1 and spell and keyword2 and target then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["keyword1"] = keyword1,
        ["spell"] = spell,
        ["keyword2"] = keyword2,
        ["target"] = target
      }
    end

    local _, _, source, spell, keyword = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE5)

    if source and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword
      }
    end

    local _, _, source, spell, keyword = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE6)

    if source and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword
      }
    end

    local _, _, source, spell, keyword = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE7)

    if source and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword
      }
    end

    local _, _, source, keyword1, spell, keyword2 = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE8)

    if source and keyword1 and spell and keyword2 then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword1"] = keyword1,
        ["keyword2"] = keyword2
      }
    end

    local _, _, source, keyword1, spell, keyword2, keyword3 = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE9)

    if source and keyword1 and spell and keyword2 and keyword3 then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["keyword1"] = keyword1,
        ["spell"] = spell,
        ["keyword2"] = keyword2,
        ["keyword3"] = keyword3
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellPeriodicHostilePlayerDamage(msg)
    local eventType = "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE"
    local _, _, source, spell, keyword  = string.find(msg, SPELL_PERIODIC_HOSTILE_PLAYER_DAMAGE)

    if source and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_AURA_GONE_OTHER event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellAuraGoneOther(msg)
    local eventType = "CHAT_MSG_SPELL_AURA_GONE_OTHER"
    local _, _, spell, keyword, source = string.find(msg, SPELL_AURA_GONE_OTHER)

    if spell and keyword and source then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL_DOWN,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["source"] = source,
        ["faded"] = true
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_SELF_DAMAGE event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellSelfDamage(msg)
    local eventType = "CHAT_MSG_SPELL_SELF_DAMAGE"
    local _, _, spell, target, keyword = string.find(msg, SPELL_SELF_DAMAGE1)

    if spell and target and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["target"] = target,
        ["keyword"] = keyword
      }
    end

    local _, _, spell, keyword1, target, keyword2 = string.find(msg, SPELL_SELF_DAMAGE2)

    if spell and keyword1 and target and keyword2 then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["target"] = target,
        ["keyword1"] = keyword1,
        ["keyword2"] = keyword2
      }
    end

    local _, _, spell, keyword1, target, keyword2 = string.find(msg, SPELL_SELF_DAMAGE3)

    if spell and keyword1 and target and keyword2 then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["target"] = target,
        ["keyword1"] = keyword1,
        ["keyword2"] = keyword2
      }
    end

    local _, _, spell, target, keyword = string.find(msg, SPELL_SELF_DAMAGE4)

    if spell and target and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["target"] = target
      }
    end

    local _, _, target, spell, keyword = string.find(msg, SPELL_SELF_DAMAGE5)

    if target and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["target"] = target
      }
    end

    local _, _, spell, target, keyword = string.find(msg, SPELL_SELF_DAMAGE6)

    if spell and target and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["target"] = target
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_FAILED_LOCALPLAYER event
    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellFailedLocalPlayer(msg)
    local eventType = "CHAT_MSG_SPELL_FAILED_LOCALPLAYER"
    local _, _, keyword1, keyword2, spell, reason = string.find(msg, SPELL_FAILED_LOCALPLAYER1)

    if keyword1 and keyword2 and spell and reason then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s reason: %s", spell, reason))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.LOCAL_FAILURE,
        ["spell"] = spell,
        ["keyword1"] = keyword1,
        ["keyword2"] = keyword2,
        ["reason"] = reason
      }
    end

    local _, _, keyword1, keyword2, spell, reason = string.find(msg, SPELL_FAILED_LOCALPLAYER2)

    if keyword1 and keyword2 and spell and reason then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s reason: %s", spell, reason))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.LOCAL_FAILURE,
        ["spell"] = spell,
        ["keyword1"] = keyword1,
        ["keyword2"] = keyword2,
        ["reason"] = reason
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_COMBAT_HOSTILE_DEATH event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseCombatHostileDeath(msg)
    local eventType = "CHAT_MSG_COMBAT_HOSTILE_DEATH"
    local _, _, source, keyword = string.find(msg, COMBAT_HOSTILE_DEATH)

    if source and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s ", source))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.HOSTILE_DEATH,
        ["source"] = source,
        ["keyword"] = keyword
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end
else
  --[[
    Parse combat text for CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellPeriodicHostilePlayerBuffs(msg)
    local eventType = "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS"
    local _, _, source, keyword, spell = string.find(msg, SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS1)

    if source and keyword and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, keyword, spell, charges = string.find(msg, SPELL_PERIODIC_HOSTILE_PLAYER_BUFFS2)

    if source and keyword and spell and charges and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell,
        ["charges"] = charges
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellHostilePlayerBuff(msg)
    local eventType = "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"
    local _, _, source, spell, keyword, _, amount = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF1)

    if source and spell and keyword and amount then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s amount: %s", source, spell, amount))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["amount"] = amount
      }
    end

    local _, _, source, keyword, spell = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF2)

    if source and keyword and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, keyword, spell = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF3)

    if source and keyword and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword
      }
    end

    local _, _, source, spell, keyword, _, amount = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF4)

    if source and spell and keyword and amount then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["amount"] = amount
      }
    end

    local _, _, source, keyword1, amount, resource, keyword2, _, spell = string.find(msg, SPELL_HOSTILE_PLAYER_BUFF5)

    if source and keyword1 and amount and resource and keyword2 and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword1"] = keyword1,
        ["amount"] = amount,
        ["resource"] = resource,
        ["keyword2"] = keyword2,
        ["spell"] = spell
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellPeriodicSelfDamage(msg)
    local eventType = "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE"
    local _, _, target, keyword, spell = string.find(msg, SPELL_PERIODIC_SELF_DAMAGE)

    if target and keyword and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("target: %s spell: %s", target, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["target"] = target,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellHostilePlayerDamage(msg)
    local eventType = "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE"
    local _, _, source, spell, keyword, target, damage = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE1)

    if source and spell and keyword and target and damage then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["target"] = target,
        ["damage"] = damage
      }
    end

    local _, _, source, spell, keyword, target, damage = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE2)

    if source and spell and keyword and target and damage then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["target"] = target,
        ["damage"] = damage
      }
    end

    local _, _, source, keyword, spell = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE3)

    if source and keyword and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, spell, keyword = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE4)

    if source and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, spell, keyword = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE5)

    if source and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, spell, keyword = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE6)

    if source and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, spell, keyword = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE7)

    if source and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, spell, keyword = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE8)

    if source and spell and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    local _, _, source, spell, keyword1, keyword2 = string.find(msg, SPELL_HOSTILEPLAYER_DAMAGE9)

    if source and spell and keyword1 and keyword2 then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SELF_AVOIDED,
        ["source"] = source,
        ["spell"] = spell,
        ["keyword1"] = keyword1,
        ["keyword2"] = keyword2
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellPeriodicHostilePlayerDamage(msg)
    local eventType = "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE"
    local _, _, source, keyword, spell = string.find(msg, SPELL_PERIODIC_HOSTILE_PLAYER_DAMAGE)

    if source and keyword and spell then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL,
        ["source"] = source,
        ["keyword"] = keyword,
        ["spell"] = spell
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_AURA_GONE_OTHER event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellAuraGoneOther(msg)
    local eventType = "CHAT_MSG_SPELL_AURA_GONE_OTHER"
    local _, _, spell, keyword, source = string.find(msg, SPELL_AURA_GONE_OTHER)

    if spell and keyword and source then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s spell: %s", source, spell))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.SPELL_DOWN,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["source"] = source,
        ["faded"] = true
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_SELF_DAMAGE event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellSelfDamage(msg)
    local eventType = "CHAT_MSG_SPELL_SELF_DAMAGE"
    local _, _, spell, keyword, target = string.find(msg, SPELL_SELF_DAMAGE1)

    if spell and keyword and target then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["target"] = target,
        ["keyword"] = keyword
      }
    end

    local _, _, spell, keyword, target = string.find(msg, SPELL_SELF_DAMAGE2)

    if spell and keyword and target then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["target"] = target,
        ["keyword"] = keyword
      }
    end

    local _, _, spell, keyword, target = string.find(msg, SPELL_SELF_DAMAGE3)

    if spell and keyword and target then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["target"] = target
      }
    end

    local _, _, spell, keyword, target = string.find(msg, SPELL_SELF_DAMAGE4)

    if spell and keyword and target then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["target"] = target
      }
    end

    local _, _, spell, keyword, target = string.find(msg, SPELL_SELF_DAMAGE5)

    if spell and keyword and target then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["target"] = target
      }
    end

    local _, _, spell, keyword, target = string.find(msg, SPELL_SELF_DAMAGE6)

    if spell and keyword and target then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s target: %s", spell, target))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.ENEMY_AVOIDED,
        ["spell"] = spell,
        ["keyword"] = keyword,
        ["target"] = target
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_SPELL_FAILED_LOCALPLAYER event
    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseSpellFailedLocalPlayer(msg)
    local eventType = "CHAT_MSG_SPELL_FAILED_LOCALPLAYER"
    local _, _, keyword1, keyword2, spell, reason = string.find(msg, SPELL_FAILED_LOCALPLAYER1)

    if keyword1 and keyword2 and spell and reason then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s reason: %s", spell, reason))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.LOCAL_FAILURE,
        ["spell"] = spell,
        ["keyword1"] = keyword1,
        ["keyword2"] = keyword2,
        ["reason"] = reason
      }
    end

    local _, _, keyword1, keyword2, spell, reason = string.find(msg, SPELL_FAILED_LOCALPLAYER2)

    if keyword1 and keyword2 and spell and reason then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("spell: %s reason: %s", spell, reason))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.LOCAL_FAILURE,
        ["spell"] = spell,
        ["keyword1"] = keyword1,
        ["keyword2"] = keyword2,
        ["reason"] = reason
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end

  --[[
    Parse combat text for CHAT_MSG_COMBAT_HOSTILE_DEATH event

    @param {string} msg
      combat text to parse
    @return {number, table}
      1 if msg could be parsed
      0 if not able to parse msg
  ]]--
  function me.ParseCombatHostileDeath(msg)
    local eventType = "CHAT_MSG_COMBAT_HOSTILE_DEATH"
    local _, _, source, keyword = string.find(msg, COMBAT_HOSTILE_DEATH)

    if source and keyword then
      mod.logger.LogDebug(me.tag, eventType .. " detected")
      mod.logger.LogDebug(me.tag, string.format("source: %s ", source))

      return 1, {
        ["type"] = eventType,
        ["spellType"] = LP_CONSTANTS.SPELL_TYPES.HOSTILE_DEATH,
        ["source"] = source,
        ["keyword"] = keyword
      }
    end

    -- unable to parse message
    mod.logger.LogInfo(me.tag, "Failed to parse " .. eventType)
    return 0, {
      ["type"] = eventType
    }
  end
end
