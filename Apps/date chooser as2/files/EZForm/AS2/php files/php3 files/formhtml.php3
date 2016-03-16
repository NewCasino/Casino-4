<?php

//edit this line to include the email address of the form recipient between the quotation marks
//for example:  $formrecipient = "you@youremail.com";
$formrecipient = "";

$headerStyle = $_POST["headerStyle"];
$titleStyle = $_POST["titleStyle"];
$bodyStyle = $_POST["bodyStyle"];
$heading = $_POST["heading"];
$headerFont = $_POST["headerFont"];
$headerSize = $_POST["headerSize"];
$headerColor = $_POST["headerColor"];
$bodyFont = $_POST["bodyFont"];
$bodySize = $_POST["bodySize"];
$bodyColor = $_POST["bodyColor"];
$orderArray = $_POST["orderArray"];
$varArray = $_POST["varArray"];
$layout = $_POST["layout"];
$titleFont = $_POST["titleFont"];
$titleSize = $_POST["titleSize"];
$titleColor = $_POST["titleColor"];
if($formrecipient == "")
	$recipientEmail = $_POST["recipientEmail"];
else
	$recipientEmail = $formrecipient;
$Subject = $_POST["Subject"];
$fromName = $_POST["fromName"];
$fromEmail = $_POST["fromEmail"];
$lineSpacing = $_POST["lineSpacing"];

$spamTest = $fromName;
$spamTest = urldecode($spamTest);
if (eregi("\r",$spamTest) || eregi("\n",$spamTest)){
	die("Attempted spam!!!");
}
$spamTest = $fromEmail;
$spamTest = urldecode($spamTest);
if (eregi("\r",$spamTest) || eregi("\n",$spamTest)){
	die("Attempted spam!!!");
}
$spamTest = $Subject;
$spamTest = urldecode($spamTest);
if (eregi("\r",$spamTest) || eregi("\n",$spamTest)){
	die("Attempted spam!!!");
}

$parseLinks = true;


$headerStyleOpen = "";
$headerStyleClose = "";
$titleStyleOpen = "";
$titleStyleClose = "";
$bodyStyleOpen = "";
$bodyStyleClose = "";


if($headerStyle == "bold-underline") {
	$headerStyleOpen = "<b><u>";
	$headerStyleClose = "</u></b>";
} else if($headerStyle == "underline") {
	$headerStyleOpen = "<u>";
	$headerStyleClose = "</u>";
} else if($headerStyle == "bold") {
	$headerStyleOpen = "<b>";
	$headerStyleClose = "</b>";
}

if($titleStyle == "bold-underline") {
	$titleStyleOpen = "<b><u>";
	$titleStyleClose = "</u></b>";
} else if($titleStyle == "underline") {
	$titleStyleOpen = "<u>";
	$titleStyleClose = "</u>";
} else if($titleStyle == "bold") {
	$titleStyleOpen = "<b>";
	$titleStyleClose = "</b>";
}

if($bodyStyle == "bold-underline") {
	$bodyStyleOpen = "<b><u>";
	$bodyStyleClose = "</u></b>";
} else if($bodyStyle == "underline") {
	$bodyStyleOpen = "<u>";
	$bodyStyleClose = "</u>";
} else if($bodyStyle == "bold") {
	$bodyStyleOpen = "<b>";
	$bodyStyleClose = "</b>";
}


function makeClickableLinks($text) {
	$text = eregi_replace('(((f|ht){1}tp://)[-a-zA-Z0-9@:%_\+.~#?&//=]+)', '<a href="\\1">\\1</a>', $text);
	$text = eregi_replace('([[:space:]()[{}])(www.[-a-zA-Z0-9@:%_\+.~#?&//=]+)', '\\1<a href="http://\\2">\\2</a>', $text);	
	$text = eregi_replace('([_\.0-9a-z-]+@([0-9a-z][0-9a-z-]+\.)+[a-z]{2,3})','<a href="mailto:\\1">\\1</a>', $text);  
	return $text;
}


function wrapText ($String, $breakPoint) {
   $newString="";
   $lines=explode("\n", $String);
   $count=count($lines);
   for($i=0;$i<$count;$i++){
     if(strlen($lines[$i])>$breakPoint){
       $str=$lines[$i];
       while(strlen($str)>$breakPoint){
         $find = 1 ;         
         $pos=strrpos(substr($str, 0, $breakPoint+1), " ");
         if ($pos == false) {
             If(1) {
                 $pos = $breakPoint ;
                 $find = 0 ;
             } else {
                 $pos= strpos($str, " ");
                 if ($pos == false)
                     break;
             }
         }
         $newString.="".substr($str, 0, $pos)."\n";
         $str=(substr($str, $pos + $find));

       }
       $newString.=$padStr.$str."\n";
     }
     else{
       $newString.=$padStr.$lines[$i]."\n";
     }
   }

   return substr ($newString,0, -1);
}

