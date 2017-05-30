/**
 * Coded by aimozg on 30.05.2017.
 */
package classes.Scenes.Combat {
import classes.GlobalFlags.kFLAGS;
import classes.GlobalFlags.kGAMECLASS;
import classes.Items.JewelryLib;
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.API.FnHelpers;
import classes.Scenes.Areas.GlacialRift.FrostGiant;
import classes.Scenes.Dungeons.D3.Doppleganger;
import classes.Scenes.Dungeons.D3.JeanClaude;
import classes.Scenes.Dungeons.D3.Lethice;
import classes.Scenes.Dungeons.D3.LivingStatue;
import classes.Scenes.NPCs.Holli;
import classes.Scenes.Places.TelAdre.UmasShop;
import classes.StatusAffects;

public class CombatMagic extends BaseCombatContent {
	public function CombatMagic() {
	}
	internal function applyAutocast():void {
		if (player.findPerk(PerkLib.Spellsword) >= 0 && player.lust < getWhiteMagicLustCap() && player.fatigue + spellCost(30) < player.maxFatigue() && flags[kFLAGS.AUTO_CAST_CHARGE_WEAPON] == 0) {
			spellChargeWeapon(true);
			fatigue(30,1);
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock(); // XXX: message?
		}
		if (player.findPerk(PerkLib.Spellarmor) >= 0 && player.lust < getWhiteMagicLustCap() && player.fatigue + spellCost(40) < player.maxFatigue() && flags[kFLAGS.AUTO_CAST_CHARGE_ARMOR] == 0) {
			spellChargeArmor(true);
			fatigue(40,1);
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock(); // XXX: message?
		}
		if (player.findPerk(PerkLib.Battlemage) >= 0 && (player.findPerk(PerkLib.GreyMage) >= 0 && player.lust >= 30 || player.lust >= 50) && player.fatigue + spellCost(50) < player.maxFatigue() && flags[kFLAGS.AUTO_CAST_MIGHT] == 0) {
			spellMight(true);
			fatigue(50,1);
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock(); // XXX: message?
		}
		if (player.findPerk(PerkLib.Battleflash) >= 0 && (player.findPerk(PerkLib.GreyMage) >= 0 && player.lust >= 30 || player.lust >= 50) && player.fatigue + spellCost(40) < player.maxFatigue() && flags[kFLAGS.AUTO_CAST_BLINK] == 0) {
			spellBlink(true);
			fatigue(40,1);
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock(); // XXX: message?
		}
	}
	internal function cleanupAfterCombatImpl():void {
		fireMagicLastTurn = -100;
		iceMagicLastTurn = -100;
	}
	internal function spellCostImpl(mod:Number):Number {
		//Addiditive mods
		var costPercent:Number = 100;
		if (player.findPerk(PerkLib.SpellcastingAffinity) >= 0) costPercent -= player.perkv1(PerkLib.SpellcastingAffinity);
		if (player.findPerk(PerkLib.WizardsEnduranceAndSluttySeduction) >= 0) costPercent -= player.perkv1(PerkLib.WizardsEnduranceAndSluttySeduction);
		if (player.findPerk(PerkLib.WizardsAndDaoistsEndurance) >= 0) costPercent -= player.perkv1(PerkLib.WizardsAndDaoistsEndurance);
		if (player.findPerk(PerkLib.WizardsEndurance) >= 0) costPercent -= player.perkv1(PerkLib.WizardsEndurance);
		if (player.jewelryName == "fox hairpin") costPercent -= 20;
		if (player.weaponName == "Ascensus") costPercent -= 15;
		//Limiting it and multiplicative mods
		if(player.findPerk(PerkLib.BloodMage) >= 0 && costPercent < 50) costPercent = 50;
		mod *= costPercent/100;
		if (player.findPerk(PerkLib.HistoryScholar) >= 0 || player.findPerk(PerkLib.PastLifeScholar) >= 0) {
			if(mod > 2) mod *= .8;
		}
		if (player.findPerk(PerkLib.BloodMage) >= 0 && mod < 5) mod = 5;
		else if(mod < 2) mod = 2;
		mod = Math.round(mod * 100)/100;
		return mod;
	}
	internal function spellCostWhiteImpl(mod:Number):Number {
		//Addiditive mods
		var costPercent:Number = 100;
		if (player.findPerk(PerkLib.Ambition) >= 0) costPercent -= (100 * player.perkv2(PerkLib.Ambition));
		if (player.findPerk(PerkLib.SpellcastingAffinity) >= 0) costPercent -= player.perkv1(PerkLib.SpellcastingAffinity);
		if (player.findPerk(PerkLib.WizardsEnduranceAndSluttySeduction) >= 0) costPercent -= player.perkv1(PerkLib.WizardsEnduranceAndSluttySeduction);
		if (player.findPerk(PerkLib.WizardsAndDaoistsEndurance) >= 0) costPercent -= player.perkv1(PerkLib.WizardsAndDaoistsEndurance);
		if (player.findPerk(PerkLib.WizardsEndurance) >= 0) costPercent -= player.perkv1(PerkLib.WizardsEndurance);
		if (player.jewelryName == "fox hairpin") costPercent -= 20;
		if (player.weaponName == "Puritas" || player.weaponName == "Ascensus") costPercent -= 15;
		//Limiting it and multiplicative mods
		if(player.findPerk(PerkLib.BloodMage) >= 0 && costPercent < 50) costPercent = 50;
		mod *= costPercent/100;
		if (player.findPerk(PerkLib.HistoryScholar) >= 0 || player.findPerk(PerkLib.PastLifeScholar) >= 0) {
			if(mod > 2) mod *= .8;
		}
		if (player.findPerk(PerkLib.BloodMage) >= 0 && mod < 5) mod = 5;
		else if(mod < 2) mod = 2;
		mod = Math.round(mod * 100)/100;
		return mod;
	}
	internal function spellCostBlackImpl(mod:Number):Number {
		//Addiditive mods
		var costPercent:Number = 100;
		if (player.findPerk(PerkLib.Obsession) >= 0) costPercent -= (100 * player.perkv2(PerkLib.Obsession));
		if (player.findPerk(PerkLib.SpellcastingAffinity) >= 0) costPercent -= player.perkv1(PerkLib.SpellcastingAffinity);
		if (player.findPerk(PerkLib.WizardsEnduranceAndSluttySeduction) >= 0) costPercent -= player.perkv1(PerkLib.WizardsEnduranceAndSluttySeduction);
		if (player.findPerk(PerkLib.WizardsAndDaoistsEndurance) >= 0) costPercent -= player.perkv1(PerkLib.WizardsAndDaoistsEndurance);
		if (player.findPerk(PerkLib.WizardsEndurance) >= 0) costPercent -= player.perkv1(PerkLib.WizardsEndurance);
		if (player.jewelryName == "fox hairpin") costPercent -= 20;
		if (player.weaponName == "Depravatio" || player.weaponName == "Ascensus") costPercent -= 15;
		//Limiting it and multiplicative mods
		if(player.findPerk(PerkLib.BloodMage) >= 0 && costPercent < 50) costPercent = 50;
		mod *= costPercent/100;
		if (player.findPerk(PerkLib.HistoryScholar) >= 0 || player.findPerk(PerkLib.PastLifeScholar) >= 0) {
			if(mod > 2) mod *= .8;
		}
		if (player.findPerk(PerkLib.BloodMage) >= 0 && mod < 5) mod = 5;
		else if(mod < 2) mod = 2;
		mod = Math.round(mod * 100)/100;
		return mod;
	}

	internal function spellModImpl():Number {
		var mod:Number = 1;
		if(player.findPerk(PerkLib.Archmage) >= 0 && player.inte >= 75) mod += .3;
		if(player.findPerk(PerkLib.Channeling) >= 0 && player.inte >= 60) mod += .2;
		if(player.findPerk(PerkLib.GrandArchmage) >= 0 && player.inte >= 100) mod += .4;
		if(player.findPerk(PerkLib.GreyArchmage) >= 0 && player.inte >= 150) mod += 1;
		if(player.findPerk(PerkLib.GreyMage) >= 0 && player.inte >= 125) mod += .7;
		if(player.findPerk(PerkLib.JobSorcerer) >= 0 && player.inte >= 25) mod += .1;
		if(player.findPerk(PerkLib.Mage) >= 0 && player.inte >= 50) mod += .2;
		if(player.findPerk(PerkLib.Spellpower) >= 0 && player.inte >= 50) mod += .1;
		if(player.findPerk(PerkLib.Obsession) >= 0) {
			mod += player.perkv1(PerkLib.Obsession);
		}
		if(player.findPerk(PerkLib.Ambition) >= 0) {
			mod += player.perkv1(PerkLib.Ambition);
		}
		if(player.findPerk(PerkLib.WizardsFocus) >= 0) {
			mod += player.perkv1(PerkLib.WizardsFocus);
		}
		if(player.findPerk(PerkLib.WizardsAndDaoistsFocus) >= 0) {
			mod += player.perkv1(PerkLib.WizardsAndDaoistsFocus);
		}
		if (player.findPerk(PerkLib.ChiReflowMagic) >= 0) mod += UmasShop.NEEDLEWORK_MAGIC_SPELL_MULTI;
		if (player.jewelryEffectId == JewelryLib.MODIFIER_SPELL_POWER) mod += (player.jewelryEffectMagnitude / 100);
		if (player.countCockSocks("blue") > 0) mod += (player.countCockSocks("blue") * .05);
		if (player.findPerk(PerkLib.AscensionMysticality) >= 0) mod *= 1 + (player.perkv1(PerkLib.AscensionMysticality) * 0.1);
		if (player.shieldName == "spirit focus") mod += .2;
		if (player.shieldName == "mana bracer") mod += .5;
		if (player.weapon == weapons.ASCENSU) mod += .15;
		return mod;
	}
	internal function spellModWhiteImpl():Number {
		var mod:Number = 1;
		if(player.findPerk(PerkLib.Archmage) >= 0 && player.inte >= 75) mod += .3;
		if(player.findPerk(PerkLib.Channeling) >= 0 && player.inte >= 60) mod += .2;
		if(player.findPerk(PerkLib.GrandArchmage) >= 0 && player.inte >= 100) mod += .4;
		if(player.findPerk(PerkLib.GreyArchmage) >= 0 && player.inte >= 150) mod += 1;
		if(player.findPerk(PerkLib.GreyMage) >= 0 && player.inte >= 125) mod += .7;
		if(player.findPerk(PerkLib.JobSorcerer) >= 0 && player.inte >= 25) mod += .1;
		if(player.findPerk(PerkLib.Mage) >= 0 && player.inte >= 50) mod += .2;
		if(player.findPerk(PerkLib.Spellpower) >= 0 && player.inte >= 50) mod += .1;
		if(player.findPerk(PerkLib.Ambition) >= 0) {
			mod += player.perkv2(PerkLib.Ambition);
		}
		if(player.findPerk(PerkLib.WizardsFocus) >= 0) {
			mod += player.perkv1(PerkLib.WizardsFocus);
		}
		if(player.findPerk(PerkLib.WizardsAndDaoistsFocus) >= 0) {
			mod += player.perkv1(PerkLib.WizardsAndDaoistsFocus);
		}
		if (player.findPerk(PerkLib.ChiReflowMagic) >= 0) mod += UmasShop.NEEDLEWORK_MAGIC_SPELL_MULTI;
		if (player.jewelryEffectId == JewelryLib.MODIFIER_SPELL_POWER) mod += (player.jewelryEffectMagnitude / 100);
		if (player.countCockSocks("blue") > 0) mod += (player.countCockSocks("blue") * .05);
		if (player.findPerk(PerkLib.AscensionMysticality) >= 0) mod *= 1 + (player.perkv1(PerkLib.AscensionMysticality) * 0.1);
		if (player.shieldName == "spirit focus") mod += .2;
		if (player.shieldName == "mana bracer") mod += .5;
		if (player.weapon == weapons.PURITAS || player.weapon == weapons.ASCENSU) mod += .15;
		return mod;
	}
	internal function spellModBlackImpl():Number {
		var mod:Number = 1;
		if(player.findPerk(PerkLib.Archmage) >= 0 && player.inte >= 75) mod += .3;
		if(player.findPerk(PerkLib.Channeling) >= 0 && player.inte >= 60) mod += .2;
		if(player.findPerk(PerkLib.GrandArchmage) >= 0 && player.inte >= 100) mod += .4;
		if(player.findPerk(PerkLib.GreyArchmage) >= 0 && player.inte >= 150) mod += 1;
		if(player.findPerk(PerkLib.GreyMage) >= 0 && player.inte >= 125) mod += .7;
		if(player.findPerk(PerkLib.JobSorcerer) >= 0 && player.inte >= 25) mod += .1;
		if(player.findPerk(PerkLib.Mage) >= 0 && player.inte >= 50) mod += .2;
		if(player.findPerk(PerkLib.Spellpower) >= 0 && player.inte >= 50) mod += .1;
		if(player.findPerk(PerkLib.Obsession) >= 0) {
			mod += player.perkv2(PerkLib.Obsession);
		}
		if(player.findPerk(PerkLib.WizardsFocus) >= 0) {
			mod += player.perkv1(PerkLib.WizardsFocus);
		}
		if(player.findPerk(PerkLib.WizardsAndDaoistsFocus) >= 0) {
			mod += player.perkv1(PerkLib.WizardsAndDaoistsFocus);
		}
		if (player.findPerk(PerkLib.ChiReflowMagic) >= 0) mod += UmasShop.NEEDLEWORK_MAGIC_SPELL_MULTI;
		if (player.jewelryEffectId == JewelryLib.MODIFIER_SPELL_POWER) mod += (player.jewelryEffectMagnitude / 100);
		if (player.countCockSocks("blue") > 0) mod += (player.countCockSocks("blue") * .05);
		if (player.findPerk(PerkLib.AscensionMysticality) >= 0) mod *= 1 + (player.perkv1(PerkLib.AscensionMysticality) * 0.1);
		if (player.shieldName == "spirit focus") mod += .2;
		if (player.shieldName == "mana bracer") mod += .5;
		if (player.weapon == weapons.DEPRAVA || player.weapon == weapons.ASCENSU) mod += .15;
		return mod;
	}

	public function getWhiteMagicLustCap():Number {
		var whiteLustCap:int = player.maxLust() * 0.75;
		if (player.findPerk(PerkLib.Enlightened) >= 0 && player.cor < (10 + player.corruptionTolerance())) whiteLustCap += (player.maxLust() * 0.1);
		if (player.findPerk(PerkLib.FocusedMind) >= 0 && player.findPerk(PerkLib.GreyMage) < 0) whiteLustCap += (player.maxLust() * 0.1);
		if (player.findPerk(PerkLib.GreyMage) >= 0) whiteLustCap = (player.maxLust() - 45);
		if (player.findPerk(PerkLib.GreyMage) >= 0 && player.findPerk(PerkLib.Enlightened) >= 0 && player.cor < (10 + player.corruptionTolerance())) whiteLustCap = (player.maxLust() - 15);
		return whiteLustCap;
	}


	private var fireMagicLastTurn:int = -100;
	private var fireMagicCumulated:int = 0;
	internal function calcInfernoModImpl(damage:Number):int {
		if (player.findPerk(PerkLib.RagingInferno) >= 0) {
			var multiplier:Number = 1;
			if (combatRound - fireMagicLastTurn == 2) {
				outputText("Traces of your previously used fire magic are still here, and you use them to empower another spell!\n\n");
				switch(fireMagicCumulated) {
					case 0:
					case 1:
						multiplier = 1;
						break;
					case 2:
						multiplier = 1.2;
						break;
					case 3:
						multiplier = 1.35;
						break;
					case 4:
						multiplier = 1.45;
						break;
					default:
						multiplier = 1.5 + ((fireMagicCumulated - 5) * 0.05); //Diminishing returns at max, add 0.05 to multiplier.
				}
				damage = Math.round(damage * multiplier);
				fireMagicCumulated++;
				// XXX: Message?
			} else {
				if (combatRound - fireMagicLastTurn > 2 && fireMagicLastTurn > 0)
					outputText("Unfortunately, traces of your previously used fire magic are too weak to be used.\n\n");
				fireMagicCumulated = 1;
			}
			fireMagicLastTurn = combatRound;
		}
		return damage;
	}

	private var iceMagicLastTurn:int = -100;
	private var iceMagicCumulated:int = 0;
	internal function calcGlacialModImpl(damage:Number):int {
		if (player.findPerk(PerkLib.GlacialStorm) >= 0) {
			var multiplier:Number = 1;
			if (combatRound - iceMagicLastTurn == 2) {
				outputText("Traces of your previously used ice magic are still here, and you use them to empower another spell!\n\n");
				switch(iceMagicCumulated) {
					case 0:
					case 1:
						multiplier = 1;
						break;
					case 2:
						multiplier = 1.2;
						break;
					case 3:
						multiplier = 1.35;
						break;
					case 4:
						multiplier = 1.45;
						break;
					default:
						multiplier = 1.5 + ((iceMagicCumulated - 5) * 0.05); //Diminishing returns at max, add 0.05 to multiplier.
				}
				damage = Math.round(damage * multiplier);
				iceMagicCumulated++;
				// XXX: Message?
			} else {
				if (combatRound - iceMagicLastTurn > 2 && iceMagicLastTurn > 0)
					outputText("Unfortunately, traces of your previously used ice magic are too weak to be used.\n\n");
				iceMagicCumulated = 1;
			}
			iceMagicLastTurn = combatRound;
		}
		return damage;
	}

	public function magicMenu():void {
	//Pass false to combatMenu instead:	menuLoc = 3;
		if (inCombat && player.hasStatusAffect(StatusAffects.Sealed) && (player.statusAffectv2(StatusAffects.Sealed) == 2 || player.statusAffectv2(StatusAffects.Sealed) == 10)) {
			clearOutput();
			if (player.statusAffectv2(StatusAffects.Sealed) == 2) outputText("You reach for your magic, but you just can't manage the focus necessary.  <b>Your ability to use magic was sealed, and now you've wasted a chance to attack!</b>\n\n");
			if (player.statusAffectv2(StatusAffects.Sealed) == 10) outputText("You try to use magic but you are currently silenced by the alraune vines!\n\n");
			enemyAI();
			return;
		}
		menu();
		clearOutput();
		outputText("What spell will you use?\n\n");
		//WHITE SHITZ
		var whiteLustCap:int = getWhiteMagicLustCap();
		if (player.lust >= whiteLustCap)
			outputText("You are far too aroused to focus on white magic.\n\n");
		else {
			if (player.hasStatusAffect(StatusAffects.KnowsBlind)) {
				if (!monster.hasStatusAffect(StatusAffects.Blind))
					addButton(0, "Blind", spellBlind, null, null, null, "Blind is a fairly self-explanatory spell.  It will create a bright flash just in front of the victim's eyes, blinding them for a time.  However if they blink it will be wasted.  \n\nFatigue Cost: " + spellCostWhite(30) + "");
				else {
					outputText("<b>" + monster.capitalA + monster.short + " is already affected by blind.</b>\n\n");
					addButtonDisabled(0, "Blind", "Enemy still blinded");
				}
			}
			if (player.hasStatusAffect(StatusAffects.KnowsWhitefire)) addButton(2, "Whitefire", spellWhitefire, null, null, null, "Whitefire is a potent fire based attack that will burn your foe with flickering white flames, ignoring their physical toughness and most armors.  \n\nFatigue Cost: " + spellCostWhite(40) + "");
			if (player.hasStatusAffect(StatusAffects.KnowsLightningBolt)) addButton(3, "LightningBolt", spellLightningBolt, null, null, null, "Lightning Bolt is a basic lightning attack that will electrocute your foe with a single bolt of lightning.  \n\nFatigue Cost: " + spellCostWhite(40) + "");
		}
		//BLACK MAGICSKS
		if (player.lust < 50 && player.findPerk(PerkLib.GreyMage) < 0)
			outputText("You aren't turned on enough to use any black magics.\n\n");
		else if (player.lust < 30 && player.findPerk(PerkLib.GreyMage) >= 0)
			outputText("You aren't turned on enough to use any black magics.\n\n");
		else {
			if (player.hasStatusAffect(StatusAffects.KnowsArouse)) addButton(5, "Arouse", spellArouse, null, null, null, "The arouse spell draws on your own inner lust in order to enflame the enemy's passions.  \n\nFatigue Cost: " + spellCostBlack(20) + "");
			if (player.hasStatusAffect(StatusAffects.KnowsHeal)) addButton(6, "Heal", spellHeal, null, null, null, "Heal will attempt to use black magic to close your wounds and restore your body, however like all black magic used on yourself, it has a chance of backfiring and greatly arousing you.  \n\nFatigue Cost: " + spellCostBlack(30) + "");
			if (player.hasStatusAffect(StatusAffects.KnowsIceSpike)) addButton(7, "Ice Spike", spellIceSpike, null, null, null, "Drawning your own lust to concentrate it into chilling spike of ice that will attack your enemies.  \n\nFatigue Cost: " + spellCostBlack(40) + "");
			if (player.hasStatusAffect(StatusAffects.KnowsDarknessShard)) addButton(8, "DarknessShard", spellDarknessShard, null, null, null, "Drawning your own lust to condense part of the the ambivalent darkness into a shard to attack your enemies.  \n\nFatigue Cost: " + spellCostBlack(40) + "");
		}
		addButton(10, "Support", magicMenu2, null, null, null, "Cast one of support spells.");
		if (player.findPerk(PerkLib.GreyMage) >= 0) addButton(11, "Grey Spells", magicMenu3, null, null, null, "Cast one of Grey Magic spells.");
		// JOJO ABILITIES -- kind makes sense to stuff it in here along side the white magic shit (also because it can't fit into M. Specials :|
		if (player.findPerk(PerkLib.CleansingPalm) >= 0 && player.cor < (10 + player.corruptionTolerance())) {
			addButton(12, "C.Palm", spellCleansingPalm, null, null, null, "Unleash the power of your cleansing aura! More effective against corrupted opponents. Doesn't work on the pure.  \n\nFatigue Cost: " + spellCost(30) + "", "Cleansing Palm");
		}
		addButton(14, "Back", combatMenu, false);
	}

	public function magicMenu2():void {
		menu();
		clearOutput();
		outputText("What supportive spell will you use?\n\n");
		var whiteLustCap2:int = getWhiteMagicLustCap();
		if (player.lust >= whiteLustCap2)
			outputText("You are far too aroused to focus on white magic.\n\n");
		else {
			if (player.hasStatusAffect(StatusAffects.KnowsCharge)) {
				if (!player.hasStatusAffect(StatusAffects.ChargeWeapon))
					addButton(0, "Charge W.", spellChargeWeapon, null, null, null, "The Charge Weapon spell will surround your weapon in electrical energy, causing it to do even more damage.  The effect lasts for the entire combat.  \n\nFatigue Cost: " + spellCostWhite(30) + "", "Charge Weapon");
				else {
					outputText("<b>Charge weapon is already active and cannot be cast again.</b>\n\n");
					addButtonDisabled(0, "Charge W.", "Active");
				}
			}
			if (player.hasStatusAffect(StatusAffects.KnowsChargeA)) {
				if (!player.hasStatusAffect(StatusAffects.ChargeArmor))
					addButton(1, "Charge A.", spellChargeArmor, null, null, null, "The Charge Armor spell will surround your armor with electrical energy, causing it to do provide additional protection.  The effect lasts for the entire combat.  \n\nFatigue Cost: " + spellCostWhite(40) + "", "Charge Armor");
				else {
					outputText("<b>Charge armor is already active and cannot be cast again.</b>\n\n");
					addButtonDisabled(1, "Charge A.", "Active");
				}
			}
			if (player.hasStatusAffect(StatusAffects.KnowsBlizzard)) {
				if (!player.hasStatusAffect(StatusAffects.Blizzard))
					addButton(4, "Blizzard", spellBlizzard, null, null, null, "Blizzard is a potent ice based defense spell that will reduce power of any fire based attack used against the user.  \n\nFatigue Cost: " + spellCostWhite(50) + "");
				else {
					outputText("<b>Blizzard is already active and cannot be cast again.</b>\n\n");
					addButtonDisabled(4, "Blizzard", "Active");
				}
			}
		}
		if (player.lust < 50 && player.findPerk(PerkLib.GreyMage) < 0)
			outputText("You aren't turned on enough to use any black magics.\n\n");
		else if (player.lust < 30 && player.findPerk(PerkLib.GreyMage) >= 0)
			outputText("You aren't turned on enough to use any black magics.\n\n");
		else {
			if (player.hasStatusAffect(StatusAffects.KnowsMight)) {
				if (!player.hasStatusAffect(StatusAffects.Might))
					addButton(5, "Might", spellMight, null, null, null, "The Might spell draws upon your lust and uses it to fuel a temporary increase in muscle size and power.  It does carry the risk of backfiring and raising lust, like all black magic used on oneself.  \n\nFatigue Cost: " + spellCostBlack(50) + "");
				else {
					outputText("<b>You are already under the effects of Might and cannot cast it again.</b>\n\n");
					addButtonDisabled(5, "Might", "Active");
				}
			}
			if (player.hasStatusAffect(StatusAffects.KnowsBlink)) {
				if (!player.hasStatusAffect(StatusAffects.Blink))
					addButton(6, "Blink", spellBlink, null, null, null, "The Blink spell draws upon your lust and uses it to fuel a temporary increase in moving speed and if it's needed teleport over short distances.  It does carry the risk of backfiring and raising lust, like all black magic used on oneself.  \n\nFatigue Cost: " + spellCostBlack(40) + "");
				else {
					outputText("<b>You are already under the effects of Blink and cannot cast it again.</b>\n\n");
					addButtonDisabled(6, "Blink", "Active");
				}
			}
		}
		addButton(14, "Back", magicMenu);
	}

	public function magicMenu3():void {
		menu();
		clearOutput();
		outputText("What grey spell will you use?\n\n");
		if (player.lust < 50 || player.lust > (player.maxLust() - 50))
			outputText("You can't use any grey magics.\n\n");
		else {
			/*	if (player.hasStatusAffect(StatusAffects.Knows)) addButton(2, "	1st spell (non-fire or non-ice based) goes here
			 if (player.hasStatusAffect(StatusAffects.Knows)) addButton(2, "	2nd spell (non-fire or non-ice based) goes here
			 if (player.hasStatusAffect(StatusAffects.KnowsWereBeast)) addButton(2, "Were-beast",	were-beast spell goes here
			 */	if (player.hasStatusAffect(StatusAffects.KnowsFireStorm)) addButton(5, "Fire Storm", spellFireStorm, null, null, null, "Drawning your own lust and force of the willpower to fuel radical change in the surrounding you can call forth an Fire Storm that will attack enemies in a wide area.  Despite been grey magic it still does carry the risk of backfiring and raising lust.  \n\n<b>AoE Spell.</b>  \n\nFatigue Cost: " + spellCost(200) + "");
			//	if (player.hasStatusAffect(StatusAffects.Knows)) addButton(6, "	fire single target spell goes here
			if (player.hasStatusAffect(StatusAffects.KnowsIceRain)) addButton(10, "Ice Rain", spellIceRain, null, null, null, "Drawning your own lust and force of the willpower to fuel radical change in the surrounding you can call forth an Ice Rain that will attack enemies in a wide area.  Despite been grey magic it still does carry the risk of backfiring and raising lust.  \n\n<b>AoE Spell.</b>  \n\nFatigue Cost: " + spellCost(200) + "");
			//	if (player.hasStatusAffect(StatusAffects.Knows)) addButton(11, "	ice single target spell goes here
		}
		addButton(14, "Back", magicMenu);
	}


	public function spellArouse():void {
		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(20) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(20,6);
		statScreenRefresh();
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		if(monster.hasStatusAffect(StatusAffects.Shell)) {
			outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}
		outputText("You make a series of arcane gestures, drawing on your own lust to inflict it upon your foe!\n", true);
		//Worms be immune
		if(monster.short == "worms") {
			outputText("The worms appear to be unaffected by your magic!", false);
			outputText("\n\n", false);
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			doNext(playerMenu);
			if(monster.lust >= monster.eMaxLust()) doNext(endLustVictory);
			else enemyAI();
			return;
		}
		if(monster.lustVuln == 0) {
			outputText("It has no effect!  Your foe clearly does not experience lust in the same way as you.\n\n", false);
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}
		var lustDmg:Number = monster.lustVuln * (player.inte / 5 * spellModBlack() + rand(monster.lib - monster.inte * 2 + monster.cor) / 5);
		if(player.findPerk(PerkLib.ArcaneLash) >= 0) lustDmg *= 1.5;
		if(monster.lust < (monster.eMaxLust() * 0.3)) outputText(monster.capitalA + monster.short + " squirms as the magic affects " + monster.pronoun2 + ".  ", false);
		if(monster.lust >= (monster.eMaxLust() * 0.3) && monster.lust < (monster.eMaxLust() * 0.6)) {
			if(monster.plural) outputText(monster.capitalA + monster.short + " stagger, suddenly weak and having trouble focusing on staying upright.  ", false);
			else outputText(monster.capitalA + monster.short + " staggers, suddenly weak and having trouble focusing on staying upright.  ", false);
		}
		if(monster.lust >= (monster.eMaxLust() * 0.6)) {
			outputText(monster.capitalA + monster.short + "'");
			if(!monster.plural) outputText("s");
			outputText(" eyes glaze over with desire for a moment.  ", false);
		}
		if(monster.cocks.length > 0) {
			if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.cocks.length > 0) outputText("You see " + monster.pronoun3 + " " + monster.multiCockDescriptLight() + " dribble pre-cum.  ", false);
			if(monster.lust >= (monster.eMaxLust() * 0.3) && monster.lust < (monster.eMaxLust() * 0.6) && monster.cocks.length == 1) outputText(monster.capitalA + monster.short + "'s " + monster.cockDescriptShort(0) + " hardens, distracting " + monster.pronoun2 + " further.  ", false);
			if(monster.lust >= (monster.eMaxLust() * 0.3) && monster.lust < (monster.eMaxLust() * 0.6) && monster.cocks.length > 1) outputText("You see " + monster.pronoun3 + " " + monster.multiCockDescriptLight() + " harden uncomfortably.  ", false);
		}
		if(monster.vaginas.length > 0) {
			if(monster.plural) {
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_NORMAL) outputText(monster.capitalA + monster.short + "'s " + monster.vaginaDescript() + "s dampen perceptibly.  ", false);
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_WET) outputText(monster.capitalA + monster.short + "'s crotches become sticky with girl-lust.  ", false);
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_SLICK) outputText(monster.capitalA + monster.short + "'s " + monster.vaginaDescript() + "s become sloppy and wet.  ", false);
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_DROOLING) outputText("Thick runners of girl-lube stream down the insides of " + monster.a + monster.short + "'s thighs.  ", false);
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_SLAVERING) outputText(monster.capitalA + monster.short + "'s " + monster.vaginaDescript() + "s instantly soak " + monster.pronoun2 + " groin.  ", false);
			}
			else {
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_NORMAL) outputText(monster.capitalA + monster.short + "'s " + monster.vaginaDescript() + " dampens perceptibly.  ", false);
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_WET) outputText(monster.capitalA + monster.short + "'s crotch becomes sticky with girl-lust.  ", false);
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_SLICK) outputText(monster.capitalA + monster.short + "'s " + monster.vaginaDescript() + " becomes sloppy and wet.  ", false);
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_DROOLING) outputText("Thick runners of girl-lube stream down the insides of " + monster.a + monster.short + "'s thighs.  ", false);
				if(monster.lust >= (monster.eMaxLust() * 0.6) && monster.vaginas[0].vaginalWetness == VAGINA_WETNESS_SLAVERING) outputText(monster.capitalA + monster.short + "'s " + monster.vaginaDescript() + " instantly soaks her groin.  ", false);
			}
		}
		monster.teased(lustDmg);
		outputText("\n\n", false);
		doNext(playerMenu);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		if(monster.lust >= monster.eMaxLust()) doNext(endLustVictory);
		else enemyAI();
	}
	public function spellHeal():void {
		if(/*player.findPerk(PerkLib.BloodMage) < 0 && */player.fatigue + spellCost(30) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(30, 8);
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You focus on your body and its desire to end pain, trying to draw on your arousal without enhancing it.\n", true);
		//30% backfire!
		var backfire:int = 30;
		if (player.findPerk(PerkLib.FocusedMind) >= 0) backfire = 20;
		backfire -= (player.inte * 0.15);
		if (backfire < 15) backfire = 15;
		else if (backfire < 5 && player.findPerk(PerkLib.FocusedMind) >= 0) backfire = 5;
		if(rand(100) < backfire) {
			outputText("An errant sexual thought crosses your mind, and you lose control of the spell!  Your ", false);
			if(player.gender == 0) outputText(assholeDescript() + " tingles with a desire to be filled as your libido spins out of control.", false);
			if(player.gender == 1) {
				if(player.cockTotal() == 1) outputText(player.cockDescript(0) + " twitches obscenely and drips with pre-cum as your libido spins out of control.", false);
				else outputText(player.multiCockDescriptLight() + " twitch obscenely and drip with pre-cum as your libido spins out of control.", false);
			}
			if(player.gender == 2) outputText(vaginaDescript(0) + " becomes puffy, hot, and ready to be touched as the magic diverts into it.", false);
			if(player.gender == 3) outputText(vaginaDescript(0) + " and " + player.multiCockDescriptLight() + " overfill with blood, becoming puffy and incredibly sensitive as the magic focuses on them.", false);
			dynStats("lib", .25, "lus", 15);
		}
		else spellHealEffect();
		outputText("\n\n", false);
		statScreenRefresh();
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		if(player.lust >= player.maxLust()) doNext(endLustLoss);
		else enemyAI();
	}

	public function spellHealEffect():void {
		temp = 0;
		temp += inteligencescalingbonus();
		temp *= spellModBlack();
		if (player.unicornScore() >= 5) temp *= ((player.unicornScore() - 4) * 0.5);
		if (player.alicornScore() >= 6) temp *= ((player.alicornScore() - 5) * 0.5);
		if (player.armorName == "skimpy nurse's outfit") temp *= 1.2;
		//Determine if critical heal!
		var crit:Boolean = false;
		var critHeal:int = 5;
		if (player.findPerk(PerkLib.Tactician) >= 0 && player.inte >= 50) {
			if (player.inte <= 100) critHeal += (player.inte - 50) / 50;
			if (player.inte > 100) critHeal += 10;
		}
		if (rand(100) < critHeal) {
			crit = true;
			temp *= 1.75;
		}
		temp = Math.round(temp);
		outputText("You flush with success as your wounds begin to knit <b>(<font color=\"#008000\">+" + temp + "</font>)</b>.", false);
		if (crit == true) outputText(" <b>*Critical Heal!*</b>", false);
		HPChange(temp,false);
	}
	/**
	 * Generates from (x1,x2,x3,y1,y2) log-scale parameters (a,b,c) that will return:
	 * y1= 10 at x1=  10
	 * y2= 55 at x2= 100
	 * y3=100 at x3=1000
	 */
	private static const MightABC:Object = FnHelpers.FN.buildLogScaleABC(10,100,1000,10,100);
//(25) Might – increases strength/toughness by 5 * (Int / 10) * spellMod, up to a
//maximum of 15, allows it to exceed the maximum.  Chance of backfiring
//and increasing lust by 15.
	public function spellMight(silent:Boolean = false):void {

		var doEffect:Function = function():* {
			var MightBoost:Number = 10;
			if (player.findPerk(PerkLib.JobSorcerer) >= 0 && player.inte >= 25) MightBoost += 5;
			if (player.findPerk(PerkLib.Spellpower) >= 0 && player.inte >= 50) MightBoost += 5;
			if (player.findPerk(PerkLib.Mage) >= 0 && player.inte >= 50) MightBoost += 10;
			if (player.findPerk(PerkLib.FocusedMind) >= 0 && player.inte >= 50) MightBoost += 10;
			if (player.findPerk(PerkLib.Channeling) >= 0 && player.inte >= 60) MightBoost += 10;
			if (player.findPerk(PerkLib.Archmage) >= 0 && player.inte >= 75) MightBoost += 15;
			if (player.findPerk(PerkLib.GrandArchmage) >= 0 && player.inte >= 100) MightBoost += 20;
			if (player.findPerk(PerkLib.GreyMage) >= 0 && player.inte >= 125) MightBoost += 25;
			if (player.findPerk(PerkLib.GreyArchmage) >= 0 && player.inte >= 150) MightBoost += 30;
			if (player.findPerk(PerkLib.JobEnchanter) >= 0 && player.inte >= 50) MightBoost += 5;
			if (player.findPerk(PerkLib.Battlemage) >= 0 && player.inte >= 50) MightBoost += 15;
			if (player.findPerk(PerkLib.JobBarbarian) >= 0) MightBoost -= 10;
			if (player.findPerk(PerkLib.JobBrawler) >= 0) MightBoost -= 10;
			if (player.findPerk(PerkLib.JobDervish) >= 0) MightBoost -= 10;
			if (player.findPerk(PerkLib.IronFistsI) >= 0) MightBoost -= 10;
			if (player.findPerk(PerkLib.JobMonk) >= 0) MightBoost -= 15;
			if (player.findPerk(PerkLib.Berzerker) >= 0) MightBoost -= 15;
			if (player.findPerk(PerkLib.Lustzerker) >= 0) MightBoost -= 15;
			if (player.findPerk(PerkLib.WeaponMastery) >= 0) MightBoost -= 15;
			if (player.findPerk(PerkLib.WeaponGrandMastery) >= 0) MightBoost -= 25;
			if (player.findPerk(PerkLib.HeavyArmorProficiency) >= 0) MightBoost -= 15;
			if (player.findPerk(PerkLib.AyoArmorProficiency) >= 0) MightBoost -= 20;
			if (player.findPerk(PerkLib.Agility) >= 0) MightBoost -= 10;
			if (player.findPerk(PerkLib.LightningStrikes) >= 0) MightBoost -= 10;
			if (player.findPerk(PerkLib.BodyCultivator) >= 0) MightBoost -= 5;
			//	MightBoost += player.inte / 10;player.inte * 0.1 - może tylko jak bedzie mieć perk z prestige job: magus/warock/inny związany z spells
			if (MightBoost < 10) MightBoost = 10;
			if (player.findPerk(PerkLib.JobEnchanter) >= 0) MightBoost *= 1.2;
			MightBoost *= spellModBlack();
			MightBoost = FnHelpers.FN.logScale(MightBoost,MightABC,10);
			MightBoost = Math.round(MightBoost);
			player.createStatusAffect(StatusAffects.Might,0,0,0,0);
			temp = MightBoost;
			tempStr = temp;
			tempTou = temp;
			//if(player.str + temp > 100) tempStr = 100 - player.str;
			//if(player.tou + temp > 100) tempTou = 100 - player.tou;
			player.changeStatusValue(StatusAffects.Might,1,tempStr);
			player.changeStatusValue(StatusAffects.Might,2,tempTou);
			mainView.statsView.showStatUp('str');
			// strUp.visible = true;
			// strDown.visible = false;
			mainView.statsView.showStatUp('tou');
			// touUp.visible = true;
			// touDown.visible = false;
			player.str += player.statusAffectv1(StatusAffects.Might);
			player.tou += player.statusAffectv2(StatusAffects.Might);
			statScreenRefresh();
		};

		if (silent)	{ // for Battlemage
			doEffect.call();
			return;
		}

		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(50) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu2);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(50,6);
		var tempStr:Number = 0;
		var tempTou:Number = 0;
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You flush, drawing on your body's desires to empower your muscles and toughen you up.\n\n", true);
		//30% backfire!
		var backfire:int = 30;
		if (player.findPerk(PerkLib.FocusedMind) >= 0) backfire = 20;
		if (backfire < 15) backfire = 15;
		else if (backfire < 5 && player.findPerk(PerkLib.FocusedMind) >= 0) backfire = 5;
		if(rand(100) < backfire) {
			outputText("An errant sexual thought crosses your mind, and you lose control of the spell!  Your ", false);
			if(player.gender == 0) outputText(assholeDescript() + " tingles with a desire to be filled as your libido spins out of control.", false);
			if(player.gender == 1) {
				if(player.cockTotal() == 1) outputText(player.cockDescript(0) + " twitches obscenely and drips with pre-cum as your libido spins out of control.", false);
				else outputText(player.multiCockDescriptLight() + " twitch obscenely and drip with pre-cum as your libido spins out of control.", false);
			}
			if(player.gender == 2) outputText(vaginaDescript(0) + " becomes puffy, hot, and ready to be touched as the magic diverts into it.", false);
			if(player.gender == 3) outputText(vaginaDescript(0) + " and " + player.multiCockDescriptLight() + " overfill with blood, becoming puffy and incredibly sensitive as the magic focuses on them.", false);
			dynStats("lib", .25, "lus", 15);
		}
		else {
			outputText("The rush of success and power flows through your body.  You feel like you can do anything!", false);
			doEffect.call();
		}
		outputText("\n\n", false);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		if(player.lust >= player.maxLust()) doNext(endLustLoss);
		else enemyAI();
	}

	/**
	 * Generates from (x1,x2,x3,y1,y2) log-scale parameters (a,b,c) that will return:
	 * y1= 10 at x1=  10
	 * y2= 55 at x2= 100
	 * y3=100 at x3=1000
	 */
	private static const BlinkABC:Object = FnHelpers.FN.buildLogScaleABC(10,100,1000,10,100);
