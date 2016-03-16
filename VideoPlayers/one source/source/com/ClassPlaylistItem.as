package com{
	import flash.events.*
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.net.navigateToURL;
    import flash.net.URLRequest;

	public class ClassPlaylistItem extends MovieClip{
		var node
		var num
		function ClassPlaylistItem(){
			
		}		
		function init(){
			var image_loader:Loader = new Loader();
			
			image_loader.load(new URLRequest(node.@image))
			image.addChild(image_loader)

			empty.buttonMode = true
			empty.addEventListener(MouseEvent.MOUSE_OVER, over)
			empty.addEventListener(MouseEvent.MOUSE_OUT, out)
			empty.addEventListener(MouseEvent.CLICK, click)
			
			titleTF.text = node.@title;
			byTF.text    = 'By: '+node.@by;
			num_commentsTF.text = node.@comments;
			rating_mc.gotoAndStop(node.@rating);			
		}
		
		function click(e:MouseEvent){
			var url = node.@path;
			var request:URLRequest = new URLRequest(url);
            navigateToURL(request, '_self');
		}
		
		function over(e:MouseEvent):void{
			bg.gotoAndStop(2)
		}
		
		function out(e:MouseEvent):void{
			bg.gotoAndStop(1)
		}
	}
}