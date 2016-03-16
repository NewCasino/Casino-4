package com{
	import flash.display.*
	import flash.events.*
	import flash.ui.*
	import com.*
	import flash.net.*;
	import flash.system.*
	
	public class ClassMain extends MovieClip{
		var settings       : Object      = new Object()
		var myVideo        : ClassVideo
		var myNavigation   : ClassNavigation
		var myPlaylist     : ClassPlaylist
		var myContextMenu  : ContextMenu = new ContextMenu()	
		var myXML:Object = new Object()
		var advXML:Object = new Object()
		var advURL:String = new String() // on video click, redirect url
		
		var current:Number = -1;
		var adv:Boolean = false;
		
		function ClassMain(){
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align     = StageAlign.TOP_LEFT
			ClassUtils.root = MovieClip(this)
			
			
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
			var xml_path = 'data.xml'
			if (paramObj.xml_path != undefined && paramObj.xml_path!=''){
				xml_path = paramObj.xml_path;
			}
			var xml = new XMLParser(xml_path, init_xml)			
		}	
		
		function init_xml(){
			myXML  =  XMLParser.mainXML;			
			if (myXML.player.settings.@preroll == 'true') {
				//Security.loadPolicyFile(myXML.player.settings.adv.preroll.@crossdomain)
				var xml = new XMLParser(myXML.player.settings.adv.preroll.@path, adv_xml_parse_done)
			}else {
				
				init()
			}
		}
		function adv_xml_parse_done() {
			advXML = XMLParser.mainXML;
			init();
		}
		
		function playPrevVideo(){
			current--
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
				show_playlist()
				myVideo.stop()
				myNavigation.checkNavButtons()
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
			settings.src = myXML.player.play_videos.video[0].@file
			current = 0;		
			
			if (myXML.player.settings.@preroll == 'true' && advXML.creative.@defaultAd=="0"){
				if(String(advXML.creative.contentUrl).length>0){
					settings.src = advXML.creative.contentUrl;
					advURL = advXML.creative.clickUrl
					current = -1;
					adv = true;
				}
			}
			
			settings.buffer = 2
			
			if(root.loaderInfo.parameters.f!=undefined){
				settings.src    = root.loaderInfo.parameters.f
			}
			
			root.stage.addEventListener(Event.RESIZE, stage$resize)
			
			myNavigation   = new ClassNavigation()
			myVideo        = new ClassVideo()
			myPlaylist     = new ClassPlaylist()
			myVideo.src    = settings.src
			myVideo.playVideo()

			myNavigation.checkNavButtons()
			
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
		
		function stage$resize(e:Event){
			var sw = stage.stageWidth
			var sh = stage.stageHeight
			
			navigation_mc.x = 0;
			navigation_mc.y = 0
			
			//navigation_mc.bottom_navigation.navigation_bg.width            = sw
			navigation_mc.bottom_navigation.y    = sh - navigation_mc.bottom_navigation.height
			navigation_mc.progress_mc.y          = navigation_mc.bottom_navigation.y - 40
			
			
			navigation_mc.progress_mc.volume_bar.x  = sw - 97;
			navigation_mc.progress_mc.volume_icon.x = sw - 123;
			navigation_mc.progress_mc.bg.width = sw;
			
			var $width = sw -151;
			navigation_mc.progress_mc.video_progress.progress_bar.width = $width;
			navigation_mc.progress_mc.video_progress.top1.width = $width;
			navigation_mc.progress_mc.video_progress.top2.width = $width;
			navigation_mc.progress_mc.video_progress.right.x = $width

			navigation_mc.bottom_navigation.navigation_bg.width = sw
			
			navigation_mc.bottom_navigation.size_mc.x = sw-70
			navigation_mc.bottom_navigation.embed_btn.x = sw-129
			navigation_mc.bottom_navigation.download_btn.x = sw-230
			navigation_mc.bottom_navigation.share_btn.x = sw-289
			
			navigation_mc.bottom_navigation.timeTF.x = (sw-91-289)/2
			
			
			playlist.x = (sw-374)/2
			playlist.y = (sh-256-navigation_mc.bottom_navigation.height)/2
			
			
			if(stage.displayState == StageDisplayState.FULL_SCREEN){
				navigation_mc.bottom_navigation.size_mc.gotoAndStop(2)
			}else{
				navigation_mc.bottom_navigation.size_mc.gotoAndStop(1)				
			}
			
			btn_center.x = Math.round(sw/2 - btn_center.width /2)
			btn_center.y = Math.round(sh/2 - btn_center.height/2)			
			
			block_mc.width  = sw
			block_mc.height = sh			
			
			
			myNavigation.update_code_box_position()
					
			
			checkVideoSize()
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
	}
}