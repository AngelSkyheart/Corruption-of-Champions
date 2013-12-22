package classes.Monsters 
{
	import classes.Monster;
	
	/**
	 * ...
	 * @author aimozg
	 */
	public class TamanisDaughters extends Monster 
	{
		
		public function TamanisDaughters(mainClassPtr:*) 
		{
			super(mainClassPtr);
			init1Names("the group of ","Tamani's daughters","tamanisdaughters","A large grouping of goblin girls has gathered around you, surrounding you on all sides.  Most have varying shades of green skin, though a few have yellowish or light blue casts to their skin.  All are barely clothed, exposing as much of their flesh as possible in order to excite a potential mate.  Their hairstyles are as varied as their clothing and skin-tones, and the only things they seem to have in common are cute faces and curvy forms.  It looks like they want something from you.",true);
			init2Female(VAGINA_WETNESS_DROOLING,VAGINA_LOOSENESS_TIGHT,40);
			init3BreastRows("D");
			init4Ass(ANAL_LOOSENESS_TIGHT,ANAL_WETNESS_DRY,25);

			this.temperment = 2;
			//Regular attack

			//Lust attack

			//Clothing/Armor
			this.armorName = "leather straps";
			this.weaponName = "fists";
			this.weaponVerb = "tiny punch";

			//Primary stats
			this.str = 55;
			this.tou = 30;
			this.spe = 45;
			this.inte = 50;
			this.lib = 70;
			this.sens = 70;
			this.cor = 50;

			this.lustVuln = .65;

			//Combat Stats
			//int(player.statusAffectv2("Tamani")/2)
			this.bonusHP = 50 + (int(mainClassPtr.player.statusAffectv2("Tamani")/2)*15);
			this.HP = eMaxHP();

			this.lust = 30;

			//Level Stats
			this.level = 8 + (Math.floor(mainClassPtr.player.statusAffectv2("Tamani")/2/10));
			this.XP = totalXP();
			this.gems = rand(15) + 5;

			//Appearance Variables
			//Gender 1M, 2F, 3H
			this.gender = 2;
			this.tallness = 40;
			this.hairColor = "pink";
			this.hairLength = 16;

			this.skinTone = "greenish gray";
			this.skinDesc = "skin";

			this.hipRating = 7;

			this.buttRating = 7;
			//Create goblin sex attributes
		}
		
	}

}