<?php

$streamState = shell_exec("sudo /bin/sh /home/stream/script/stream_state.sh");
$jsonData = shell_exec("sudo /bin/sh /home/stream/script/load_state.sh");
echo $jsonData;

?>
