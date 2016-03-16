<?php

    // SWFAddress code fully compatible with Apache HTTPD
	
    
    $swfaddress_value = '/';
    $swfaddress_path = '/';
    $swfaddress_parameters = array();
    $swfaddress_content = '';
    
    function is_msie() {
        return strstr(strtoupper($_SERVER['HTTP_USER_AGENT']), 'MSIE');
    }
    
    function swfaddress() {
    
        global $swfaddress_value, $swfaddress_path, $swfaddress_parameters, $swfaddress_content;

        $base = swfaddress_base();
    
        session_start();

        if ('application/x-swfaddress' == (isset($_SERVER['CONTENT_TYPE']) ? $_SERVER['CONTENT_TYPE'] : 
            (isset($_SERVER['HTTP_CONTENT_TYPE']) ? $_SERVER['HTTP_CONTENT_TYPE'] : ''))) {
            $swfaddress_value = preg_replace('/&hash=(.*)$/', '#$1', $_SERVER['QUERY_STRING']);
            $_SESSION['swfaddress'] = $swfaddress_value;
            echo('location.replace("' . $base . '/#' . $swfaddress_value . '")');
            exit();
        }
        
        if (isset($_SESSION['swfaddress'])) {
            $swfaddress_value = $_SESSION['swfaddress'];
            unset($_SESSION['swfaddress']);
        } else {
            $page = substr($_SERVER['PHP_SELF'], strrpos($_SERVER['PHP_SELF'], '/') + 1);
            $swfaddress_value = str_replace($base, '', (strpos($page, '.php') && $page != 'index.php') ? $_SERVER['REQUEST_URI'] : str_replace($page, '', $_SERVER['REQUEST_URI']));
        }
        
        $query_string = (strpos($swfaddress_value, '?')) ? substr($swfaddress_value, strpos($swfaddress_value, '?') + 1, strlen($swfaddress_value)) : '';
        
        if ($query_string != '') {
            $swfaddress_path = substr($swfaddress_value, 0, strpos($swfaddress_value, '?'));
            $params = explode('&', str_replace($swfaddress_path . '?', '', $swfaddress_value));
            for ($i = 0; $i < count($params); $i++) {
                $pair = explode('=', $params[$i]);
                $swfaddress_parameters[$pair[0]] = $pair[1];
            }
        } else {
            $swfaddress_path = $swfaddress_value;
        }
        /*
        $url = strtolower(array_shift(explode('/', $_SERVER['SERVER_PROTOCOL']))) . '://';
        $url .= $_SERVER['SERVER_NAME'];
        $url .= swfaddress_base() . '/datasource.php?swfaddress=' . $swfaddress_path;
        $url .= (strpos($swfaddress_value, '?')) ? '&' . substr($swfaddress_value, strpos($swfaddress_value, '?') + 1, strlen($swfaddress_value)) : '';

        $fh = fopen($url, 'r');
        while (!feof($fh)) {
            $swfaddress_content .= fgets($fh, 4096);
        }    
        fclose($fh);
		*/
		
		// derni.com replcaement content source
		$swfaddress_content = getPageContent($swfaddress_path);
		
        if (strstr($swfaddress_content, 'Status(')) {
            $begin = strpos($swfaddress_content, 'Status(', 0);
            $end = strpos($swfaddress_content, ')', $begin);
            $status = substr($swfaddress_content, $begin + 7, $end - $begin - 7);
            if (php_sapi_name() == 'cgi') {
                header('Status: ' . $status);
            } else {
                header('HTTP/1.1 ' . $status);
            }
        }
        
        if (is_msie()) {
        
            $if_modified_since = isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) ? 
                preg_replace('/;.*$/', '', $_SERVER['HTTP_IF_MODIFIED_SINCE']) : '';
            
            $file_last_modified = filemtime($_SERVER['SCRIPT_FILENAME']);
            $gmdate_modified = gmdate('D, d M Y H:i:s', $file_last_modified) . ' GMT';
        
            if ($if_modified_since == $gmdate_modified) {
                if (php_sapi_name() == 'cgi') {
                    header('Status: 304 Not Modified');
                } else {
                    header('HTTP/1.1 304 Not Modified');
                }
                exit();
            }
        
            header('Expires: ' . gmdate('D, d M Y H:i:s', time() + 86400) . ' GMT');
            header('Last-Modified: ' . $gmdate_modified);
            header('Cache-control: max-age=' . 86400);
        }
     }

    function swfaddress_base() {
        return substr($_SERVER['PHP_SELF'], 0, strrpos($_SERVER['PHP_SELF'], '/'));
    }
         
    function swfaddress_title($title) {
        if (!is_msie()) {
            $names = swfaddress_path_names();
            for ($i = 0; $i < count($names); $i++) {
                $title .= ' / ' . strtoupper(substr($names[$i], 0, 1)) . substr($names[$i], 1);
            }
        }
        echo($title);
    }
    
    function swfaddress_resource($resource) {
        echo(swfaddress_base() . $resource);
    }
    
    function swfaddress_link($link) {
        echo(swfaddress_base() . $link);
    }
    
    function swfaddress_content() {
        global $swfaddress_content;
        echo($swfaddress_content);
    }
    
    function swfaddress_path() {
        global $swfaddress_path;
        return $swfaddress_path;
    }
    
    function swfaddress_path_names() {
        global $swfaddress_path;
        $names = explode('/', $swfaddress_path);
        if (substr($swfaddress_path, 0, 1) == '/')
            array_splice($names, 0, 1);
        if (substr($swfaddress_path, count($swfaddress_path) - 1, 1) == '/')
            array_splice($names, count($names) - 1, 1);
        return $names;
    }

    function swfaddress_optimizer($resource) {
        global $swfaddress_value;
        $base = swfaddress_base();
        echo($base . $resource . (strstr($resource, '?') ? '&amp;' : '?') . 'swfaddress=' . urlencode($swfaddress_value) . '&amp;base=' . urlencode($base));        
    }
	
	//--------------------------------------------
	// mbudm.com additions to SWFAddress SEO solution
	// - loads the mbudm.com site template XML data into the page
	//--------------------------------------------
	
	// the 'menu' - ignores images and videos as these are linked from the content area
	function parseIndex($xml=NULL,$parent="")
	{	
	
		global $indexItems,$indexContent;
		//$indexContent .="<ol>\n";
		
		$icStr = "";
		
		$child_count = 0;
		foreach($xml->children() as $value)
		{ 
			$nodeType = $value->getName() == "page" ? $value['type'] : $value->getName() ;
			switch($nodeType){
				case "url":	
					$icStr .="<li><a href=\"".  (string)$value['url'] ."\" title=\"". (string)$value['longtitle']."\" >" . (string)$value['title'] . "</a></li>\n";
				break;
				default:
					if(isset($value['id'])){
						// the aname needs to include any parent ids
						$parent_only_ids = StripPathToIds($parent);
						$aname = $parent_only_ids . "/" . $value['id'];
					}else{
						$aname = $parent . "/" . (string)$child_count;
					}
					$value->addAttribute('coord', $aname);

					if($nodeType != "img" && $nodeType != "video"){
						//do store as an inde item but don't render in the menu
						$icStr .="<li><a href=\"".swfaddress_base() . $value['coord'] ."\" title=\"". (string)$value['longtitle']."\" >" . (string)$value['title'] . "</a>";
						$icStr .= parseIndex($value,$aname);
						$icStr .="</li>\n"; 
					}
					
					$indexItems[$aname] = $value;
	
				break;
			}
			$child_count++;   
		}
		
		if(strlen($icStr) > 0){
			$icStr =  "<ol>\n" .$icStr . "</ol>\n";
		}
		//$indexContent .= $icStr ;
		
		
		return $icStr;
		
	}
	
	function getTextNodes($xml)
	{
		$s = "";
		foreach($xml->children() as $v)
		{ 
			if($v->getName() == "text"){
				$s .= $v->asXML();
			}else{
				$s .= getTextNodes($v);
			}
		}
		return $s;
	}
 
	function getPageContent($path="/0")
	{
		global $indexItems;
		if(!isset($path) || $path == "/" ){
			$path = "/0";
		}
		
		$value = $indexItems[$path];
		
		$str= "<h2>" . (string)$value['title'] . "</h2>\n";
		$str.= "<h3>" . (string)$value['longtitle'] . "</h3>\n";
		
		$nodeType = $value->getName() == "page" ? $value['type'] : $value->getName() ;
		
		if($nodeType != "url" && $nodeType != "external" ){    
			if($value['url']){ 
				$pageObject = simplexml_load_file($value['url']);
				// find text node(s) and add to the str
				$str .= getTextNodes($pageObject);
			}
			$baseURL = swfaddress_base();
			switch($nodeType){
				case "index":
					//print all the thumbnail nodes
					$str .= "<ul>\n";
					$nodeCount = 0;
					
					foreach($value as $k=>$v){
						$nType = $v->getName() == "page" ? $v['type'] : $v->getName();
						$nodeUrl = $baseURL . $v['coord'];
						switch($nType){
							case "index":
								// display a link to the sub index
								$str .= "<li><a href=\"".$nodeUrl."\" title=\"".$v['longtitle']."\" >".$v['title'] . " - " . $v['longtitle']."</a></li>\n";
							break;
							case "img":
							case "video":
								// display the src
								$str .= "<li><a href=\"".$nodeUrl."\" title=\"".$v['alt']."\" ><img src=\"". $baseURL . "/" . $v['src']."\" alt=\"".$v['alt']."\" /></a></li>\n";
							break;
						}
						$nodeCount++;
					}
					$str .= "</ul>\n";
		
				break;
				case "img":
					// display the fullsrc
					$str .= "<img src=\"". $baseURL . "/" . $value['fullsrc']."\" alt=\"".$value['alt']."\" />\n";
				break;
				case "video":
					// display the src
					$str .= "<img src=\"". $baseURL . "/" . $value['src']."\" alt=\"".$value['alt']."\" />\n";
				break;
			}
		}
		return $str;
	}
		 
	// convert a path consisting of numbers & strings to the correct coord path (only numbers)
	// the strings in a path represent an index node id
	/**/
	function StripPathToIds($path){
	
		$path_arr = explode("/", $path);
		
		foreach($path_arr as $key=>$value)
		{
			if(is_numeric($value))
    		{
			 unset($path_arr[$key]);
			}
		}
		
		return implode("/", $path_arr );
	/*	*/
	}   
   	
  
   
    //mbudm addition - the index of all data used in this site
	if (file_exists('data/index.xml')) {
    	$indexXmlObject = simplexml_load_file('data/index.xml');
		$indexItems = array();
		$indexContent = parseIndex($indexXmlObject);
	} else {
		exit('Failed to open data/index.xml.');
	}
	
 	swfaddress();
	
	
    
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <script type="text/javascript" src="<?php swfaddress_optimizer('/js/swfaddress-optimizer.js?flash=8'); ?>"></script>
        <title><?php swfaddress_title('CLINIQUE ROOSEVELT'); ?></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <style type="text/css">
        /*<![CDATA[*/
            html, body {
                height: 100%;
                overflow: hidden;
            }
            body {
                background: #ffffff;
                font: 86% Arial, Helvetica, sans-serif;
                margin: 0;                
            }
            #content {
                height: 100%;
            }
        /*]]>*/
        </style>
        <!-- UNCOMMENT this <script> block to enable Google Analytics
        <script type="text/javascript">
		var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
		document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
		</script>
		<script type="text/javascript">
		try {
        // add your GA id here:
		var pageTracker = _gat._getTracker("UA-XXXXXX-X");
		pageTracker._trackPageview();
		} catch(err) {}</script>-->
        <script type="text/javascript" src="<?php swfaddress_resource('/js/swfobject.js'); ?>"></script>
        <!-- to use Google Analytics, comment out this line and UNCOMMENT the next line -->
        <script type="text/javascript" src="<?php swfaddress_resource('/js/swfaddress.js'); ?>"></script>
		<!--<script type="text/javascript" src="<?php swfaddress_resource('/js/swfaddress.js'); ?>?tracker=pageTracker._trackPageview"></script>-->
		<script type="text/javascript" src="js/swfmacmousewheel2.js"></script>
  		<script type="text/javascript">
			var flashvars = {_init:"data/init.xml"};
			var params = {menu:false,allowFullScreen:true,bgcolor:'#FFFFFF'};
			var attributes = { id:'fObj'}; // give an id to the flash object
			swfobject.embedSWF("init.swf", "content", "100%", "100%", "9.0.0", "expressInstall.swf",flashvars,params,attributes);
			swfmacmousewheel.registerObject(attributes.id);
		</script>
    </head>
    <body>
        <div id="content">
            <div>
                <h1><a href="<?php swfaddress_link('/'); ?>">Derni.com</a></h1>
               <? 
			  	echo($indexContent);
					 
			   ?>
            </div>
            <div><?php swfaddress_content(); ?></div>
        </div>
    </body>
</html>