package classes.Transformations {
public class MutagenEffect extends PossibleEffect {
	public var statName:String;
	public var buffAmount:Number;
	public var text:String;
	
	public function MutagenEffect(
			effectName:String,
			statName:String,
			buffAmount:Number,
			text:String
	) {
		super(effectName);
		this.statName   = statName;
		this.buffAmount = buffAmount;
		this.text       = text;
	}
	
	
	override public function isPossible():Boolean {
		return true;
	}
	
	override public function applyEffect(doOutput:Boolean = true):void {
		if (doOutput) {
			outputText(text);
		}
		MutagenBonus(statName, buffAmount);
	}
}
}
