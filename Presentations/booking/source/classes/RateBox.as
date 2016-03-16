package classes {
	import flash.display.Sprite;
	import classes.Star;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	/**
	 * @email mihpavlov@gmail.com
	 * @author Michael Pavlov
	 */
	public class RateBox extends Sprite {
		
		private static const STARS_NUMBER:int = 5;
		private static const STARS_WIDTH:int = 12;
		private static const STARS_HEIGHT:int = 12;
		private static const STARS_GAP:int = 1;
		private static const STARS_GLOW_COLOR:int = 0xEECA41;
		
		private var stars:Array = new Array();
		
		public function RateBox() {
			this.createStars();
			this.addEventListener(MouseEvent.ROLL_OUT, thisMouseOutHandler, false, 0, true);
		}
		
		private function thisMouseOutHandler(e:MouseEvent):void {
			for (var i:int = 0; i < stars.length; i++) {
				stars[i].filters = new Array();
			}
		}
		
		private function createStars():void {
			var tmpStar:Star;
			
			for (var i:int = 0; i < STARS_NUMBER; i++) {
				tmpStar = new Star();
				this.addChild(tmpStar);
				tmpStar.addEventListener(MouseEvent.ROLL_OVER, starMouseOverHandler, false, 0, true);
				tmpStar.addEventListener(MouseEvent.CLICK, starClickHandler, false, 0, true);
				tmpStar.width = STARS_WIDTH;
				tmpStar.height = STARS_HEIGHT;
				tmpStar.x = i * (tmpStar.width + STARS_GAP);
				stars.push(tmpStar);
			}
			
		}
		
		private function starClickHandler(e:MouseEvent):void {
			var afterCurrent:Boolean = false;
			var tmpStar:Star = e.currentTarget as Star;
			
			for (var i:int = 0; i < stars.length; i++) {
				if (!afterCurrent) {
					stars[i].setOn();
				} else {
					stars[i].setOff();
				}
				if (tmpStar == stars[i]) {
					afterCurrent = true;
				}
			}
			
		}
		
		private function starMouseOverHandler(e:MouseEvent):void {
			var afterCurrent:Boolean = false;
			var tmpStar:Star = e.currentTarget as Star;
			//trace ("_________________________");
			for (var i:int = 0; i < stars.length; i++) {
				if (!afterCurrent) {
					//trace ("_______true________");
					this.addGlowToStar(stars[i]);
				} else {
					//trace ("_______false________");
					stars[i].filters = new Array();
				}
				
				if (tmpStar == stars[i]) {
					afterCurrent = true;
				}
			}
			//trace ("_________________________");
		}
		
		private function addGlowToStar($star:Star):void {
			var glow:GlowFilter = new GlowFilter(STARS_GLOW_COLOR);
			var aFilters:Array = new Array()
			aFilters.push(glow);
			$star.filters = aFilters;
		}
	}
	
}