//(25) Blink – increases speed by 5 * (Int / 10) * spellMod, up to a
//maximum of 15, allows it to exceed the maximum.  Chance of backfiring
//and increasing lust by 15.
	public function spellBlink(silent:Boolean = false):void {

		var doEffect:Function = function():* {
			var BlinkBoost:Number = 10;
			if (player.findPerk(PerkLib.JobSorcerer) >= 0 && player.inte >= 25) BlinkBoost += 5;
			if (player.findPerk(PerkLib.Spellpower) >= 0 && player.inte >= 50) BlinkBoost += 5;
			if (player.findPerk(PerkLib.Mage) >= 0 && player.inte >= 50) BlinkBoost += 10;
			if (player.findPerk(PerkLib.FocusedMind) >= 0 && player.inte >= 50) BlinkBoost += 10;
			if (player.findPerk(PerkLib.Channeling) >= 0 && player.inte >= 60) BlinkBoost += 10;
			if (player.findPerk(PerkLib.Archmage) >= 0 && player.inte >= 75) BlinkBoost += 15;
			if (player.findPerk(PerkLib.GrandArchmage) >= 0 && player.inte >= 100) BlinkBoost += 20;
			if (player.findPerk(PerkLib.GreyMage) >= 0 && player.inte >= 125) BlinkBoost += 25;
			if (player.findPerk(PerkLib.GreyArchmage) >= 0 && player.inte >= 150) BlinkBoost += 30;
			if (player.findPerk(PerkLib.JobEnchanter) >= 0 && player.inte >= 50) BlinkBoost += 5;
			if (player.findPerk(PerkLib.Battleflash) >= 0 && player.inte >= 50) BlinkBoost += 15;
			if (player.findPerk(PerkLib.JobBarbarian) >= 0) BlinkBoost -= 10;
			if (player.findPerk(PerkLib.JobBrawler) >= 0) BlinkBoost -= 10;
			if (player.findPerk(PerkLib.JobDervish) >= 0) BlinkBoost -= 10;
			if (player.findPerk(PerkLib.IronFistsI) >= 0) BlinkBoost -= 10;
			if (player.findPerk(PerkLib.JobMonk) >= 0) BlinkBoost -= 15;
			if (player.findPerk(PerkLib.Berzerker) >= 0) BlinkBoost -= 15;
			if (player.findPerk(PerkLib.Lustzerker) >= 0) BlinkBoost -= 15;
			if (player.findPerk(PerkLib.WeaponMastery) >= 0) BlinkBoost -= 15;
			if (player.findPerk(PerkLib.WeaponGrandMastery) >= 0) BlinkBoost -= 25;
			if (player.findPerk(PerkLib.HeavyArmorProficiency) >= 0) BlinkBoost -= 15;
			if (player.findPerk(PerkLib.AyoArmorProficiency) >= 0) BlinkBoost -= 20;
			if (player.findPerk(PerkLib.Agility) >= 0) BlinkBoost -= 10;
			if (player.findPerk(PerkLib.LightningStrikes) >= 0) BlinkBoost -= 10;
			if (player.findPerk(PerkLib.BodyCultivator) >= 0) BlinkBoost -= 5;
			//	BlinkBoost += player.inte / 10;player.inte * 0.1 - może tylko jak bedzie mieć perk z prestige job: magus/warock/inny związany z spells
			if (BlinkBoost < 10) BlinkBoost = 10;
			BlinkBoost *= 1.2;
			if (player.findPerk(PerkLib.JobEnchanter) >= 0) BlinkBoost *= 1.25;
			BlinkBoost *= spellModBlack();
			BlinkBoost = FnHelpers.FN.logScale(BlinkBoost,BlinkABC,10);
			BlinkBoost = Math.round(BlinkBoost);
			player.createStatusAffect(StatusAffects.Blink,0,0,0,0);
			temp = BlinkBoost;
			tempSpe = temp;
			//if(player.spe + temp > 100) tempSpe = 100 - player.spe;
			player.changeStatusValue(StatusAffects.Blink,1,tempSpe);
			mainView.statsView.showStatUp('spe');
			// strUp.visible = true;
			// strDown.visible = false;
			player.spe += player.statusAffectv1(StatusAffects.Blink);
			statScreenRefresh();
		};

		if (silent)	{ // for Battleflash
			doEffect.call();
			return;
		}

		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(40) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu2);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(40,6);
		var tempSpe:Number = 0;
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You flush, drawing on your body's desires to empower your muscles and hasten you up.\n\n", true);
		//30% backfire!
		var backfire:int = 30;
		if (player.findPerk(PerkLib.FocusedMind) >= 0) backfire = 20;
		if (backfire < 15) backfire = 15;
		else if (backfire < 5 && player.findPerk(PerkLib.FocusedMind) >= 0) backfire = 5;
		if(rand(100) < backfire) {
			outputText("An errant sexual thought crosses your mind, and you lose control of the spell!  Your ", false);
			if(player.gender == 0) outputText(assholeDescript() + " tingles with a desire to be filled as your libido spins out of control.", false);
			if(player.gender == 1) {
				if(player.cockTotal() == 1) outputText(player.cockDescript(0) + " twitches obscenely and drips with pre-cum as your libido spins out of control.", false);
				else outputText(player.multiCockDescriptLight() + " twitch obscenely and drip with pre-cum as your libido spins out of control.", false);
			}
			if(player.gender == 2) outputText(vaginaDescript(0) + " becomes puffy, hot, and ready to be touched as the magic diverts into it.", false);
			if(player.gender == 3) outputText(vaginaDescript(0) + " and " + player.multiCockDescriptLight() + " overfill with blood, becoming puffy and incredibly sensitive as the magic focuses on them.", false);
			dynStats("lib", .25, "lus", 15);
		}
		else {
			outputText("The rush of success and power flows through your body.  You feel like you can do anything!", false);
			doEffect.call();
		}
		outputText("\n\n", false);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		if(player.lust >= player.maxLust()) doNext(endLustLoss);
		else enemyAI();
	}

