<?php

require('config.php');
$conn = new mysqli($servername, $user, $pwd, $db);

$state = str_replace("'","''",$_REQUEST['state']);
$cam = str_replace("'","''",$_REQUEST['cam']);
$name = str_replace("'","''",$_REQUEST['name']);

switch ($state) {
	case 'start':
        if ($conn->connect_error) {
            die("連接失敗: " . $conn->connect_error);
        }
        else {
            $sql = "select ip,container_ip from camera where name='$cam';";
            $result = $conn->query($sql);
    
            if ($result) {
                $arr = $result->fetch_row();
                $ip = $arr[0];
                $container_ip = $arr[1];
                startStreaming( $name, $ip, $container_ip );
            }
            else {
                echo 'Error: ' . $conn->error;
            }
        }
        break;
    case 'stop':
        stopStreaming();
        break;
    default:
        echo "Invalid state";
        break;
}

function startStreaming($name, $ip, $container_ip){
    $result = shell_exec("sudo /bin/sh /home/stream/script/main.sh $name $ip $container_ip");
    echo $result;
}

// function stopStreaming(){
//     echo 'stop';
// }



?>