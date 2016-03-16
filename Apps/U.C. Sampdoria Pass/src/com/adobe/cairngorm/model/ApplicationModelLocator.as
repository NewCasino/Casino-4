package com.adobe.cairngorm.model {
	import com.peterelst.air.sqlite.SQLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.events.CollectionEvent;
	
	[Bindable]
	public class ApplicationModelLocator implements ModelLocator {
		
		private static var modelLocator:ApplicationModelLocator;
		
		public var dbHandler:SQLite;
		
		public var usersData:ArrayCollection = new ArrayCollection();
		public var matchesData:ArrayCollection = new ArrayCollection();		
		public var companiesData:ArrayCollection = new ArrayCollection();		
		public var seasonsData:ArrayCollection = new ArrayCollection();
		public var fieldsNames:Array = new Array();
		
		public var searchPassesByUserName:String = '';
		public var searchPassesByUserLastName:String = '';
		public var searchPassesByMatchName:String = '';
		public var searchPassesBySeason:String = '';
		
		public var searchPassByUserID:int = -1;
		public var searchPassByMatchID:int = -1;		
		
		public var currentUserPhoto:BitmapData;		
		
		public var comboWatchers:Array = new Array();
		
		public function ApplicationModelLocator() {
			if (modelLocator != null) {
				throw new Error( "Only one ModelLocator instance should be instantiated" );	
			}
		}
		
		public static function getInstance():ApplicationModelLocator {
			if (modelLocator == null) {
				modelLocator = new ApplicationModelLocator();				
			}
			return modelLocator;
		}
		
		public function byteArrayToBitmapData(ba:ByteArray):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderReady, false, 0, true);
			loader.loadBytes(ba);
		}
		
		public function comboBoxDataProviderChangeHandler(event:CollectionEvent):void {				
			(event.currentTarget as ComboBox).dropdown.dataProvider = (event.currentTarget as ComboBox).dataProvider as ArrayCollection;				
		}
		
		public function loaderReady(event:Event):void {
			event.currentTarget.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderReady, false);
			var bmp:Bitmap = event.currentTarget.content as Bitmap;
			this.currentUserPhoto = bmp.bitmapData;
		}
		
		public function watchComboBox(cmb:ComboBox):void {			
			if(ChangeWatcher.canWatch(cmb, "dataProvider")){
				var newWatcher:ChangeWatcher;
				newWatcher = ChangeWatcher.watch( cmb, "dataProvider", comboBoxDataProviderChangeHandler);
				comboWatchers.push(newWatcher);
			}
		}

	}
}