//(45) Ice Spike - ice version of whitefire
	public function spellIceSpike():void {
		flags[kFLAGS.LAST_ATTACK_TYPE] = 2;
		clearOutput();
		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(40) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(40,6);
		if(monster.hasStatusAffect(StatusAffects.Shell)) {
			outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}
		//if (monster is Doppleganger)
		//{
		//(monster as Doppleganger).handleSpellResistance("whitefire");
		//flags[kFLAGS.SPELLS_CAST]++;
		//if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		//spellPerkUnlock();
		//return;
		//}
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You narrow your eyes, focusing your own lust with deadly intent.  At the palm of your hand form ice spike that shots toward " + monster.a + monster.short + " !\n", true);
		temp = 0;
		temp += inteligencescalingbonus();
		temp *= spellModBlack();
		//Determine if critical hit!
		var crit:Boolean = false;
		var critChance:int = 5;
		if (player.findPerk(PerkLib.Tactician) >= 0 && player.inte >= 50) {
			if (player.inte <= 100) critChance += (player.inte - 50) / 50;
			if (player.inte > 100) critChance += 10;
		}
		if (rand(100) < critChance) {
			crit = true;
			temp *= 1.75;
		}
		//High damage to goes.
		temp = calcGlacialMod(temp);
		if (monster.findPerk(PerkLib.IceNature) >= 0) temp *= 0.2;
		if (monster.findPerk(PerkLib.FireVulnerability) >= 0) temp *= 0.5;
		if (monster.findPerk(PerkLib.IceVulnerability) >= 0) temp *= 2;
		if (monster.findPerk(PerkLib.FireNature) >= 0) temp *= 5;
		if (player.findPerk(PerkLib.ColdMastery) >= 0) temp *= 2;
		if (player.findPerk(PerkLib.ColdAffinity) >= 0) temp *= 2;
		temp = Math.round(temp);
		//if (monster.short == "goo-girl") temp = Math.round(temp * 1.5); - pomyśleć czy bdą dostawać bonusowe obrażenia
		//if (monster.short == "tentacle beast") temp = Math.round(temp * 1.2); - tak samo przemyśleć czy bedą dodatkowo ranione
		outputText(monster.capitalA + monster.short + " takes <b><font color=\"#800000\">" + temp + "</font></b> damage.", false);
		//Using fire attacks on the goo]
		//if(monster.short == "goo-girl") {
		//outputText("  Your flames lick the girl's body and she opens her mouth in pained protest as you evaporate much of her moisture. When the fire passes, she seems a bit smaller and her slimy " + monster.skinTone + " skin has lost some of its shimmer.", false);
		//if(monster.findPerk(PerkLib.Acid) < 0) monster.createPerk(PerkLib.Acid,0,0,0,0);
		//}
		if (crit == true) outputText(" <b>*Critical Hit!*</b>");
		outputText("\n\n", false);
		checkAchievementDamage(temp);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		monster.HP -= temp;
		statScreenRefresh();
		if(monster.HP < 1) doNext(endHpVictory);
		else enemyAI();
	}

