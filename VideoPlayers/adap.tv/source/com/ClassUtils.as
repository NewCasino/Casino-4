package com{
	class ClassUtils{
		import flash.display.MovieClip
		import flash.text.*
		import flash.filters.*		
		
		static var root:MovieClip
		function ClassUtils(){
		}
		public function get root():MovieClip{
			return root
		}
		static function makeTextAlpha(textMC:TextField){
			textMC.filters = [new BlurFilter(0,0,0)];
		}
	}
}