package {
	import classes.PreloaderAnimationWhite;
	//import com.greensock.TweenNano;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.*;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[SWF(backgroundColor = "#ffffff", frameRate = "31", width = "977", height = "510")]
	public class Main extends Sprite {
		
		private static const SITE_URL:String = 'j5c.swf';
		
		private var loader:Loader = new Loader();
		private var preloader:PreloaderAnimationWhite;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}		
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var cMenu:ContextMenu = new ContextMenu();
			cMenu.hideBuiltInItems();
			this.contextMenu = cMenu;
			
			preloader = new PreloaderAnimationWhite();
			this.addChild(preloader);
			
			this.stageResizeHandler(null);
			this.addListeners();
			this.loadMainSWF();
		}
		
		private function stageResizeHandler(e:Event):void {
			preloader.x = stage.stageWidth / 2;
			preloader.y = stage.stageHeight / 2;
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
		}
		
		private function removeListeners():void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			//loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			stage.removeEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		private function loaderErrorHandler(e:Event):void {
			trace ('Preloader: ' + e);
		}
		
		private function loaderProgressHandler(e:ProgressEvent):void {
			preloader.totalBytes = e.bytesTotal;
			preloader.bytesLoaded = e.bytesLoaded;
		}
		
		private function loaderCompleteHandler(e:Event):void {
			this.removeListeners();
			//TweenNano.to(preloader, 0.5, { scaleX:0, scaleY:0, onComplete:onTweenComplete } );
			this.addChild(loader);
		}
		
		private function onTweenComplete():void {
			this.removeChild(preloader);
		}
		
		private function loadMainSWF():void {
			var request:URLRequest = new URLRequest(SITE_URL);
			loader.load(request);
		}
		
	}
	
}