//(45) Darkness Shard
	public function spellDarknessShard():void {
		flags[kFLAGS.LAST_ATTACK_TYPE] = 2;
		clearOutput();
		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(40) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(40,6);
		if(monster.hasStatusAffect(StatusAffects.Shell)) {
			outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}
		//if (monster is Doppleganger)
		//{
		//(monster as Doppleganger).handleSpellResistance("whitefire");
		//flags[kFLAGS.SPELLS_CAST]++;
		//if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		//spellPerkUnlock();
		//return;
		//}
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You narrow your eyes, focusing your own lust with deadly intent.  At the palm of your hand form a shard from pure darkness that shots toward " + monster.a + monster.short + " !\n", true);
		temp = 0;
		temp += inteligencescalingbonus();
		temp *= spellModBlack();
		//Determine if critical hit!
		var crit:Boolean = false;
		var critChance:int = 5;
		if (player.findPerk(PerkLib.Tactician) >= 0 && player.inte >= 50) {
			if (player.inte <= 100) critChance += (player.inte - 50) / 50;
			if (player.inte > 100) critChance += 10;
		}
		if (rand(100) < critChance) {
			crit = true;
			temp *= 1.75;
		}
		//High damage to goes.
//	temp = calcGlacialMod(temp);
		if (monster.findPerk(PerkLib.DarknessNature) >= 0) temp *= 0.2;
		if (monster.findPerk(PerkLib.LightningVulnerability) >= 0) temp *= 0.5;
		if (monster.findPerk(PerkLib.DarknessVulnerability) >= 0) temp *= 2;
		if (monster.findPerk(PerkLib.LightningNature) >= 0) temp *= 5;
//	if (player.findPerk(PerkLib.ColdMastery) >= 0) temp *= 2;
//	if (player.findPerk(PerkLib.ColdAffinity) >= 0) temp *= 2;
		temp = Math.round(temp);
		//if (monster.short == "goo-girl") temp = Math.round(temp * 1.5); - pomyśleć czy bdą dostawać bonusowe obrażenia
		//if (monster.short == "tentacle beast") temp = Math.round(temp * 1.2); - tak samo przemyśleć czy bedą dodatkowo ranione
		outputText(monster.capitalA + monster.short + " takes <b><font color=\"#800000\">" + temp + "</font></b> damage.", false);
		//Using fire attacks on the goo]
		//if(monster.short == "goo-girl") {
		//outputText("  Your flames lick the girl's body and she opens her mouth in pained protest as you evaporate much of her moisture. When the fire passes, she seems a bit smaller and her slimy " + monster.skinTone + " skin has lost some of its shimmer.", false);
		//if(monster.findPerk(PerkLib.Acid) < 0) monster.createPerk(PerkLib.Acid,0,0,0,0);
		//}
		if (crit == true) outputText(" <b>*Critical Hit!*</b>");
		outputText("\n\n", false);
		checkAchievementDamage(temp);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		monster.HP -= temp;
		statScreenRefresh();
		if(monster.HP < 1) doNext(endHpVictory);
		else enemyAI();
	}

