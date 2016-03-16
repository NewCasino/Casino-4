package com{
	import flash.display.*
	import flash.events.*
	import flash.media.SoundTransform;
	import flash.ui.*
	import com.*
	import flash.net.*;
	import flash.system.*
	import flash.utils.Timer;
	import flash.xml.XMLNode;
	
	public class ClassMain extends MovieClip{
		var settings       : Object      = new Object()
		var myVideo        : ClassVideo
		var myNavigation   : ClassNavigation
		var myPlaylist     : ClassPlaylist
		var myContextMenu  : ContextMenu = new ContextMenu()	
		var myXML:XML = new XML();
		var advXML:XML = new XML();
		var advURL:String = new String() // on video click, redirect url
		var adaptvPlayer:AdaptvPlayer
		var loader:Loader;
		var imageLoader:Loader = new Loader();
		var request:URLRequest;
		
		var current:Number = -1;
		var adv:Boolean = false;
		
		var videoAdvTimer:Timer;
		
		var prerollTimerDone:Boolean = false;
		
		function ClassMain(){
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align     = StageAlign.TOP_LEFT;
			ClassUtils.root = MovieClip(this);
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
			var xml_path = 'data.xml';
			if (paramObj.xml_path != undefined && paramObj.xml_path!='') {
				xml_path = paramObj.xml_path;
			}
			
			var xml = new XMLParser(xml_path, init_xml);
			btnCenter.buttonMode = true;
			btnCenter.visible = false;
		}	
		
		function init_xml(){
			myXML  =  XMLParser.mainXML;			
			if (myXML.player.settings.@preroll == 'true') {				
				//Security.loadPolicyFile(myXML.player.settings.adv.preroll.@crossdomain)
				var xml = new XMLParser(myXML.player.settings.adv.preroll.@path, adv_xml_parse_done)
			} else {
				
				init()
			}
		}
		function adv_xml_parse_done() {
			advXML = XMLParser.mainXML;			
			init();
		}
		
		function playPrevVideo(){
			current--;
			if (current<0){
				current = 0
			}
			settings.src = myXML.player.play_videos.video[current].@file
			myVideo.src    = settings.src
			myVideo.playVideo()
			adv = false;
		}
		
		function playNextVideo(){
			current++
			if (current>=myXML.player.play_videos.video.length()){
				//show_playlist()
				myVideo.stop()
				//myNavigation.checkNavButtons()
				return
			}
			
			settings.src   = myXML.player.play_videos.video[current].@file
			myVideo.src    = settings.src
			myVideo.playVideo()
			adv = false;
		}
		
		function show_playlist(){
			myNavigation.close_box(new MouseEvent(''))
			myPlaylist.show()
		}
		
		function init(){						
			settings.src = myXML.player.file.@path
			current = 0;		
			
			if (myXML.player.settings.@preroll == 'true'){
				this.initAdPlayer();
			} else {
				prerollTimerDone = true;
				playVideo();
			}
			
			root.stage.addEventListener(Event.RESIZE, stage$resize)
			
			myNavigation   = new ClassNavigation()
			//myVideo        = new ClassVideo()
			//myPlaylist     = new ClassPlaylist()
			//myVideo.src    = settings.src
			//myVideo.playVideo()
			

			//myNavigation.checkNavButtons()
			
			stage$resize(new Event(''))
			
			/*
			var myMenu:ContextMenu = new ContextMenu();
			myMenu.hideBuiltInItems();
			var menu_brand : ContextMenuItem = new ContextMenuItem('Bia2.com HD player');
			//menu_brand.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menu_brand$click)			
		
			myMenu.customItems.push(menu_brand);
			this.contextMenu = myMenu;		
			*/			
		}
		
		public function playVideo():void {
			trace ("playVideo");
			if (prerollTimerDone) {
				this.loadAnimation();
			} else {
				this.advLoadFailHandler();
			}
			
			//trace ("function playVideo");
		}
		
		public function pauseVideo():void {
			//trace ("pauseVideo");
		}
		
		public function prerollStatus():void {
			//trace ("STATUS");
		}
		
		private function initAdPlayer():void {
			var config:Object = getAdPlayerObject();
			var callbackObject:Object = getCallBackObject();
			adaptvPlayer = new AdaptvPlayer(config, callbackObject);
			video_layer.addChild(adaptvPlayer);
			adaptvPlayer.setStatus(this.prerollStatus);
			if (myXML.player.settings.@minTime != "" || myXML.player.settings.@minTime != undefined) {
				videoAdvTimer = new Timer(Number(myXML.player.settings.@minTime), 0);
			} else {
				videoAdvTimer = new Timer(2500, 0);
			}
			
			videoAdvTimer.addEventListener(TimerEvent.TIMER, advTimerHandler, false, 0, true);
			videoAdvTimer.start();
		}
		
		private function advTimerHandler(e:TimerEvent):void {
			prerollTimerDone = true;
		}
		
		private function advLoadFailHandler():void {
			trace ("advLoadFailHandler: not loaded");
			this.loadImageAdv();
			btnCenter.addEventListener(MouseEvent.CLICK, centerBtnClickHandler, false, 0, true);
			btnCenter.visible = true;
		}
		
		private function centerBtnClickHandler(e:MouseEvent):void {
			btnCenter.visible = false;
			this.loadAnimation();
			imageLoader.removeEventListener(Event.INIT, imageLoaderInitHandler);
			btnCenter.removeEventListener(MouseEvent.CLICK, centerBtnClickHandler);
			animation.container.removeChild(imageLoader);
		}
		
		private function loadImageAdv():void {
			imageLoader.contentLoaderInfo.addEventListener(Event.INIT, imageLoaderInitHandler, false, 0, true);
			request = new URLRequest(myXML.player.image.@path);
			animation.container.addChild(imageLoader);
			imageLoader.load(request);
			
			imageLoader.addEventListener(MouseEvent.CLICK, navigateToAds, false, 0, true);
			
		}
		
		private function navigateToAds(e:MouseEvent):void {
			request = new URLRequest(myXML.player.image.@click);
			navigateToURL(request, "_blank");
			centerBtnClickHandler(null);
		}
		
		private function imageLoaderInitHandler(e:Event):void {
			var sw = stage.stageWidth;
			var sh = stage.stageHeight;
			imageLoader.x = Math.round(sw / 2 - imageLoader.width / 2);
			imageLoader.y = Math.round(sh / 2 - imageLoader.height / 2);
		}
		
		function stage$resize(e:Event){
			var sw = stage.stageWidth
			var sh = stage.stageHeight
			
			navigation_mc.x = 0;
			navigation_mc.y = 0
			
			//navigation_mc.bottom_navigation.navigation_bg.width            = sw
			//navigation_mc.bottom_navigation.y    = sh - navigation_mc.bottom_navigation.height
			navigation_mc.progress_mc.y          = sh - navigation_mc.progress_mc.height;
			
			
			navigation_mc.progress_mc.volume_bar.x  = sw - 97;
			navigation_mc.progress_mc.volume_icon.x = sw - 123;
			navigation_mc.progress_mc.bg.width = sw;
			
			var $width = sw -151;
			//navigation_mc.progress_mc.video_progress.progress_bar.width = $width;
			//navigation_mc.progress_mc.video_progress.top1.width = $width;
			//navigation_mc.progress_mc.video_progress.top2.width = $width;
			//navigation_mc.progress_mc.video_progress.right.x = $width

			//navigation_mc.bottom_navigation.navigation_bg.width = sw
			
			//navigation_mc.bottom_navigation.size_mc.x = sw-70
			//navigation_mc.bottom_navigation.embed_btn.x = sw-129
			//navigation_mc.bottom_navigation.download_btn.x = sw-230
			//navigation_mc.bottom_navigation.share_btn.x = sw-289
			
			//navigation_mc.bottom_navigation.timeTF.x = (sw-91-289)/2
			
			
			//playlist.x = (sw - 374) / 2;
			//playlist.y = (sh - 256 - navigation_mc.bottom_navigation.height) / 2;
			
			
			/*if(stage.displayState == StageDisplayState.FULL_SCREEN){
				navigation_mc.bottom_navigation.size_mc.gotoAndStop(2)
			}else{
				navigation_mc.bottom_navigation.size_mc.gotoAndStop(1)				
			}*/
			
			btnCenter.x = Math.round(sw/2 - btnCenter.width /2)
			btnCenter.y = Math.round(sh/2 - btnCenter.height/2)			
			imageLoader.x = Math.round(sw / 2 - imageLoader.width / 2);
			imageLoader.y = Math.round(sh / 2 - imageLoader.height / 2);
			
			//block_mc.width  = sw
			//block_mc.height = sh			
			
			
			myNavigation.update_code_box_position()
					
			if (adaptvPlayer) {
				adaptvPlayer.setSize(stage.stageWidth, stage.stageHeight);				
			}
			
			/*if (prerollDone) {
				this.resizeAnimation();
			}*/
			//this.setSize(video_layer, stage.stageWidth, stage.stageHeight);
			//checkVideoSize();
			
			//trace (video_layer.video_mc.width + "   " + video_layer.video_mc.height);
		}
		function checkVideoSize(manual:Boolean = false){
			var swidth      = stage.stageWidth
			var sheight     = stage.stageHeight

			var scaleOrientation : String 
			var ratio_video = myVideo.myPlayer.video_width / myVideo.myPlayer.video_height
			var ratio_stage = swidth / sheight
			if(ratio_video < ratio_stage){
				scaleOrientation = 'fith'
			}else{
				scaleOrientation = 'fitw'
			}
			myVideo.myPlayer.setCustomVideoSize(swidth,sheight)
			if(!manual){
				myVideo.myPlayer.manualVideoSize(swidth,sheight,scaleOrientation)
			}else{
				myVideo.myPlayer.manualVideoSize(swidth,sheight, scaleOrientation, true)
			}
			myVideo.myPlayer.vscale = scaleOrientation
			
		}
		
		public function getCallBackObject():Object {
			var object:Object = {
				playVideo: this.playVideo,
				pauseVideo: this.pauseVideo,
				advNotLoaded: this.advLoadFailHandler
			}
			return object;
		}
		
		public function getAdPlayerObject():Object {
			var tmpArr:Array = new Array();
			var config:Object = {

				// consult http://publishers.adap.tv/pubcon/app/support/integration/reference
				// for more detailed information.
			   
				// parameters about the video view
				
				
				key: advXML.key.toString(),             // Your publisher key provided by Adap.tv. Use 'integration_test' first for testing.
				zid: advXML.zid.toString(),             // Name of the zone for this videoview.
				adaptag: "partner1, tag1",          // A comma-delimited list of adaptags
				companionId: advXML.companionId.toString(),     // The id attribute of the div to contain the companion ad

				// Parameter to pass metadata for specific ad networks, or for insertion into dynamic ad tags.
				// Contents of the context parameter must be url encoded
				// In this case, we are passing 'key1=value1,key2=value2'
				context: advXML.context.toString(),

				// parameters about the video

				id: advXML.id.toString(),                         // The unique identifier of the video (limit 64 chars)
				title: advXML.title.toString(),                // The title of the video
				duration: advXML.duration.toString(),                     // The duration of video in _seconds_, if applicable
				url: advXML.url.toString(), 					// A valid HTTP or RMTP URL for the video (usually .flv) file.
				description: advXML.description.toString(),          // description of video
				
				
				
				
				
				keywords: "test,video,adaptv",      // A comma-delimited list of tags/keywords
				categories: "category1,category2",  // A comma-delimited list of top level categories    

				// parameters about the video player
			   
				width: stage.stageWidth,                       // width of video frame
				height: stage.stageHeight - 30,                      // height of video frame
			   
				// parameters to position the ad player
			   
				htmlX: "0",                         // horizontal offset, in pixels. defaults to "0".
				htmlY: "0"                          // vertical offset, in pixels. defaults to "0".
			}
			
			for each (var item in advXML.keywords.value) {
				tmpArr.push(item);
			}			
			config.keywords = tmpArr.toString();
			
			tmpArr = [];
			for each (item in advXML.categories.value) {
				tmpArr.push(item);
			}			
			config.categories = tmpArr.toString();
			
			tmpArr = [];
			for each (item in advXML.adaptag.value) {
				tmpArr.push(item);
			}			
			config.adaptag = tmpArr.toString();
			return config;
		}
		
		public function set volume(value):void{
			video_layer.soundTransform = new SoundTransform(value);
		}
		
		private function loadAnimation():void {
			if (!loader) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.INIT, loaderInitHandler, false, 0, true);
				//
			} 
			
			request = new URLRequest(myXML.player.file.@path);
			
			loader.load(request);
			video_layer.x = 0;
			video_layer.y = 0;
		}
		
		private function loaderInitHandler($event:Event):void {			
			var mask:Sprite = new Sprite();
			//video_layer.scaleX = 1;
			//video_layer.scaleY = 1;
			/*mask.graphics.beginFill(0x000000);
            mask.graphics.drawRect(0, 0, $event.currentTarget.width, $event.currentTarget.height);
            mask.graphics.endFill();
			mask.alpha = 0;
			loader.mask = mask;*/
			
			/*animation.mask.width = $event.currentTarget.width;
			animation.mask.height = $event.currentTarget.height;*/
			
			animation.container.addChild(loader);
			
			//trace (animation.width + "   " + animation.height);
			//trace (animation.container.width + "   " + animation.container.height);
			
			//this.resizeAnimation();
			navigation_mc.visible = false;
			//trace ($event.currentTarget.width + "  " + $event.currentTarget.height);
		}
		
		private function resizeAnimation():void {			
			var coef:Number =  loader.contentLoaderInfo.width / loader.contentLoaderInfo.height;
			animation.width = stage.stageWidth;
			animation.height = stage.stageWidth / coef;
			
			if (animation.height > stage.stageHeight) {
				animation.height = stage.stageHeight;
				animation.width = stage.stageHeight * coef;
			}
			
			animation.x = (stage.stageWidth - animation.width) / 2;
			animation.y = (stage.stageHeight - animation.height) / 2;
			
			
			
		}
	}
}