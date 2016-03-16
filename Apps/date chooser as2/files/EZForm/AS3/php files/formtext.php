<?php

//edit this line to include the email address of the form recipient between the quotation marks
//for example:  $formrecipient = "you@youremail.com";
$formrecipient = "";

$heading = $_POST["heading"];
$orderArray = $_POST["orderArray"];
$varArray = $_POST["varArray"];
$layout = $_POST["layout"];
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
$badStrings = array("content-type:",
                    "mime-version:",
                    "content-transfer-encoding:",
                    "bcc:",
                    "cc:");
foreach($_REQUEST as $k => $v){
   foreach($badStrings as $v2){
   		$vlower = strtolower($v);
		if(strpos($vlower, $v2) !== false){
	        echo"HTTP/1.0 403 Forbidden";
	        exit;
		}
	}
}

if($heading != null && $heading != "") {
	$message = $heading."\n";
} else {
	$message = "";
}

$orderArrayB = array();

if($orderArray != ""){
$arrOrder = explode(",",$orderArray);	
}
else
{
$arrOrder = array();
}

foreach ( $arrOrder as $val ) {	
	array_push($orderArrayB, $val); 	
}
$finalArray = array();


$fullFields = explode("~|~",$varArray);			
foreach ( $fullFields as $val ) {
	$divideFields = explode("*|*",$val);
	if($divideFields[1] != "undefined") {
		array_push($finalArray, array(stripslashes($divideFields[0]),stripslashes($divideFields[1])));
	}	
}


for ($i = 0; $i < count($finalArray); $i++) {
	if(is_string($finalArray[$i][0])) {			
		$place = array_search ($finalArray[$i][0], $arrOrder);			
		if(!$place) {				
			if($finalArray[$i][0] == $arrOrder[0]) {
				$arrOrder[0] = $finalArray[$i];
			} else {
				array_push($arrOrder, $finalArray[$i]);
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
	$varValue = $arrOrder[$i][1];	
	$varValue = str_replace("\r", "\n", $varValue);

	for($b = 0; $b < $lineSpacing; $b++) {
		$message .= "\n";
	}	
	if($layout == "style2") {
		$message .= $arrOrder[$i][0].":\n".$varValue;	
	}
	else if($layout == "style3") {
		$message .= $arrOrder[$i][0].":\n\n".$varValue;	
	}
	else {
		$message .= $arrOrder[$i][0].": ".$varValue;	
	}	
}

$fromName=stripslashes($fromName);
$fromEmail=stripslashes($fromEmail);

$headers = "From: ".$fromName." <".$fromEmail.">\n"; 
$headers .= "Reply-To: ".$fromName." <".$fromEmail.">\n"; 
$headers .= "Return-Path: ".$fromName." <".$fromEmail.">";

$success = mail($recipientEmail, $Subject, $message, $headers);

if($success) {
	$emailsent = "sent";
} else {
	$emailsent = "notsent";
}
print "submittedVar=".$emailsent;

?>