//(100) Ice Rain - AoE Ice spell
	public function spellIceRain():void {
		if (rand(2) == 0) flags[kFLAGS.LAST_ATTACK_TYPE] = 2;
		else flags[kFLAGS.LAST_ATTACK_TYPE] = 3;
		clearOutput();
		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(200) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu3);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(200,1);
		if(monster.hasStatusAffect(StatusAffects.Shell)) {
			outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}
		//if (monster is Doppleganger)
		//{
		//(monster as Doppleganger).handleSpellResistance("whitefire");
		//flags[kFLAGS.SPELLS_CAST]++;
		//if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		//spellPerkUnlock();
		//return;
		//}
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You narrow your eyes, focusing your own lust and willpower with a deadly intent.  Above you starting to form small darn cloud that soon becoming quite wide and long.  Then almost endless rain of ice shards start to downpour on " + monster.a + monster.short + " and the rest of your surrounding!\n", true);
		temp = 0;
		temp += inteligencescalingbonus();
		temp *= spellMod();
		//Determine if critical hit!
		var crit:Boolean = false;
		var critChance:int = 5;
		if (player.findPerk(PerkLib.Tactician) >= 0 && player.inte >= 50) {
			if (player.inte <= 100) critChance += (player.inte - 50) / 50;
			if (player.inte > 100) critChance += 10;
		}
		if (rand(100) < critChance) {
			crit = true;
			temp *= 1.75;
		}
		//High damage to goes.
		temp = calcGlacialMod(temp);
		if (monster.findPerk(PerkLib.IceNature) >= 0) temp *= 0.2;
		if (monster.findPerk(PerkLib.FireVulnerability) >= 0) temp *= 0.5;
		if (monster.findPerk(PerkLib.IceVulnerability) >= 0) temp *= 2;
		if (monster.findPerk(PerkLib.FireNature) >= 0) temp *= 5;
		if (player.findPerk(PerkLib.ColdMastery) >= 0) temp *= 2;
		if (player.findPerk(PerkLib.ColdAffinity) >= 0) temp *= 2;
		temp = Math.round(temp);
		//if (monster.short == "goo-girl") temp = Math.round(temp * 1.5); - pomyśleć czy bdą dostawać bonusowe obrażenia
		//if (monster.short == "tentacle beast") temp = Math.round(temp * 1.2); - tak samo przemyśleć czy bdą dodatkowo ranione
		if (monster.plural == true) temp *= 5;
		outputText(monster.capitalA + monster.short + " takes <b><font color=\"#800000\">" + temp + "</font></b> damage.", false);
		//Using fire attacks on the goo]
		//if(monster.short == "goo-girl") {
		//outputText("  Your flames lick the girl's body and she opens her mouth in pained protest as you evaporate much of her moisture. When the fire passes, she seems a bit smaller and her slimy " + monster.skinTone + " skin has lost some of its shimmer.", false);
		//if(monster.findPerk(PerkLib.Acid) < 0) monster.createPerk(PerkLib.Acid,0,0,0,0);
		//}
		if (crit == true) outputText(" <b>*Critical Hit!*</b>");
		outputText("\n\n", false);
		checkAchievementDamage(temp);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		monster.HP -= temp;
		statScreenRefresh();
		if(monster.HP < 1) doNext(endHpVictory);
		else enemyAI();
	}

