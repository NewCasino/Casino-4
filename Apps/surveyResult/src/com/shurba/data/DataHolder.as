package com.shurba.data {

	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DataHolder {

		private static var instance:DataHolder;
		private static var allowInstantiation:Boolean;
		
		
		public var barsData:Vector.<BarVO>;

		public static function getInstance():DataHolder {
			if (instance == null) {
				allowInstantiation = true;
				instance = new DataHolder();
				allowInstantiation = false;
			}
			return instance;
		}

		public function DataHolder ():void {
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use DataHolder.getInstance() instead of new.");
			}
		}
		
		public function sortBarsData():void {
			barsData.sort(compareBars);
		}
		
		private function compareBars(x:BarVO, y:BarVO):Number {
			if (x.ID == y.ID) return 0;
			return (x.ID < y.ID)? -1 : 1;
		}

		
	}
}