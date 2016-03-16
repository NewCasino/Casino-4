package com.shurba {
	import classes.ErrorPlate;
	import com.shurba.data.BarVO;
	import com.shurba.data.DataHolder;
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.view.MainPanel;
	import flash.display.*;
	import flash.events.Event;

	/**
	 * ...
	 * @author Michael Pavlov
	 */
	[Frame(factoryClass="com.shurba.Preloader")]
	public class Main extends Sprite {
		
		public var dataHolder:DataHolder = DataHolder.getInstance();
		
		public var mainPanel:MainPanel;
		
		public function Main():void {
			if (stage) this.init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			new ApplyStandartOptions(this);
			this.readFlashVars();
			drawInterface();
		}
		
		private function readFlashVars():void {
			var parameters:Object;
			var tmpBarVO:BarVO;
			try {
				//parameters = LoaderInfo(root.loaderInfo).parameters;
				parameters = { bar1: { name:'bar1 bar1 bar1', result:19, hint:'hint for bar 1', id:1 }, bar2: { name:'bar2 bar2 bar2', result:13, hint:'hint for bar 2', id:2 }, bar3: { name:'bar3 bar3 bar3', result:17, hint:'hint for bar 3', id:3 }, bar4: { name:'bar4 bar4 bar4', result:8, hint:'hint for bar 4', id:4 }, bar5: { name:'bar5 bar5 bar5', result:8, hint:'hint for bar 5', id:5 }};
				
				dataHolder.barsData = new Vector.<BarVO>();
				dataHolder.barsData.push(parameters.asd);
				var counter:int = 0;
				for (var name:String in parameters) {
					switch (name) {
						default : 
							tmpBarVO = new BarVO();
							tmpBarVO.hint = parameters[name].hint;
							tmpBarVO.name = parameters[name].name;
							tmpBarVO.result = parameters[name].result;
							tmpBarVO.ID = parameters[name].id;
							dataHolder.barsData[counter] = tmpBarVO;
							counter++;
							//dataHolder.barsData.push(tmpBarVO);
						break;
					}
				}
				
				dataHolder.sortBarsData();
			} catch (err:Error){
				showError("Error reading flash vars");
			}
		}
		
		protected function drawInterface():void {
			mainPanel = new MainPanel();
			this.addChild(mainPanel);
		}
		
		protected function showError(code:String):void {
			var errorPanel:ErrorPlate = new ErrorPlate();
			this.addChild(errorPanel);
			errorPanel.error_code.text = code; 
		}
	}

}