function array_search_r($needle, $haystack){
	while (list(, $val) = each ($haystack)) { 	
           if(is_array($val))
               $match=array_search_r($needle, $val);
           if($value==$needle)
               $match=1;
           if($match)
               return 1;
   }
   return 0;
}



if($heading != null && $heading != "") {
	$message = "<html><body><font face=\"".$headerFont."\" size=\"".$headerSize."\" color=\"".$headerColor."\">";
	$message .= $headerStyleOpen.$heading.$headerStyleClose."</font><br><font face=\"".$bodyFont."\" size=\"".$bodySize."\" color=\"".$bodyColor."\">";
} else {
	$message = "<html><body><font face=\"".$bodyFont."\" size=\"".$bodySize."\" color=\"".$bodyColor."\">";
}

$arrOrder = explode(",",$orderArray);

$finalArray = array();

$fullFields = explode("~|~",$varArray);


while (list(, $val) = each ($fullFields)) {   
	$divideFields = explode("*|*",$val);
	if($divideFields[1] != "undefined") {
		if($parseLinks) {
			$fieldValue = makeClickableLinks(stripslashes($divideFields[1]));
		} else {
			$fieldValue = stripslashes($divideFields[1]);
		}
		$finalArray[] = array($divideFields[0],$fieldValue);
	}	
}


for ($i = 0; $i < count($finalArray); $i++) {
	if(is_string($finalArray[$i][0])) {			
		$place = array_search_r ($finalArray[$i][0], $arrOrder);			
		if(!$place) {				
			if($finalArray[$i][0] == $arrOrder[0]) {
				$arrOrder[0] = $finalArray[$i];
			} else {
				$arrOrder[] = $finalArray[$i];				
			}
		} else {
			$arrOrder[$place] = $finalArray[$i];
		}
	}
}



//////////////////
for ($a = 0; $a < count($arrOrder); $a++) {
	if( !is_array( $arrOrder[$a] ) ){
		$finalArray = array();
		$finalArray[0] = $arrOrder[$a];
		$finalArray[1] = " ";
		$arrOrder[$a] = $finalArray;
	}
}
//////////////////

for ($i = 0; $i < count($arrOrder); $i++) {
	for($b = 0; $b < $lineSpacing; $b++) {
		$message .= "<br>";	
	}
	
	$varValue = $arrOrder[$i][1];	
	$varValue = str_replace("\r", "<br>", $varValue);
	
	if($layout == "style2") {
	$message .= "<font face=\"".$titleFont."\" size=\"".$titleSize."\" color=\"".$titleColor."\">".$titleStyleOpen.$arrOrder[$i][0].":".$titleStyleClose."</font><br>".$bodyStyleOpen.$varValue.$bodyStyleClose."<br>";
	}
	else if($layout == "style3") {
	$message .= "<font face=\"".$titleFont."\"size=\"".$titleSize."\"color=\"".$titleColor."\">".$titleStyleOpen.$arrOrder[$i][0].":".$titleStyleClose."</font><br><br>".$bodyStyleOpen.$varValue.$bodyStyleClose."<br>";
	}
	else {	
	$message .= "<font face=\"".$titleFont."\" size=\"".$titleSize."\" color=\"".$titleColor."\">".$titleStyleOpen.$arrOrder[$i][0].":".$titleStyleClose."</font>&nbsp;".$bodyStyleOpen.$varValue.$bodyStyleClose;
	}	
}

$message .= "</font></body></html>";

$message = wrapText($message, 72);

$headers = "From: ".$fromName." <".$fromEmail.">\n"; 
$headers .= "Reply-To: ".$fromName." <".$fromEmail.">\n"; 
$headers .= "Return-Path: ".$fromName." <".$fromEmail.">\n";

$success = mail($recipientEmail, $Subject, $message, $headers."MIME-Version: 1.0\n"."Content-type: text/html; charset=iso-8859-1");

if($success) {
	$emailsent = "sent";
} else {
	$emailsent = "notsent";
}
print "&submittedVar=".$emailsent;

?>


