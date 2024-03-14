<?php

if ( empty($_REQUEST['containerIP']) ) {
    echo '沒有傳值';
}
else {
    $containerIP = str_replace("'", "''", $_REQUEST['containerIP']);
    $stopStream = shell_exec("sudo podman stop stream_$containerIP");
    $stopNginx = shell_exec("sudo /bin/sh /home/stream/script/del_stream.sh $containerIP");
    echo $stopStream;
    echo $stopNginx;
}

?>
