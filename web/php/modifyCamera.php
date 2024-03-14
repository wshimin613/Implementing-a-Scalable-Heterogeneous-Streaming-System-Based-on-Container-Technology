<?php

require('config.php');

$conn = new mysqli($servername, $user, $pwd, $db);    
if ($conn->connect_error) {
    die("資料庫連線失敗: " . $conn->connect_error);
}
else {
    $id = str_replace("'", "''", $_REQUEST['id']);
    $name = str_replace("'", "''", $_REQUEST['name']);
    $ip = str_replace("'", "''", $_REQUEST['ip']);
    $containerIP = str_replace("'", "''", $_REQUEST['containerIP']);

    $state = shell_exec("sudo /bin/sh /home/stream/script/camera_state.sh $ip");

    if ($state == '0' ) {
        $sql = "update camera set name=TRIM('$name'), ip=TRIM('$ip'), container_ip=TRIM('$containerIP') where id='$id';";
        $result = $conn->query("$sql");
            
        if ($result) {
            echo 'success';
        } 
        else {
            echo 'Error: ' . $conn->error;
        }
    }
    else {
        echo '偵測不到此 IP 位址的攝影機';
    }
}

?>