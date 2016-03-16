package classes {
     import flash.display.Sprite;
     import flash.events.Event;
     import flash.events.IOErrorEvent;
     import flash.net.URLLoader;
     import flash.net.URLLoaderDataFormat;
     import flash.net.URLRequest;
     
     /**
      * ...
      * @author ...
      */
     public class DocumentClass extends Sprite {
          
          private const XML_DATA_PATH:String = "rooms.txt";
          
          private var request:URLRequest;
          private var loader:URLLoader = new URLLoader();
          
          public function DocumentClass() {
               request = new URLRequest(XML_DATA_PATH);
               this.loadData();
          }
          
          private function loadData():void {
               loader.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
               loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);
               loader.dataFormat = URLLoaderDataFormat.TEXT;
               loader.load(request);
          }
          
          private function loaderCompleteHandler(e:Event):void {
               var array:Array = new Array();
               var tmpString:String = e.target.data;
               array = tmpString.split("\n");
               var name:String = "mc" + array[9];
               trace (array);
               //trace ();
          }
          
          private function loaderErrorHandler(e:IOErrorEvent):void {
               trace ("loader error " + e);
          }
          
          
          
     }
     
}