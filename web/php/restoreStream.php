<?php

require('config.php');

$conn = new mysqli($servername, $user, $pwd, $db);    
if ($conn->connect_error) {
    die("資料庫連線失敗: " . $conn->connect_error);
}
else {
    if ( empty($_REQUEST['streamName']) || empty($_REQUEST['containerIP']) ) {
        echo '由 restoreStream.php 發出錯誤訊息，有傳遞值為空';
    }
    else {
        $streamName = str_replace("'", "''", $_REQUEST['streamName']);
        $containerIP = str_replace("'", "''", $_REQUEST['containerIP']);
        $sql = "select ip from camera where stream_name='$streamName';";
        $result = $conn->query("$sql");
        $arr = $result-> fetch_assoc();
        $ip = $arr['ip'];
        $restore = shell_exec("sudo /bin/sh /home/stream/script/main.sh $streamName $ip $containerIP");
        echo $restore;
    }
}

?>