//(100) Fire Storm - AoE Fire spell
	public function spellFireStorm():void {
		if (rand(2) == 0) flags[kFLAGS.LAST_ATTACK_TYPE] = 2;
		else flags[kFLAGS.LAST_ATTACK_TYPE] = 3;
		clearOutput();
		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(200) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu3);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(200,1);
		if(monster.hasStatusAffect(StatusAffects.Shell)) {
			outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}
		//if (monster is Doppleganger)
		//{
		//(monster as Doppleganger).handleSpellResistance("whitefire");
		//flags[kFLAGS.SPELLS_CAST]++;
		//if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		//spellPerkUnlock();
		//return;
		//}
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You narrow your eyes, focusing your own lust and willpower with a deadly intent.  Around you starting to form small vortex of flames that soon becoming quite wide.  Then with a single thought you sends all that fire like a unstoppable storm toward " + monster.a + monster.short + " and the rest of your surrounding!\n", true);
		temp = 0;
		temp += inteligencescalingbonus();
		temp *= spellMod();
		//Determine if critical hit!
		var crit:Boolean = false;
		var critChance:int = 5;
		if (player.findPerk(PerkLib.Tactician) >= 0 && player.inte >= 50) {
			if (player.inte <= 100) critChance += (player.inte - 50) / 50;
			if (player.inte > 100) critChance += 10;
		}
		if (rand(100) < critChance) {
			crit = true;
			temp *= 1.75;
		}
		//High damage to goes.
		temp = calcInfernoMod(temp);
		if (monster.short == "goo-girl") temp = Math.round(temp * 1.5);
		if (monster.short == "tentacle beast") temp = Math.round(temp * 1.2);
		if (monster.plural == true) temp *= 5;
		if (monster.findPerk(PerkLib.IceNature) >= 0) temp *= 5;
		if (monster.findPerk(PerkLib.FireVulnerability) >= 0) temp *= 2;
		if (monster.findPerk(PerkLib.IceVulnerability) >= 0) temp *= 0.5;
		if (monster.findPerk(PerkLib.FireNature) >= 0) temp *= 0.2;
		if (player.findPerk(PerkLib.FireAffinity) >= 0) temp *= 2;
		temp = Math.round(temp);
		outputText(monster.capitalA + monster.short + " takes <b><font color=\"#800000\">" + temp + "</font></b> damage.", false);
		//Using fire attacks on the goo]
		if(monster.short == "goo-girl") {
			outputText("  Your fire storm lick the girl's body and she opens her mouth in pained protest as you evaporate much of her moisture. When the fire passes, she seems a bit smaller and her slimy " + monster.skinTone + " skin has lost some of its shimmer.", false);
			if(monster.findPerk(PerkLib.Acid) < 0) monster.createPerk(PerkLib.Acid,0,0,0,0);
		}
		if (crit == true) outputText(" <b>*Critical Hit!*</b>");
		outputText("\n\n", false);
		checkAchievementDamage(temp);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		monster.HP -= temp;
		statScreenRefresh();
		if(monster.HP < 1) doNext(endHpVictory);
		else enemyAI();
	}

	/**
	 * Generates from (x1,x2,x3,y1,y2) log-scale parameters (a,b,c) that will return:
	 * y1= 10 at x1=  10
	 * y2= 55 at x2= 100
	 * y3=100 at x3=1000
	 */
	private static const ChargeWeaponABC:Object = FnHelpers.FN.buildLogScaleABC(10,100,1000,10,100);
//(15) Charge Weapon – boosts your weapon attack value by 5 + (player.inte/10) * SpellMod till the end of combat.
	public function spellChargeWeapon(silent:Boolean = false):void {
		var ChargeWeaponBoost:Number = 10;
		if (player.findPerk(PerkLib.JobSorcerer) >= 0 && player.inte >= 25) ChargeWeaponBoost += 5;
		if (player.findPerk(PerkLib.Spellpower) >= 0 && player.inte >= 50) ChargeWeaponBoost += 5;
		if (player.findPerk(PerkLib.Mage) >= 0 && player.inte >= 50) ChargeWeaponBoost += 10;
		if (player.findPerk(PerkLib.FocusedMind) >= 0 && player.inte >= 50) ChargeWeaponBoost += 10;
		if (player.findPerk(PerkLib.Channeling) >= 0 && player.inte >= 60) ChargeWeaponBoost += 10;
		if (player.findPerk(PerkLib.Archmage) >= 0 && player.inte >= 75) ChargeWeaponBoost += 15;
		if (player.findPerk(PerkLib.GrandArchmage) >= 0 && player.inte >= 100) ChargeWeaponBoost += 20;
		if (player.findPerk(PerkLib.GreyMage) >= 0 && player.inte >= 125) ChargeWeaponBoost += 25;
		if (player.findPerk(PerkLib.GreyArchmage) >= 0 && player.inte >= 150) ChargeWeaponBoost += 30;
		if (player.findPerk(PerkLib.JobEnchanter) >= 0 && player.inte >= 50) ChargeWeaponBoost += 5;
		if (player.findPerk(PerkLib.Spellsword) >= 0 && player.inte >= 50) ChargeWeaponBoost += 15;
		if (player.findPerk(PerkLib.JobBarbarian) >= 0) ChargeWeaponBoost -= 10;
		if (player.findPerk(PerkLib.JobBrawler) >= 0) ChargeWeaponBoost -= 10;
		if (player.findPerk(PerkLib.JobDervish) >= 0) ChargeWeaponBoost -= 10;
		if (player.findPerk(PerkLib.IronFistsI) >= 0) ChargeWeaponBoost -= 10;
		if (player.findPerk(PerkLib.JobMonk) >= 0) ChargeWeaponBoost -= 15;
		if (player.findPerk(PerkLib.Berzerker) >= 0) ChargeWeaponBoost -= 15;
		if (player.findPerk(PerkLib.Lustzerker) >= 0) ChargeWeaponBoost -= 15;
		if (player.findPerk(PerkLib.WeaponMastery) >= 0) ChargeWeaponBoost -= 15;
		if (player.findPerk(PerkLib.WeaponGrandMastery) >= 0) ChargeWeaponBoost -= 25;
		if (player.findPerk(PerkLib.HeavyArmorProficiency) >= 0) ChargeWeaponBoost -= 15;
		if (player.findPerk(PerkLib.AyoArmorProficiency) >= 0) ChargeWeaponBoost -= 15;
		if (player.findPerk(PerkLib.Agility) >= 0) ChargeWeaponBoost -= 10;
		if (player.findPerk(PerkLib.LightningStrikes) >= 0) ChargeWeaponBoost -= 10;
		if (player.findPerk(PerkLib.BodyCultivator) >= 0) ChargeWeaponBoost -= 5;
//	ChargeWeaponBoost += player.inte / 10;player.inte * 0.1 - może tylko jak bedzie mieć perk z prestige job: magus/warock/inny związany z spells
		if (ChargeWeaponBoost < 10) ChargeWeaponBoost = 10;
		ChargeWeaponBoost *= 1.5;
		if (player.findPerk(PerkLib.JobEnchanter) >= 0) ChargeWeaponBoost *= 1.2;
		ChargeWeaponBoost *= spellModWhite();
		ChargeWeaponBoost = FnHelpers.FN.logScale(ChargeWeaponBoost,ChargeWeaponABC,10);
		ChargeWeaponBoost = Math.round(ChargeWeaponBoost);
		if (silent) {
			player.createStatusAffect(StatusAffects.ChargeWeapon,ChargeWeaponBoost,0,0,0);
			statScreenRefresh();
			return;
		}

		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(30) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu2);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(30, 5);
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You utter words of power, summoning an electrical charge around your " + player.weaponName + ".  It crackles loudly, ensuring you'll do more damage with it for the rest of the fight.\n\n", true);
		player.createStatusAffect(StatusAffects.ChargeWeapon,ChargeWeaponBoost,0,0,0);
		statScreenRefresh();
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		enemyAI();
	}

	/**
	 * Generates from (x1,x2,x3,y1,y2) log-scale parameters (a,b,c) that will return:
	 * y1= 10 at x1=  10
	 * y2= 55 at x2= 100
	 * y3=100 at x3=1000
	 */
	private static const ChargeArmorABC:Object = FnHelpers.FN.buildLogScaleABC(10,100,1000,10,100);
