<?php

include "../connect.php";

$email=filterRequest('email');

$password=filterRequest('password');

$stmt=$con->prepare("SELECT * FROM users WHERE `password` = ? AND email=? ");

$stmt ->execute(array($password,$email));

$count=$stmt->rowCount();

$data=$stmt->fetch(PDO::FETCH_ASSOC);

if($count>0)
{
   echo json_encode(array("status"=>"success","data"=>$data));
}else{
    echo json_encode(array("status"=>"fail"));
}
?>

