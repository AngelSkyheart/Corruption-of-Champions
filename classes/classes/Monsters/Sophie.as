﻿package classes.Monsters
{
	import classes.Creature;
	import classes.Monster;
	import classes.CockTypesEnum;
	
	/**
	 * ...
	 * @author Fake-Name
	 */


	public class Sophie extends Monster
	{
		

		public function Sophie(mainClassPtr:*) 
		{
			super(mainClassPtr);
			trace("Sophie Constructor!");
		
			init1Names("", "Sophie", "sophie", "Sophie is approximately the size of a normal human woman, not counting the large feathery wings that sprout from her back.  Her face is gorgeous, with large rounded eyes and glimmering amber lip-gloss painted on her lush, kissable lips.  In spite of her beauty, it's clear from the barely discernible laugh lines around her mouth that she's been around long to enough to have quite a few children.  Her feathers are light pink, though the downy plumage that comprises her 'hair' is brighter than the rest.  She moves with practiced grace despite the large, jiggling breasts that hang from her chest.  Judging from her confident movements, she's an experienced fighter.");
			init2Female(VAGINA_WETNESS_DROOLING,VAGINA_LOOSENESS_GAPING_WIDE,40);
			init3BreastRows("DD");
			init4Ass(ANAL_LOOSENESS_TIGHT,ANAL_WETNESS_DRY,10);

			this.temperment = 2;
			//Uber
			this.special1 = 5136;
			//Lust attack
			this.special2 = 5137;

			//Clothing/Armor
			this.armorName = "feathers";
			this.weaponName = "talons";
			this.weaponVerb = "slashing talons";
			this.armorDef = 5;

			this.weaponAttack = 20;

			//Primary stats
			this.str = 55;
			this.tou = 40;
			this.spe = 110;
			this.inte = 60;
			this.lib = 60;
			this.sens = 50;
			this.cor = 60;

			this.lustVuln = .3;

			//Combat Stats
			//int(player.statusAffectv2("Tamani")/2)
			this.bonusHP = 250;
			this.HP = eMaxHP();

			this.lust = 10;

			//Level Stats
			this.level = 11;
			this.gems = 20 + rand(25);

			//Appearance Variables
			this.tallness = 65;
			this.hairColor = "pink";
			this.hairLength = 16;

			this.skinTone = "pink";
			this.skinDesc = "feathers";

			this.wingDesc = "large feathery wings";

			this.wingType = WING_TYPE_HARPY;

			this.hipRating = 20;

			this.buttRating = 13;

			this.XP = this.totalXP(mainClassPtr.player.level);
		}

	}

}