//(35) Charge Armor – boosts your armor value by 5 + (player.inte/10) * SpellMod till the end of combat.
	public function spellChargeArmor(silent:Boolean = false):void {
		var ChargeArmorBoost:Number = 10;
		if (player.findPerk(PerkLib.JobSorcerer) >= 0 && player.inte >= 25) ChargeArmorBoost += 5;
		if (player.findPerk(PerkLib.Spellpower) >= 0 && player.inte >= 50) ChargeArmorBoost += 5;
		if (player.findPerk(PerkLib.Mage) >= 0 && player.inte >= 50) ChargeArmorBoost += 10;
		if (player.findPerk(PerkLib.FocusedMind) >= 0 && player.inte >= 50) ChargeArmorBoost += 10;
		if (player.findPerk(PerkLib.Channeling) >= 0 && player.inte >= 60) ChargeArmorBoost += 10;
		if (player.findPerk(PerkLib.Archmage) >= 0 && player.inte >= 75) ChargeArmorBoost += 15;
		if (player.findPerk(PerkLib.GrandArchmage) >= 0 && player.inte >= 100) ChargeArmorBoost += 20;
		if (player.findPerk(PerkLib.GreyMage) >= 0 && player.inte >= 125) ChargeArmorBoost += 25;
		if (player.findPerk(PerkLib.GreyArchmage) >= 0 && player.inte >= 150) ChargeArmorBoost += 30;
		if (player.findPerk(PerkLib.JobEnchanter) >= 0 && player.inte >= 50) ChargeArmorBoost += 5;
		if (player.findPerk(PerkLib.Spellarmor) >= 0 && player.inte >= 50) ChargeArmorBoost += 15;
		if (player.findPerk(PerkLib.JobBarbarian) >= 0) ChargeArmorBoost -= 10;
		if (player.findPerk(PerkLib.JobBrawler) >= 0) ChargeArmorBoost -= 10;
		if (player.findPerk(PerkLib.JobDervish) >= 0) ChargeArmorBoost -= 10;
		if (player.findPerk(PerkLib.IronFistsI) >= 0) ChargeArmorBoost -= 10;
		if (player.findPerk(PerkLib.JobMonk) >= 0) ChargeArmorBoost -= 15;
		if (player.findPerk(PerkLib.Berzerker) >= 0) ChargeArmorBoost -= 15;
		if (player.findPerk(PerkLib.Lustzerker) >= 0) ChargeArmorBoost -= 15;
		if (player.findPerk(PerkLib.WeaponMastery) >= 0) ChargeArmorBoost -= 15;
		if (player.findPerk(PerkLib.WeaponGrandMastery) >= 0) ChargeArmorBoost -= 25;
		if (player.findPerk(PerkLib.HeavyArmorProficiency) >= 0) ChargeArmorBoost -= 15;
		if (player.findPerk(PerkLib.AyoArmorProficiency) >= 0) ChargeArmorBoost -= 15;
		if (player.findPerk(PerkLib.Agility) >= 0) ChargeArmorBoost -= 10;
		if (player.findPerk(PerkLib.LightningStrikes) >= 0) ChargeArmorBoost -= 10;
		if (player.findPerk(PerkLib.BodyCultivator) >= 0) ChargeArmorBoost -= 5;
//	ChargeArmorBoost += player.inte / 10;player.inte * 0.1 - może tylko jak bedzie mieć perk z prestige job: magus/warock/inny związany z spells
		if (ChargeArmorBoost < 10) ChargeArmorBoost = 10;
		if (player.findPerk(PerkLib.JobEnchanter) >= 0) ChargeArmorBoost *= 1.2;
		ChargeArmorBoost *= spellModWhite();
		ChargeArmorBoost = FnHelpers.FN.logScale(ChargeArmorBoost,ChargeArmorABC,10);
		ChargeArmorBoost = Math.round(ChargeArmorBoost);
		if (silent) {
			player.createStatusAffect(StatusAffects.ChargeArmor,ChargeArmorBoost,0,0,0);
			statScreenRefresh();
			return;
		}

		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(40) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu2);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(40, 5);
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You utter words of power, summoning an electrical charge around your " + player.armorName + ".  It crackles loudly, ensuring you'll have more protection for the rest of the fight.\n\n", true);
		player.createStatusAffect(StatusAffects.ChargeArmor,ChargeArmorBoost,0,0,0);
		statScreenRefresh();
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		enemyAI();
	}
//(20) Blind – reduces your opponent's accuracy, giving an additional 50% miss chance to physical attacks.
	public function spellBlind():void {
		flags[kFLAGS.LAST_ATTACK_TYPE] = 2;
		clearOutput();
		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(30) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(30,5);
		var successrate:int = 60;
		successrate -= (player.inte * 0.4);
		if (successrate > 20) successrate = 20;
		if (rand(100) > successrate) {
			if (monster.hasStatusAffect(StatusAffects.Shell)) {
				outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
				flags[kFLAGS.SPELLS_CAST]++;
				if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
				spellPerkUnlock();
				enemyAI();
				return;
			}
			if (monster is JeanClaude)
			{
				outputText("Jean-Claude howls, reeling backwards before turning back to you, rage clenching his dragon-like face and enflaming his eyes. Your spell seemed to cause him physical pain, but did nothing to blind his lidless sight.");

				outputText("\n\n“<i>You think your hedge magic will work on me, intrus?</i>” he snarls. “<i>Here- let me show you how it’s really done.</i>” The light of anger in his eyes intensifies, burning a retina-frying white as it demands you stare into it...");

				if (rand(player.spe) >= 50 || rand(player.inte) >= 50)
				{
					outputText("\n\nThe light sears into your eyes, but with the discipline of conscious effort you escape the hypnotic pull before it can mesmerize you, before Jean-Claude can blind you.");

					outputText("\n\n“<i>You fight dirty,</i>” the monster snaps. He sounds genuinely outraged. “<i>I was told the interloper was a dangerous warrior, not a little [boy] who accepts duels of honour and then throws sand into his opponent’s eyes. Look into my eyes, little [boy]. Fair is fair.</i>”");

					monster.HP -= int(10+(player.inte/3 + rand(player.inte/2)) * spellModWhite());
				}
				else
				{
					outputText("\n\nThe light sears into your eyes and mind as you stare into it. It’s so powerful, so infinite, so exquisitely painful that you wonder why you’d ever want to look at anything else, at anything at- with a mighty effort, you tear yourself away from it, gasping. All you can see is the afterimages, blaring white and yellow across your vision. You swipe around you blindly as you hear Jean-Claude bark with laughter, trying to keep the monster at arm’s length.");

					outputText("\n\n“<i>The taste of your own medicine, it is not so nice, eh? I will show you much nicer things in there in time intrus, don’t worry. Once you have learnt your place.</i>”");

					player.createStatusAffect(StatusAffects.Blind, 2 + player.inte/20, 0, 0, 0);
				}
				if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
					(monster as FrostGiant).giantBoulderHit(2);
					enemyAI();
					return;
				}
				flags[kFLAGS.SPELLS_CAST]++;
				if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
				spellPerkUnlock();
				if(monster.HP < 1) doNext(endHpVictory);
				else enemyAI();
				return;
			}
			else if (monster is Lethice && (monster as Lethice).fightPhase == 2)
			{
				outputText("You hold your [weapon] aloft and thrust your will forward, causing it to erupt in a blinding flash of light. The demons of the court scream and recoil from the radiant burst, clutching at their eyes and trampling over each other to get back.");

				outputText("\n\n<i>“Damn you, fight!”</i> Lethice screams, grabbing her whip and lashing out at the back-most demons, driving them forward -- and causing the middle bunch to be crushed between competing forces of retreating demons! <i>“Fight, or you'll be in the submission tanks for the rest of your miserable lives!”</i>");

				monster.createStatusAffect(StatusAffects.Blind, 5 * spellModWhite(), 0, 0, 0);
				outputText("\n\n", false);
				flags[kFLAGS.SPELLS_CAST]++;
				if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
				spellPerkUnlock();
				statScreenRefresh();
				enemyAI();
				return;
			}
			outputText("You glare at " + monster.a + monster.short + " and point at " + monster.pronoun2 + ".  A bright flash erupts before " + monster.pronoun2 + "!\n", true);
			if (monster is LivingStatue)
			{
				// noop
			}
			else if(rand(3) != 0) {
				outputText(" <b>" + monster.capitalA + monster.short + " ", false);
				if(monster.plural && monster.short != "imp horde") outputText("are blinded!</b>", false);
				else outputText("is blinded!</b>", false);
				monster.createStatusAffect(StatusAffects.Blind,2+player.inte/20,0,0,0);
				if(monster.short == "Isabella")
					if (kGAMECLASS.isabellaFollowerScene.isabellaAccent()) outputText("\n\n\"<i>Nein! I cannot see!</i>\" cries Isabella.", false);
					else outputText("\n\n\"<i>No! I cannot see!</i>\" cries Isabella.", false);
				if(monster.short == "Kiha") outputText("\n\n\"<i>You think blindness will slow me down?  Attacks like that are only effective on those who don't know how to see with their other senses!</i>\" Kiha cries defiantly.", false);
				if(monster.short == "plain girl") {
					outputText("  Remarkably, it seems as if your spell has had no effect on her, and you nearly get clipped by a roundhouse as you stand, confused. The girl flashes a radiant smile at you, and the battle continues.", false);
					monster.removeStatusAffect(StatusAffects.Blind);
				}
			}
		}
		else outputText(monster.capitalA + monster.short + " blinked!", false);
		outputText("\n\n", false);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		statScreenRefresh();
		enemyAI();
	}
