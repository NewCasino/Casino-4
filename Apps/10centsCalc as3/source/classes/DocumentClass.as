package classes {
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	public class DocumentClass extends Sprite {
		
		public var direct:TextField;
		public var yourwebsite:TextField;
		public var totalnet:TextField;
		
		public var viral:ComboBox;
		public var invitelevels:ComboBox;
		public var yourmembers:ComboBox;
		public var yourtoolbar:ComboBox;
		
		public function DocumentClass() {
			this.initCalc();
		}
		
		private function addListeners():void {			
			direct.addEventListener(Event.CHANGE, comboChanged, false, 0, true);
			totalnet.addEventListener(Event.CHANGE, comboChanged, false, 0, true);
			yourwebsite.addEventListener(Event.CHANGE, comboChanged, false, 0, true);
			viral.addEventListener(Event.CHANGE, comboChanged, false, 0, true);
			invitelevels.addEventListener(Event.CHANGE, comboChanged, false, 0, true);
			yourmembers.addEventListener(Event.CHANGE, comboChanged, false, 0, true);
			yourtoolbar.addEventListener(Event.CHANGE, comboChanged, false, 0, true);
			
		}
		
		private function initCalc():void {
			this.fillCombos();
			this.addListeners();
			this.doCalc();
		}
		
		private function comboChanged(e:Event):void {
			doCalc();
		}
		
		private function doCalc():void {
			//get values in inputs from user
			var nDirect:int = this.doValue(direct);
			//trace (nDirect);
			var nViral = doValue(viral);		  
			var nInvitelevels = doValue(invitelevels);
			var nFixedinvitelevels = (nInvitelevels - 1);
			
			//invitelevels = Number(invitelevels.selectedIndex);  
			var nYourmembers = doValue(yourmembers);		  
			var nYourwebsite = doValue(yourwebsite);		  
			var nYourtoolbar = doValue(yourtoolbar);
			this.updateInvites(nViral);
			//initialize vars before loops to get level 1 values
			var holder1 = nDirect;
			var holder1members = ((holder1 * nYourmembers) * .0030) * 30;
			var holder1toolbar = ((holder1 * nYourtoolbar) * 0.03) * 30;
			
			var totaldirect;
			var totalyourmembers;
			var totalyourwebsite;
			var totalyourtoolbar;
			
			
			if(nInvitelevels>=2){
				for (var i:int = 0; i < nFixedinvitelevels; i++) {
					
					//get total direct members per invite level		
					var holder2 = (holder1 * nViral);
					var holdall = nDirect += holder2;
					
					//get total $ from members per invite level
					var holder2members = ((holder2 * nYourmembers) * .0030) * 30;					
					var holdallmembers = holder1members += holder2members;
					
					//get total $ from your toolbar
					var holder2toolbar = ((holder2 * nYourtoolbar) * 0.03) * 30;
					var holdalltoolbar = holder1toolbar += holder2toolbar;
											
					//now done with one invite level so change holder var to equal current direct reg number 
					//start of loop then does * viral num to continue untill we reach end of viral number
					holder1 = holder2;
				}		
		
				//write totals to all inputs
				totaldirect = holdall;
				totalyourmembers = holdallmembers;
				totalyourwebsite = (nYourwebsite * 0.01)*30;
				totalyourtoolbar = holdalltoolbar;
				
				//showTotal(totaldirect,'totaldirect');
				//showTotal(totalyourmembers,'totalyourmembers');	
				//showTotal(totalyourwebsite,'totalyourwebsite');
				//showTotal(totalyourtoolbar,'totalyourtoolbar');
				//showTotal(totalnet,'totalnet');
			} else {
				//write totals to all inputs based on less than 2 viral audience
				totaldirect = nDirect;
				totalyourmembers = holder1members;
				totalyourwebsite = (nYourwebsite * 0.01) * 30;
				totalyourtoolbar = holder1toolbar;
				//alert(totalnet);	
				//showTotal(totaldirect,'totaldirect');
				//showTotal(totalyourmembers,'totalyourmembers');	
				//showTotal(totalyourwebsite,'totalyourwebsite');
				//showTotal(totalyourtoolbar,'totalyourtoolbar');
				//showTotal(totalnet,'totalnet');
				//document.getElementById('totalnet').value = totalnet;
			}
			
			var nTotalNumber:Number = int((totalyourmembers + totalyourwebsite + totalyourtoolbar) * 100) / 100;
			totalnet.text = '$' + this.addCommas(nTotalNumber.toString());
		}
		
		private function addCommas(nStr:String):String {
			nStr += '';
			var x = nStr.split('.');
			var x1 = x[0];
			var x2 = x.length > 1 ? '.' + x[1] : '';
			var rgx = /(\d+)(\d{3})/;
			while (rgx.test(x1)) {
				x1 = x1.replace(rgx, '$1' + ',' + '$2');
			}
			return x1 + x2;
		}	
		
	/*	private function showTotal(myNum, who) {
			var decimal = 2;
			for (i = 1; i <= 2; i++) {
				decimal = decimal * 100;
				var myFormattedNum:Number = ((myNum * decimal) / decimal);
				if (myNum = totalnet) {
					document.getElementById(who).value = "$"+addCommas(myFormattedNum.toFixed(2));
				} else {
					myFormattedNum = addCommas(myFormattedNum.toFixed(2));
					document.getElementById(who).value = (myFormattedNum == 'NaN' || myFormattedNum == NaN) ? '0.00' : myFormattedNum;
				}
			}
		}*/
		
		private function updateInvites(num):void {
			num = parseInt(num);
			if (num >= 2) {
				invitelevels.enabled = true;
			}else{
				invitelevels.enabled = false;
				invitelevels.selectedIndex = -1;
			}
		}
		
		private function doValue(who:Object):int {
			var theValue;
			if (who is TextField) {
				theValue = (who as TextField).text.replace(/[\s\,]/g, '');
				//convert string to num before pass back
				return parseInt(theValue);
			} else if (who is ComboBox) {
				if ((who as ComboBox).selectedItem) {
					theValue = (who as ComboBox).selectedItem.data;
				} else {
					theValue = 0;
				}
				
				//convert string to num before pass back
				return parseInt(theValue);
			}
			
			return 0;
		}
		
		private function fillCombos():void {
			//viral data
			var arrData:Array = [ { label:'Select', data:0 } ];
			for (var i:int = 1; i < 11; i++ ) {
				var item:Object = { label:i, data:i };
				arrData.push(item);
			}			
			viral.dataProvider = new DataProvider(arrData);
			
			//invite levels
			arrData = [ { label:'Select', data:0 } ];
			for (i = 2; i < 8; i++ ) {
				item = { label:i, data:i };
				arrData.push(item);
			}			
			invitelevels.dataProvider = new DataProvider(arrData);
			
			//members data
			arrData = [ { label:'Select', data:0 } ];
			for (i = 1; i < 11; i++ ) {
				item = { label:i, data:i };
				arrData.push(item);
			}			
			yourmembers.dataProvider = new DataProvider(arrData);
			
			//widgets data
			arrData = [ { label:'Select', data:0 } ];
			for (i = 1; i < 11; i++ ) {
				item = { label:i, data:i };
				arrData.push(item);
			}			
			yourtoolbar.dataProvider = new DataProvider(arrData);
		}
		
	}

}