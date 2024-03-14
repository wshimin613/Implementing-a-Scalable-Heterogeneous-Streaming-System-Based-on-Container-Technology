<?php

require('config.php');

if ( empty($_REQUEST['camName']) || empty($_REQUEST['camIP']) || empty($_REQUEST['containerIP']) ) {
    echo '請檢查欄位是否填寫完畢！';
}
else {
    $conn = new mysqli($servername, $user, $pwd, $db);
        
    if ($conn->connect_error) {
        die("連接失敗: " . $conn->connect_error);
    }
    else {
        $camName = str_replace("'", "''", $_REQUEST['camName']);
        $camIP = str_replace("'","''",$_REQUEST['camIP']);
        $containerIP = str_replace("'","''",$_REQUEST['containerIP']);

        $state = shell_exec("sudo /bin/sh /home/stream/script/camera_state.sh $camIP");

        if ( $state == '0' ) {
            $sql = "insert into camera (name,ip,container_ip,status,action) values(TRIM('${camName}'),TRIM('${camIP}'),TRIM('${containerIP}'),'normal','idle');";
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
}

?>