function startStream(id) {
  const name = document.getElementById("streamName" + id).value;
  const cam = document.getElementById("streamCam" + id).value;

  if (
    name !== null &&
    name !== undefined &&
    name !== "" &&
    cam !== null &&
    cam !== undefined &&
    cam !== ""
  ) {
    progress("start", id);
    axios
      .get(`php/index.php?state=start&name=${name}&cam=${cam}`)
      .then((res) => {
        const { data } = res;
        console.log(data);
        init();
      });
  } else {
    alert("請填寫完整，欄位為必填");
  }
}

function delStream(containerIP) {
  progress("end", containerIP);
  axios.get(`./php/delStream.php?containerIP=${containerIP}`).then((res) => {
    const { data } = res;
    console.log(data);
    init();
  });
}

function progress(state, id) {
  let buttonId;
  if (state == "start") {
    buttonId = "startButton";
  } else if (state == "end") {
    buttonId = "delButton";
  } else if (state == "add") {
    buttonId = "addButton";
  } else if (state == "modify") {
    buttonId = "modifyButton";
  } else if (state == "restore") {
    buttonId = "restoreButton";
  } else {
    buttonId = null;
  }

  const button = document.getElementById(`${buttonId}${id}`);
  button.innerHTML = `<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...`;
  button.disabled = true;
}

function showStream() {
  window.location.href = "live.html";
}

function restoreStream(streamName, containerIP) {
  progress("restore", containerIP);
  axios
    .get(
      `./php/restoreStream.php?streamName=${streamName}&containerIP=${containerIP}`
    )
    .then((res) => {
      const { data } = res;
      console.log(data);
      init();
    });
}