//(30) Whitefire – burns the enemy for 10 + int/3 + rand(int/2) * spellMod.
	public function spellWhitefire():void {
		flags[kFLAGS.LAST_ATTACK_TYPE] = 2;
		clearOutput();
		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(40) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(40,5);
		if(monster.hasStatusAffect(StatusAffects.Shell)) {
			outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}
		if (monster is Doppleganger)
		{
			(monster as Doppleganger).handleSpellResistance("whitefire");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			return;
		}
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		else if (monster is Lethice && (monster as Lethice).fightPhase == 2)
		{
			//Attack gains burn DoT for 2-3 turns.
			outputText("You let loose a roiling cone of flames that wash over the horde of demons like a tidal wave, scorching at their tainted flesh with vigor unlike anything you've seen before. Screams of terror as much as, maybe more than, pain fill the air as the mass of corrupted bodies try desperately to escape from you! Though more demons pile in over the affected front ranks, you've certainly put the fear of your magic into them!");
			monster.createStatusAffect(StatusAffects.OnFire, 2 + rand(2), 0, 0, 0);
			temp = 0;
			temp += inteligencescalingbonus();
			temp *= spellModWhite();
			//Determine if critical hit!
			var crit:Boolean = false;
			var critChance:int = 5;
			if (player.findPerk(PerkLib.Tactician) >= 0 && player.inte >= 50) {
				if (player.inte <= 100) critChance += (player.inte - 50) / 50;
				if (player.inte > 100) critChance += 10;
			}
			if (rand(100) < critChance) {
				crit = true;
				temp *= 1.75;
			}
			temp *= 1.75;
			outputText(" (" + temp + ")");
			if (crit == true) outputText(" <b>*Critical Hit!*</b>");
		}
		else
		{
			outputText("You narrow your eyes, focusing your mind with deadly intent.  You snap your fingers and " + monster.a + monster.short + " is enveloped in a flash of white flames!\n", true);
			temp = 0;
			temp += inteligencescalingbonus();
			temp *= spellModWhite();
			//Determine if critical hit!
			var crit2:Boolean = false;
			var critChance2:int = 5;
			if (player.findPerk(PerkLib.Tactician) >= 0 && player.inte >= 50) {
				if (player.inte <= 100) critChance2 += (player.inte - 50) / 50;
				if (player.inte > 100) critChance2 += 10;
			}
			if (rand(100) < critChance2) {
				crit = true;
				temp *= 1.75;
			}
			//High damage to goes.
			temp = calcInfernoMod(temp);
			if (monster.short == "goo-girl") temp = Math.round(temp * 1.5);
			if (monster.short == "tentacle beast") temp = Math.round(temp * 1.2);
			if (monster.findPerk(PerkLib.IceNature) >= 0) temp *= 5;
			if (monster.findPerk(PerkLib.FireVulnerability) >= 0) temp *= 2;
			if (monster.findPerk(PerkLib.IceVulnerability) >= 0) temp *= 0.5;
			if (monster.findPerk(PerkLib.FireNature) >= 0) temp *= 0.2;
			if (player.findPerk(PerkLib.FireAffinity) >= 0) temp *= 2;
			temp = Math.round(temp);
			outputText(monster.capitalA + monster.short + " takes <b><font color=\"#800000\">" + temp + "</font></b> damage.", false);
			if (crit == true) outputText(" <b>*Critical Hit!*</b>");
			//Using fire attacks on the goo]
			if(monster.short == "goo-girl") {
				outputText("  Your flames lick the girl's body and she opens her mouth in pained protest as you evaporate much of her moisture. When the fire passes, she seems a bit smaller and her slimy " + monster.skinTone + " skin has lost some of its shimmer.", false);
				if(monster.findPerk(PerkLib.Acid) < 0) monster.createPerk(PerkLib.Acid,0,0,0,0);
			}
		}
		if(monster.short == "Holli" && !monster.hasStatusAffect(StatusAffects.HolliBurning)) (monster as Holli).lightHolliOnFireMagically();
		outputText("\n\n", false);
		checkAchievementDamage(temp);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		monster.HP -= temp;
		statScreenRefresh();
		if (monster.HP < 1)
		{
			doNext(endHpVictory);
		}
		else
		{
			if (monster is Lethice && (monster as Lethice).fightPhase == 3)
			{
				outputText("\n\n<i>“Ouch. Such arcane skills for one so uncouth,”</i> Lethice growls. With a snap of her fingers, a pearlescent dome surrounds her. <i>“How will you beat me without your magics?”</i>\n\n");
				monster.createStatusAffect(StatusAffects.Shell, 2, 0, 0, 0);
			}
			enemyAI();
		}
	}

//(45) Lightning Bolt - base lighting spell
	public function spellLightningBolt():void {
		flags[kFLAGS.LAST_ATTACK_TYPE] = 2;
		clearOutput();
		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(40) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(40,5);
		if(monster.hasStatusAffect(StatusAffects.Shell)) {
			outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}
		//if (monster is Doppleganger)
		//{
		//(monster as Doppleganger).handleSpellResistance("whitefire");
		//flags[kFLAGS.SPELLS_CAST]++;
		//if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		//spellPerkUnlock();
		//return;
		//}
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You charge out energy in your hand and fire it out in the form of a powerful bolt of lightning at " + monster.a + monster.short + " !\n", true);
		temp = 0;
		temp += inteligencescalingbonus();
		temp *= spellModWhite();
		//Determine if critical hit!
		var crit:Boolean = false;
		var critChance:int = 5;
		if (player.findPerk(PerkLib.Tactician) >= 0 && player.inte >= 50) {
			if (player.inte <= 100) critChance += (player.inte - 50) / 50;
			if (player.inte > 100) critChance += 10;
		}
		if (rand(100) < critChance) {
			crit = true;
			temp *= 1.75;
		}
		//High damage to goes.
//	temp = calcGlacialMod(temp);
		if (monster.findPerk(PerkLib.DarknessNature) >= 0) temp *= 0.2;
		if (monster.findPerk(PerkLib.LightningVulnerability) >= 0) temp *= 0.5;
		if (monster.findPerk(PerkLib.DarknessVulnerability) >= 0) temp *= 2;
		if (monster.findPerk(PerkLib.LightningNature) >= 0) temp *= 5;
//	if (player.findPerk(PerkLib.ColdAffinity) >= 0) temp *= 2;
		temp = Math.round(temp);
		//if (monster.short == "goo-girl") temp = Math.round(temp * 1.5); - pomyśleć czy bdą dostawać bonusowe obrażenia
		//if (monster.short == "tentacle beast") temp = Math.round(temp * 1.2); - tak samo przemyśleć czy bedą dodatkowo ranione
		outputText(monster.capitalA + monster.short + " takes <b><font color=\"#800000\">" + temp + "</font></b> damage.", false);
		//Using fire attacks on the goo]
		//if(monster.short == "goo-girl") {
		//outputText("  Your flames lick the girl's body and she opens her mouth in pained protest as you evaporate much of her moisture. When the fire passes, she seems a bit smaller and her slimy " + monster.skinTone + " skin has lost some of its shimmer.", false);
		//if(monster.findPerk(PerkLib.Acid) < 0) monster.createPerk(PerkLib.Acid,0,0,0,0);
		//}
		if (crit == true) outputText(" <b>*Critical Hit!*</b>");
		outputText("\n\n", false);
		checkAchievementDamage(temp);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		monster.HP -= temp;
		statScreenRefresh();
		if(monster.HP < 1) doNext(endHpVictory);
		else enemyAI();
	}

//(35) Blizzard
	public function spellBlizzard():void {
		clearOutput();
		if(player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(50) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu2);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(50,5);
		if (monster is FrostGiant && player.hasStatusAffect(StatusAffects.GiantBoulder)) {
			(monster as FrostGiant).giantBoulderHit(2);
			enemyAI();
			return;
		}
		outputText("You utter words of power, summoning an ice storm.  It swirls arounds you, ensuring that you'll have more protection from the fire attacks for a few moments.\n\n", true);
		if (player.findPerk(PerkLib.ColdMastery) >= 0 || player.findPerk(PerkLib.ColdAffinity) >= 0) {
			player.createStatusAffect(StatusAffects.Blizzard,2+player.inte/10,0,0,0);
		}
		else {
			player.createStatusAffect(StatusAffects.Blizzard,1+player.inte/25,0,0,0);
		}
		statScreenRefresh();
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		enemyAI();
	}

	public function spellCleansingPalm():void
	{
		flags[kFLAGS.LAST_ATTACK_TYPE] = 2;
		clearOutput();
		if (player.findPerk(PerkLib.BloodMage) < 0 && player.fatigue + spellCost(30) > player.maxFatigue()) {
			outputText("You are too tired to cast this spell.", true);
			doNext(magicMenu);
			return;
		}
		doNext(combatMenu);
//This is now automatic - newRound arg defaults to true:	menuLoc = 0;
		fatigue(30,1);
		if(monster.hasStatusAffect(StatusAffects.Shell)) {
			outputText("As soon as your magic touches the multicolored shell around " + monster.a + monster.short + ", it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}

		if (monster.short == "Jojo")
		{
			// Not a completely corrupted monkmouse
			if (kGAMECLASS.monk < 2)
			{
				outputText("You thrust your palm forward, sending a blast of pure energy towards Jojo. At the last second he sends a blast of his own against yours canceling it out\n\n");
				flags[kFLAGS.SPELLS_CAST]++;
				if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
				spellPerkUnlock();
				enemyAI();
				return;
			}
		}

		if (monster is LivingStatue)
		{
			outputText("You thrust your palm forward, causing a blast of pure energy to slam against the giant stone statue- to no effect!");
			flags[kFLAGS.SPELLS_CAST]++;
			if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
			spellPerkUnlock();
			enemyAI();
			return;
		}

		var corruptionMulti:Number = (monster.cor - 20) / 25;
		if (corruptionMulti > 1.5) {
			corruptionMulti = 1.5;
			corruptionMulti += ((monster.cor - 57.5) / 100); //The increase to multiplier is diminished.
		}

		//temp = int((player.inte / 4 + rand(player.inte / 3)) * (spellMod() * corruptionMulti));
		temp = int(10+(player.inte/3 + rand(player.inte/2)) * (spellMod() * corruptionMulti));

		if (temp > 0)
		{
			outputText("You thrust your palm forward, causing a blast of pure energy to slam against " + monster.a + monster.short + ", tossing");
			if ((monster as Monster).plural == true) outputText(" them");
			else outputText((monster as Monster).mfn(" him", " her", " it"));
			outputText(" back a few feet.\n\n");
			if (silly() && corruptionMulti >= 1.75) outputText("It's super effective!  ");
			//Determine if critical hit!
			var crit:Boolean = false;
			var critChance:int = 5;
			if (player.findPerk(PerkLib.Tactician) >= 0 && player.inte >= 50) {
				if (player.inte <= 100) critChance += (player.inte - 50) / 50;
				if (player.inte > 100) critChance += 10;
			}
			if (rand(100) < critChance) {
				crit = true;
				temp *= 1.75;
			}
			outputText(monster.capitalA + monster.short + " takes <b><font color=\"#800000\">" + temp + "</font></b> damage.\n\n");
			if (crit == true) outputText(" <b>*Critical Hit!*</b>");
		}
		else
		{
			temp = 0;
			outputText("You thrust your palm forward, causing a blast of pure energy to slam against " + monster.a + monster.short + ", which they ignore. It is probably best you don’t use this technique against the pure.\n\n");
		}

		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusAffect(StatusAffects.CastedSpell)) player.createStatusAffect(StatusAffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		monster.HP -= temp;
		statScreenRefresh();
		if(monster.HP < 1) doNext(endHpVictory);
		else enemyAI();
	}


}
}
