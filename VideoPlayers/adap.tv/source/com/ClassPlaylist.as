package com{
	import com.TweenLite
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fl.motion.easing.*;
	class ClassPlaylist extends MovieClip{
		private var $root                 : MovieClip
		private var myXML
		private var $this
		private var items_x:Number;
		function ClassPlaylist(){
			$root  = ClassUtils.root			
			$this = $root.playlist;
			myXML = $root.myXML.player.end_playlist;
			init()
		}
		function init(){
			var num_y = 0;
			var num_x = 0;
			for (var i=0;i<myXML.video.length();i++){
				var item = new ClassPlaylistItem()
				item.node = myXML.video[i]
				item.num = i;
				item.init();
				
				item.y = num_y*64;
				item.x = num_x*362;
				
				item.name = 'playlist_item'+i;				
				$this.items_mc.addChild(item)
				num_y++
				if (num_y>=4){
					num_y = 0;
					num_x++
				}
			}
			$this.left_arrow.addEventListener(MouseEvent.CLICK, move_left)
			$this.right_arrow.addEventListener(MouseEvent.CLICK, move_right)
			items_x = $this.items_mc.x
			
			$this.visible = false
		}
		
		function move_left(e:MouseEvent){
			var max = 29
			if (items_x<max){
				items_x += 362
			}			
			if (items_x>max){
				items_x = max;
			}
			if ($this.items_mc.x == items_x) return;
			TweenLite.to($this.items_mc,1,{x:items_x,ease:Back.easeOut})			
			
		}
		function move_right(e:MouseEvent){
			var min = -$this.items_mc.width+29+314

			if(items_x>min){
				items_x -= 362
			}
			if (items_x>min){
				items_x = min
			}			
			if ($this.items_mc.x == items_x) return;
			TweenLite.to($this.items_mc,0.8,{x:items_x,ease:Back.easeOut})	
		}

		
		function show(){
			$this.visible = true
			$this.alpha = 0;
			TweenLite.to($root.playlist,0.8,{alpha:1})			
		}
		function hide(){
			TweenLite.to($root.playlist,0.5,{alpha:0,onComplete:hideComplete})
		}
		function hideComplete(){
			$this.visible = false;
		}
	}
}