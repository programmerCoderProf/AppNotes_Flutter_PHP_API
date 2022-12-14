<?php

include "../connect.php";

$noteid=filterRequest('id');
$imagename=filterRequest('imagename');
$stmt=$con->prepare("DELETE FROM notes WHERE notes_id =?");

$stmt->execute(array($noteid));

$count=$stmt->rowCount();

if($count>0)
{
   deleteFile("../upload",$imagename);
   echo json_encode(array("status"=>"success"));
   
}else{
    echo json_encode(array("status"=>"fail"));
}
?>

