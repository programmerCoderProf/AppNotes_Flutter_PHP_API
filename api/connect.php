<?php

$dsn="mysql:host=localhost;dbname=noteapp;";
$user="root";
$password="";
$potion=array(
PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES UTF8" //for arabic lang
);

try{
    $con= new PDO($dsn,$user,$password,$potion);
    $con->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
    include "functions.php";
    checkAuthenticate();
    
}catch(PDOException $e)
{
    echo $e->getMessage();
}


?>