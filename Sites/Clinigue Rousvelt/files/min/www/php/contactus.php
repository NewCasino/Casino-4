<?
// edit these 3 items
$sendTo  =  "najette@derni.com"; // your email - should be the same as the server domain otherwise the mail might not send (some servers restrict the use of the mail() command to avoid any risk of spam)

$subjectPre = "Contact Clinique Roosevelt"; // a 'prefix' for the subject
$msg = "La Clinique Roosevelt vous remercie de votre message. S'il requiert une reponse, nous vous donnerons suite dans les plus brefs delais"; // your thank you message


// No need to edit this
$subject = $_POST["subject"];
$headers = "De: " . $_POST["name"];
$headers .= "<" . $_POST["email"] . ">\r\n";
$headers .= "Reply-To: " . $_POST["email"] . "\r\n";
$headers .= "Return-Path: " . $_POST["email"];
$message = $_POST["message"];

$mailSent = mail($sendTo, $subject, $message, $headers); 

echo "&returnMessage=$msg"; 
?>