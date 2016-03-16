package com{
	class ClassNavigation{
		import flash.events.*
		import flash.display.*
		import flash.utils.*
		import flash.net.*
		import flash.system.*
		import com.ClassUtils
		import com.TweenLite
		import flash.net.navigateToURL;
		import flash.net.URLRequest;
		
		var root                 : MovieClip
		var wasSeek              : Boolean
		var seekTimer            : Timer = new Timer(50)
		var volumeTimer          : Timer = new Timer(50)		
		var hideTimer            : Timer = new Timer(1000)
		var beforeSeekStatus     : String
		var tmpVolume			 : Number = 0.75;
		var volumeOn			 : Boolean = true;
		
		function ClassNavigation(){
			root = ClassUtils.root
			
			//root.navigation_mc.progress_mc.video_progress.progress_bar.buttonMode   = true
			//root.navigation_mc.bottom_navigation.btn_media.buttonMode               = true
			//root.navigation_mc.bottom_navigation.size_mc.buttonMode                = true
			root.navigation_mc.progress_mc.volume_bar.buttonMode                    = true
			root.navigation_mc.progress_mc.volume_icon.buttonMode                     = true
			
			//root.navigation_mc.bottom_navigation.btn_media.addEventListener(MouseEvent.CLICK, btn_media$click)
			
			
			//root.navigation_mc.progress_mc.video_progress.progress_bar.addEventListener(MouseEvent.MOUSE_DOWN, progress_mc$mouse_down)
			//root.navigation_mc.progress_mc.video_progress.progress_bar.addEventListener(MouseEvent.MOUSE_UP,   progress_mc$mouse_up)			
			//seekTimer.addEventListener(TimerEvent.TIMER,doSeek)			
			
			//root.navigation_mc.bottom_navigation.size_mc.addEventListener(MouseEvent.CLICK,          btn_size$click)
			root.navigation_mc.progress_mc.volume_bar.addEventListener(MouseEvent.MOUSE_DOWN,   volume_bar$mouse_down)
			root.navigation_mc.progress_mc.volume_bar.addEventListener(MouseEvent.MOUSE_UP,     volume_bar$mouse_up)			
			//root.block_mc.addEventListener(MouseEvent.CLICK,                                 block_mc$click)
			
			volumeTimer.addEventListener(TimerEvent.TIMER, volumeTimer$timer)
			
			root.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage$mouse_move)
			hideTimer.addEventListener(TimerEvent.TIMER,       hideTimer$timer)
			hideTimer.start()
			
			root.navigation_mc.progress_mc.volume_icon.addEventListener(MouseEvent.CLICK, volume_icon$click);
			
			
			//root.navigation_mc.bottom_navigation.prev_btn.addEventListener(MouseEvent.CLICK, prev_video_btn)
			//root.navigation_mc.bottom_navigation.next_btn.addEventListener(MouseEvent.CLICK, next_video_btn)
			
			
			//root.navigation_mc.bottom_navigation.share_btn.addEventListener(MouseEvent.CLICK, create_share)
			//root.navigation_mc.bottom_navigation.download_btn.addEventListener(MouseEvent.CLICK, download)
			//root.navigation_mc.bottom_navigation.embed_btn.addEventListener(MouseEvent.CLICK, create_embed)
			
			
			
			root.navigation_mc.progress_mc.volume_icon.gotoAndStop(100)
		}
		
		function create_embed(e:MouseEvent){
			close_box(new MouseEvent(''))
			
			var code_box = new Embed_box()
			code_box.codeTF.text = root.myXML.player.settings.codes.embed_code
			create_box(code_box)
		}
		
		function create_share(e:MouseEvent){
			close_box(new MouseEvent(''))
			
			var code_box = new Share_box()
			code_box.codeTF.text = root.myXML.player.settings.codes.share_code
			create_box(code_box)
		}
		
		function update_code_box_position(){
			var sw = root.stage.stageWidth
			var sh = root.stage.stageHeight
			
			if (root.getChildByName('code_box')){
				MovieClip(root.getChildByName('code_box')).x = (sw-MovieClip(root.getChildByName('code_box')).width)/2
				MovieClip(root.getChildByName('code_box')).y = (sh-MovieClip(root.getChildByName('code_box')).height)/2
			}
		}
		
		function create_box(box){			
			box.name = 'code_box'
			box.alpha = 0			
						
			TweenLite.to(box,0.5,{alpha:1})
			root.addChild(box)

			update_code_box_position()
			
			MovieClip(root.getChildByName('code_box')).copy_btn.addEventListener(MouseEvent.CLICK, copy_code)
			MovieClip(root.getChildByName('code_box')).close_btn.addEventListener(MouseEvent.CLICK, close_box)
		}

		function copy_code(e:MouseEvent){
			System.setClipboard(e.target.parent.codeTF.text);
			e.target.parent.codeTF.text = 'Code was save in your clipboard';
			TweenLite.to(MovieClip(root.getChildByName('code_box')),0.5,{delay:1, alpha:0, onComplete:hideComplete})
		}		
		
		function hideComplete(){
			close_box(new MouseEvent(''));
		}
		
		function close_box(e:MouseEvent){
			if (root.getChildByName('code_box')){
				root.removeChild(MovieClip(root.getChildByName('code_box')))
			}			
		}
		
		function download(e:MouseEvent){
			var url = root.myXML.player.play_videos.video[root.current].@download_link;
			var request:URLRequest = new URLRequest(url);
            navigateToURL(request, '_blank');
		}		
		
		function prev_video_btn(e:MouseEvent){
			if (root.adv == false){
				root.playPrevVideo()
			}
		}
		function next_video_btn(e:MouseEvent){
			if (root.adv == false){
				root.playNextVideo()
			}
		}
		
		//----------------
		function hideTimer$timer(e:TimerEvent){
			TweenLite.to(root.navigation_mc.progress_mc,0.5,{alpha:0})
		}
		function stage$mouse_move(e:MouseEvent){
			hideTimer.stop()
			hideTimer.start()
			if(root.navigation_mc.progress_mc.alpha < 1){
				TweenLite.to(root.navigation_mc.progress_mc,0.5,{alpha:1})
			}
		}
		//----------------
		function btn_media$click(e:MouseEvent){
				if(root.myVideo.myPlayer.vstatus == null){
					root.myVideo.myPlayer.vstatus = root.myVideo.myPlayer.VIDEO_STOP
				}
				if(root.myVideo.myPlayer.vstatus == root.myVideo.myPlayer.VIDEO_PLAYING){
					root.myVideo.myPlayer.pause()
				}else if(root.myVideo.myPlayer.vstatus == root.myVideo.myPlayer.VIDEO_PAUSE){
					root.myVideo.myPlayer.resume()
					root.myPlaylist.hide()
				}else if(root.myVideo.myPlayer.vstatus == root.myVideo.myPlayer.VIDEO_STOP){
					root.myVideo.myPlayer.play()
					root.myPlaylist.hide()					
				}
				//checkNavButtons()
		}
		function checkNavButtons(){
			if(root.myVideo.myPlayer.vstatus == null){
				root.myVideo.myPlayer.vstatus = root.myVideo.myPlayer.VIDEO_STOP
			}
			if(root.myVideo.myPlayer.vstatus == root.myVideo.myPlayer.VIDEO_PLAYING){
				root.navigation_mc.bottom_navigation.btn_media.gotoAndStop(2)
				root.btn_center.visible = false				
			}else if(root.myVideo.myPlayer.vstatus == root.myVideo.myPlayer.VIDEO_PAUSE){
				root.navigation_mc.bottom_navigation.btn_media.gotoAndStop(1)
				root.btn_center.visible = true
			}else if(root.myVideo.myPlayer.vstatus == root.myVideo.myPlayer.VIDEO_STOP){
				root.navigation_mc.bottom_navigation.btn_media.gotoAndStop(1)	
				root.btn_center.visible = true				
			}
		}
		//---------------
		function progress_mc$mouse_down(e:MouseEvent){
			if (root.adv == true) return;
			root.stage.addEventListener(MouseEvent.MOUSE_UP, progress_mc$mouse_up)
			wasSeek = true
			beforeSeekStatus = root.myVideo.myPlayer.vstatus
			seekTimer.start()
			root.myVideo.myPlayer.pause()	
		}
		function progress_mc$mouse_up(e:MouseEvent){
			root.stage.removeEventListener(MouseEvent.MOUSE_UP, progress_mc$mouse_up)			
			seekTimer.stop()
			if(wasSeek){
				if(beforeSeekStatus == root.myVideo.myPlayer.VIDEO_PLAYING && root.myVideo.myPlayer.vstatus!=root.myVideo.myPlayer.VIDEO_STOP){
					root.myVideo.myPlayer.resume()
				}
			}
			wasSeek = false
		}
		function doSeek(e:TimerEvent):void{
			var percent = (root.navigation_mc.progress_mc.video_progress.progress_bar.mouseX) / root.navigation_mc.progress_mc.video_progress.progress_bar.width*root.navigation_mc.progress_mc.video_progress.progress_bar.scaleX
			if(percent<0)percent = 0
			if(percent>1)percent = 1
			percent *= 100
			root.myVideo.myPlayer.seek(percent)
		}
		function btn_size$click(e:MouseEvent) {
			trace ("resize");
			if(root.stage.displayState == StageDisplayState.NORMAL){
				root.stage.displayState = StageDisplayState.FULL_SCREEN
			}else{
				root.stage.displayState = StageDisplayState.NORMAL
			}
		}
		function volume_bar$mouse_down(e:MouseEvent){
			root.stage.addEventListener(MouseEvent.MOUSE_UP, volume_bar$mouse_up)
			volumeTimer.start()
		}
		function volume_bar$mouse_up(e:MouseEvent){
			root.stage.removeEventListener(MouseEvent.MOUSE_UP, volume_bar$mouse_up)
			volumeTimer.stop()			
		}
		function volumeTimer$timer(e:TimerEvent){
			var currentX = root.navigation_mc.progress_mc.volume_bar.mouseX*root.navigation_mc.progress_mc.volume_bar.scaleX

			if(currentX < 0 ) currentX = 0
			if(currentX > root.navigation_mc.progress_mc.volume_bar.progress.width) currentX = root.navigation_mc.progress_mc.volume_bar.progress.width

			var percent =  currentX / root.navigation_mc.progress_mc.volume_bar.progress.width;
			tmpVolume = percent;
			update_volume(percent);
		}
		
		
		function block_mc$click(e:MouseEvent) {
			if (!ClassUtils.root.adv){
				btn_media$click(new MouseEvent(''))
			}else {
				var url = root.advURL
				var request:URLRequest = new URLRequest(url);
				navigateToURL(request, '_blank');	
			}
			
		}
		
		function volume_icon$click(e:MouseEvent) {
			if (volumeOn) {				
				this.update_volume(0);
				volumeOn = false;
			} else {
				this.update_volume(tmpVolume);
				volumeOn = true;
			}
		}
		
		function update_volume(value) {			
			root.navigation_mc.progress_mc.volume_bar.volume_show.width = value*root.navigation_mc.progress_mc.volume_bar.progress.width			
			root.volume = value
			root.navigation_mc.progress_mc.volume_icon.gotoAndStop(Math.round(value*100))
		}
	}
}