package com.data {
	
	import com.data.DataHolder;
	import com.control.ControlsHolder;
	import flash.display.LoaderInfo;
	
	public class FalshVarsReader {
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();
		
		public function FalshVarsReader() {
			this.readVars();
		}
		
		private function readVars():void {
			var $oParams:Object = LoaderInfo(controlsHolder._stage.root.loaderInfo).parameters;
			
			if ($oParams.http_base_url != undefined && $oParams.http_base_url!='') {
				dataHolder.sMainXmlUrl = $oParams.http_base_url;
			}
			
			if ($oParams.advxml_path != undefined && $oParams.advxml_path!='') {
				dataHolder.sXmlAdvUrl = $oParams.advxml_path;
			}
			
			if ($oParams.autoPlay != undefined && $oParams.autoPlay!='') {
				if ($oParams.autoPlay == 'true') {
					dataHolder.bAutoPlay = true;
				} else {
					dataHolder.bAutoPlay = false;
				}
			}
			
			if ($oParams.VIDEOID != undefined) {
				dataHolder.sVideoID = $oParams.VIDEOID;
			}
			
			if ($oParams.home != undefined) {
				dataHolder.sHome = $oParams.home;
			}			
			
			trace($oParams.home);
			
		}
	}
}