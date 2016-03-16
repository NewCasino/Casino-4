package {
	import com.littlefilms.*;
	import com.stimuli.loading.*;
	import flash.display.*;
	import flash.events.*;

	public class Preloader extends MovieClip {
		private var _mainMC:Object;
		private var _introMessaging:IntroMessaging;
		private var _contentXML:XML;
		private var _imagesXML:XML;
		private var _workXML:XML;
		private var _messagingXML:XML;
		private var _colors:XML;
		private var _assetLoader:BulkLoader;
		private var _XMLLoader:BulkLoader;
		private var _masterExternalBytesLoaded:Number = 0;
		private var _masterExternalBytesTotal:Number = 0;
		private var _mainFilesLoaded:Boolean = false;

		public function Preloader() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
			init();
		}

		private function init():void {

			_XMLLoader = new BulkLoader("XMLLoader");
			_XMLLoader.logLevel = BulkLoader.DEFAULT_LOG_LEVEL;
			_XMLLoader.addEventListener(BulkLoader.COMPLETE, XMLLoaded);
			_XMLLoader.add("assets/xml/content.xml", {id:"content", maxTries:10, priority:20});
			_XMLLoader.add("assets/xml/images.xml", {id:"images", maxTries:10, priority:20});
			_XMLLoader.add("assets/xml/work.xml", {id:"work", maxTries:10, priority:20});
			_XMLLoader.add("assets/xml/messaging.xml", { id:"messaging", maxTries:10, priority:20 } );
			_XMLLoader.add("assets/xml/color_scheme.xml", {id:"colors", maxTries:10, priority:20});            
			_assetLoader = new BulkLoader("main-site");
			_assetLoader.logLevel = BulkLoader.LOG_SILENT;
			_assetLoader.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded);
			_assetLoader.addEventListener(BulkLoader.PROGRESS, onAllItemsProgress);
			_assetLoader.add("main.swf", {id:"mainMC", maxTries:10});
			_XMLLoader.start();
		}


		private function XMLLoaded(event:BulkProgressEvent):void {
			_contentXML = _XMLLoader.getXML("content");
			_imagesXML = _XMLLoader.getXML("images");
			_workXML = _XMLLoader.getXML("work");
			_messagingXML = _XMLLoader.getXML("messaging");
			_colors = _XMLLoader.getXML("colors");
			_assetLoader.start();
			_introMessaging = new IntroMessaging(_messagingXML);
			_introMessaging.name = "introMessaging";
			_introMessaging.init();
			//addChild(_introMessaging);
			onResize(event);
		}

		public function onResize(event:Event):void {
			if (_mainMC != null) {
				_mainMC.resize(stage.stageWidth, stage.stageHeight);
			}
			_introMessaging.setSize(stage.stageWidth, stage.stageHeight);
		}

		public function onAllItemsProgress(event:BulkProgressEvent):void {
			_masterExternalBytesLoaded = event.bytesLoaded;
			_masterExternalBytesTotal = event.bytesTotal;
			var _loc_2:* = event.weightPercent;
		}

		public function onAllItemsLoaded(event:Event):void {
			_mainFilesLoaded = true;
			_mainMC = _assetLoader.getMovieClip("mainMC");
			_mainMC.prepContent(_colors, _contentXML, _imagesXML, _workXML, _assetLoader);
			addChild(_mainMC);
			_mainMC.introMessaging = _introMessaging;
			//_mainMC.addChild(_introMessaging);
			//removeChild(_introMessaging);
			_introMessaging.registerMain(_mainMC);
			onResize(event);
		}

	}
}