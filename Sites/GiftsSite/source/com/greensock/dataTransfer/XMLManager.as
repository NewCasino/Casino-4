/**
 * VERSION: 2.11
 * DATE: 8/26/2009
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://blog.greensock.com/
 **/
package com.greensock.dataTransfer {
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
/**
 * XMLManager provides an easy way to load and/or send an XML file and parse the data into standard Object/Array
 * ActionScript format. Every node becomes an Array with the same name. All attributes are also easily accessible because 
 * they become properties with the same name. So for example, if this is your XML:<br /><br />
 * <code>
 *		&lt;Resources&gt; <br />
 *			&lt;Book name="Mary Poppins" ISDN="1122563" /&gt;<br />
 *			&lt;Book name="The Bible" ISDN="333777" /&gt;<br />
 *			&lt;Novel name="The Screwtape Letters" ISDN="257896"&gt;<br />
 *				&lt;Description&gt;This is an interesting perspective&lt;/Description&gt;<br />
 *			&lt;/Novel&gt;<br />
 *		&lt;/Resources&gt;<br />
 *	 </code><br /><br />
 *	 Then you could access the first book's ISDN with:<br /><br /><code>
 *	 
 *	 	Book[0].ISDN</code><br /><br />
 *	 
 *	 The value of a node (like the text between the &lt;Description&gt; and &lt;/Description&gt; tags above can
 *	 be accessed using the "nodeValue" property, like so:<br /><br /><code>
 *	 
 *	 	Novel[0].Description[0].nodeValue</code><br /><br />
 *	 
 *	 Just remember that all nodes become arrays even if there's only one node, and attributes become properties. 
 *	 You can obviously loop through the arrays too which is very useful. The root node is ignored for efficiency 
 *	 (less code for you to write) unless you set the keepRootNode to true. <br /><br />
 *
 * <b>EXAMPLE:</b>
 *  
 *	To simply load a <code>myDocument.xml</code> document and parse the data into Object/Array values, do:<br /><br /><code>
 *	
 *		import com.greensock.dataTransfer.XMLManager;<br /><br />
 * 		var myManager:XMLManager = new XMLManager();
 * 		myManager.addEventListener(Event.COMPLETE, onComplete);
 *		myManager.load("myDocument.xml");<br />
 *		function onComplete(event:Event):void { //This function gets called when the XML loads and has been parsed.<br />
 *			trace("The first book is: "+myManager.parsedObject.Book[0].name);<br />
 *		}</code><br /><br />
 *		
 *	Or to send an object to the server in XML format (remember, each element in an array becomes a node and all 
 *	object properties become node attributes) and load the results back into an ActionScript-friendly format, do:<br /><br /><code>
 *	
 *		import com.greensock.dataTransfer.XMLManager;<br />
 *		//Create an object to send an populate it with values...<br />
 *		var toSend = new Object();<br />
 *		toSend.name = "Test Name";<br />
 *		toSend.Book = new Array();<br />
 *		toSend.Book.push({title:"Mary Poppins", ISDN:"125486523"});<br />
 *		toSend.Book.push({title:"The Bible", ISDN:"25478866998"});<br />
 * 		var myManager:XMLManager = new XMLManager();
 * 		myManager.addEventListener(Event.COMPLETE, onComplete);
 *		//Now send the data and load the results from the server into the response_obj...<br />
 *		myManager.sendXMLAndLoad(toSend, "http://www.myDomain.com/myScript.php", "xmlField");<br />
 *		function onComplete(event:Event):void {<br />
 *			trace("The server responded with this XML: " + myManager.xml);<br />
 *			trace("The server's response was translated into this ActionScript object: " + myManager.parsedObject);<br />
 *		}</code><br /><br />
 *		
 *		In the example above, the server would receive the following XML document:<br /><br /><code>
 *		
 *		&lt;XML name="Test Name"&gt;<br />
 *			&lt;Book ISDN="125486523" title="Mary Poppins" /&gt;<br />
 *			&lt;Book ISDN="25478866998" title="The Bible" /&gt;<br />
 *		&lt;/XML&gt;</code><br /><br />
 *	
 * <b>NOTES:</b><br /><br />
 * <ul>
 *		<li> XMLManager is case sensitive, so if you run into problems, check that.</li>
 *		<li> The value of any text node can be accessed with the "nodeValue" property as mentioned above.</li>
 *		<li> A valid XML document requires a single root element, so in order to consolidate things,
 *	  that root will be ignored in the resulting parsedObject. So if your root element is &lt;Library&gt;
 *	  and it has &lt;Book&gt; nodes, you don't have to access them with <code>Library[0].Book[0]</code>. You can 
 *	  just do <code>Book[0]</code>. That is, unless you set the <code>keepRootNode</code> property to <code>true</code>.</li>
 *		<li> You can simply translate an object into XML (without sending it anywhere) using the 
 *	  		<code>XMLManager.objectToXML(myObject)</code> function which returns an XML instance.</li>
 *		<li> Cancel the loading of an XML file using the cancel() method.</li>
 * </ul>
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 **/
	public class XMLManager extends EventDispatcher {
		/** @private **/
		private static var _all:Array = [];
		/** @private **/
		private static var _findLetters:RegExp = new RegExp("([a-zA-Z])", ""); //use this to sense if a String is truly numeric - we'd get false positives using !isNaN(Number(s)) if the value was something like 444e.
		
		/** Controls whether or not the root node of the XML is ignored when parsing (doing so can make your code a bit shorter). **/
		public var keepRootNode:Boolean = false;
		/** If true, line breaks in XML will be recognized ("\n" added in the ActionScript). **/
		public var parseLineBreaks:Boolean = false;
		/** When XML is parsed, the resulting object is stored here. Remember, all XML nodes are turned into Arrays (each collection of identically-named nodes becomes and Array) and each Array is populated with an Object with property names that match the XML attribute names. **/
		public var parsedObject:Object;
		
		/** @private **/
		private var _loaded:Boolean = false;
		/** @private **/
		private var _request:URLRequest;
		/** @private **/
		private var _loader:URLLoader;
		/** @private **/
		private var _xml:XML;
		
		/** Constructor **/
		public function XMLManager() {
			XML.ignoreWhitespace = XML.ignoreComments = true;
			_loader = new URLLoader();
			setupListeners();
			_all.push(this);
		}
		
		/**
		 * Loads a URL and parses the resulting XML.
		 *  
		 * @param url The URL to load
		 * @param keepRootNode Controls whether or not the root node of the XML is ignored when parsing (doing so can make your code a bit shorter).
		 * @param parseLineBreaks If true, line breaks in XML will be recognized ("\n" added in the ActionScript).
		 */
		public function load(url:String, keepRootNode:Boolean=false, parseLineBreaks:Boolean=false):void {
			_request = new URLRequest(url);
			this.keepRootNode = keepRootNode;
			this.parseLineBreaks = parseLineBreaks;
			_xml = new XML();
			_loader.load(_request);
		}
		
		/** @private **/
		private function setupListeners():void {
			_loader.addEventListener(Event.COMPLETE, parseLoadedXML, false, 0, true);
			_loader.addEventListener(Event.OPEN, onEvent, false, 0, true);
            _loader.addEventListener(ProgressEvent.PROGRESS, onEvent, false, 0, true);
            _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onEvent, false, 0, true);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
		}
		
		/** @private **/
		private function onSecurityError(event:SecurityErrorEvent):void {
			trace("Security error while loading "+_request.url);
			onEvent(event);
		}
		
		/** @private **/
		private function onIOError(event:IOErrorEvent):void {
			trace("IO error while loading "+_request.url);
			onEvent(event);
		}
		
		/** @private **/
		private function onEvent(event:*):void {
			dispatchEvent(event);
		}
		
		/**
		 * Sends URLVariables (method: POST) to a url and loads XML and then parses it.
		 * 
		 * @param postVariables Variables to send to the server via the POST method.
		 * @param url The URL to send and load the data to/from.
		 * @param keepRootNode Controls whether or not the root node of the XML is ignored when parsing (doing so can make your code a bit shorter).
		 * @param parseLineBreaks If true, line breaks in XML will be recognized ("\n" added in the ActionScript).
		 */
		public function sendVariablesAndLoad(postVariables:URLVariables, url:String, keepRootNode:Boolean=false, parseLineBreaks:Boolean=false):void {
			_request = new URLRequest(url);
			this.keepRootNode = keepRootNode;
			this.parseLineBreaks = parseLineBreaks;
			_xml = new XML();
			_loaded = false;
			_request.data = postVariables;
			_request.method = URLRequestMethod.POST;
			_loader.load(_request);
		}
		
		/**
		 * 
		 * @param toSend An object (either an XML object or a generic object that should be parsed into XML before sending) to send to the URL.
		 * @param url The URL to send and load the data to/from.
		 * @param fieldName The field name that the XML will be submitted through (you need this for the server-side script to know which POST field contains the XML)
		 * @param keepRootNode Controls whether or not the root node of the XML is ignored when parsing (doing so can make your code a bit shorter).
		 * @param parseLineBreaks If true, line breaks in XML will be recognized ("\n" added in the ActionScript).
		 */
		public function sendXMLAndLoad(toSend:Object, url:String, fieldName:String="xml", keepRootNode:Boolean=false, parseLineBreaks:Boolean=false):void {
			var xmlToSend:XML = (toSend is XML) ? toSend as XML : objectToXML(toSend);
			var variables:URLVariables = new URLVariables();
			variables[fieldName] = xmlToSend.toXMLString();
			sendVariablesAndLoad(variables, url, keepRootNode, parseLineBreaks);
		}	
	
		/** @private **/
		private function parseLoadedXML(event:Event):void {
			var loader:URLLoader = event.target as URLLoader;
			if (loader == null) {
				onEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Failed to load the XML"));
				return;
			}
			_xml = new XML(loader.data);
			this.parsedObject = XMLToObject(_xml, this.keepRootNode, this.parseLineBreaks);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Parses an XML object into identically-named native ActionScript Objects/Arrays. All XML nodes are turned into 
		 * Arrays (each collection of identically-named nodes becomes and Array) and each Array is populated with an Object 
		 * with property names that match the XML attribute names.
		 * 
		 * @param xml An XML object to parse into Objects/Arrays
		 * @param keepRootNode Controls whether or not the root node of the XML is ignored when parsing (doing so can make your code a bit shorter).
		 * @param parseLineBreaks If true, line breaks in XML will be recognized ("\n" added in the ActionScript).
		 * @return Parsed object
		 */
		public static function XMLToObject(xml:XML, keepRootNode:Boolean=false, parseLineBreaks:Boolean=false):Object { 
			var obj:Object = {};
			var objLookup:Array = []; //A way to keep track of each node's parent object. Tried using a Dictionary at first (which would have been easier/faster), but there was a bug that prevented it from looking XML object up conistently!
			var c:XML = xml.copy();
			var lastNode:XML = c;
			
			if (!keepRootNode) {
				lastNode = c.children()[c.children().length() - 1];
				c = c.children()[0];
			}
			
			var o:Object, attributes:XMLList, attr:XML, nextNode:XML, po:Object, name:String, splitName:Array; //parent object
			while (c != null) {
				if (c.nodeKind() == "element") {
					
					o = {};
					if (c.text().toString() != "") {
						o.nodeValue = clean(c.text().toString(), parseLineBreaks);
					}
					attributes = c.attributes();
					for each (attr in attributes) {
						o[attr.name().toString()] = clean(attr, parseLineBreaks);
					}
					if (c.parent() == undefined) { //If it's the root node, it won't have a parent!
						po = obj;
					} else {
						po = objLookup[c.parent().@_objLookupIndex] || obj;
					}
					name = c.name().toString().split(":").pop(); //otherwise there were problems when an XML document declared a namespace. 
					if (po[name] == undefined) {
						po[name] = [];
					}
					po[name].push(o);
					c.@_objLookupIndex = objLookup.length;
					objLookup.push(o);
				}
				
				if (c.children().length() != 0) {
					c = c.children()[0];
				} else {
					nextNode = c;
					while (nextNode.parent() != undefined && nextNode.parent().children().length() < nextNode.childIndex() + 2) {
						nextNode = nextNode.parent();
					}
					if (nextNode.parent() != undefined && nextNode != lastNode) {
						c = nextNode.parent().children()[nextNode.childIndex() + 1];
					} else {
						c = null;
					}
				}
			}
			return obj;
		}
		
		/** @private **/
		private static function clean(s:String, parseLineBreaks:Boolean=false):Object {
			if (!isNaN(Number(s)) && s != "" && s.charAt(0) != "0" && s.search(_findLetters) == -1) {
				return Number(s);
			} else if (s == "true") {
				return true;
			} else if (s == "false") {
				return false;
			} else if (parseLineBreaks) {
				return s.split("\\n").join("\n");
			} else {
				return s;
			}
		}
		
		/**
		 * Translates an object (typically with Arrays attached to it) back into an XML object. This can be useful for sending
		 * it back to the server or for saving it somewhere.
		 * 
		 * @param object The object that should be translated into an XML object.
		 * @param rootNodeName The name to be used for the root XML node.
		 * @return An XML object
		 */
		public static function objectToXML(object:Object, rootNodeName:String="XML"):XML {
			var xml:XML = new XML("<" + rootNodeName + " />");
			var n:XML = xml;
			var props:Array = [];
			var i:int, prop:*, p:String;
			for (p in object) {
				props.push(p);
			}
			for (i = props.length - 1; i > -1; i--) { //By default, attributes are looped through in reverse, so we go the opposite way to accommodate for this.
				prop = props[i];
				if (object[prop] is Array) { //Means it's an array!
					if (object[prop].length != 0) {
						arrayToNodes(object[prop], n, xml, prop);
					}
				} else if (prop == "nodeValue") {
					n.appendChild(new XML(object.nodeValue));
				} else {
					n.@[prop] = object[prop];
				}
			}
			return xml;
		}
		
		/** @private Recursive function that walks through any sub-arrays as well **/
		private static function arrayToNodes(a:Array, parentNode:XML, xml:XML, nodeName:String):void {
			var chldrn:Array = [];
			var props:Array, prop:String, n:XML, o:Object, i:int, j:int, p:String;
			for (i = a.length - 1; i >= 0; i--) {
				n = new XML("<" + nodeName + " />");
				o = a[i];
				props = [];
				for (p in o) {
					props.push(p);
				}
				for (j = props.length - 1; j >= 0; j--) { //By default, attributes are looped through in reverse, so we go the opposite way to accommodate for this.
					prop = props[j];
					if (o[prop] is Array) { //Means it's an array!
						arrayToNodes(o[prop], n, xml, prop);
					} else if (prop != "nodeValue") {
						n.@[prop] = o[prop];
					} else {
						n.appendChild(new XML(o.nodeValue));
					}
				}
				chldrn.push(n);
			}
			for (i = chldrn.length - 1; i >= 0; i--) {
				parentNode.appendChild(chldrn[i]);
			}
		}
		
		/** Cancels XML loading **/
		public function cancel():void {
			_loader.close();
		}
		
		/** Destroys an XMLManager and releases it for garbage collection **/
		public function destroy():void {
			cancel();
			_xml = new XML();
			var i:int = _all.length;
			while (i-- > 0) {
				if (this == _all[i]) {
					_all.splice(i, 1);
					break;
				}
			}
		}
		
		
//---- GETTERS / SETTERS --------------------------------------------------------------------
		
		/** Percent loaded **/
		public function get percentLoaded():Number {
			return (this.bytesLoaded / this.bytesTotal) * 100;
		}
		
		/** XML object **/
		public function get xml():XML {
			return _xml;
		}
		
		/** Bytes loaded **/
		public function get bytesLoaded():Number {
			return _loader.bytesLoaded || 0;
		}
		
		/** Total bytes of the loading XML **/
		public function get bytesTotal():Number {
			if (_loaded) {
				return _loader.bytesTotal || 0;
			} else {
				return _loader.bytesTotal || 1024; //We should report back some size for preloaders so that if they do something like (my_mc.getBytesLoaded() + myParser_obj.bytesLoaded) / (my_mc.getBytesTotal() + myParser_obj.bytesTotal) because it might look like it's 100% loaded even though it hasn't started yet!
			}
			
		}
		
	}
}