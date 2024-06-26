setInterval(loadCamera, 60000);
function loadCamera() {
  const table = document.getElementById("table-camera");

  while (table.firstChild) {
    table.removeChild(table.firstChild);
  }

  axios.get(`./php/loadCamera.php`).then((res) => {
    const { data } = res;

    for (let i = 0; i < data.length; i++) {
      const newRow = document.createElement("tr");

      let spinnerElement;
      switch (data[i].status) {
        case "normal":
          spinnerElement =
            '<div class="spinner-grow spinner-grow-sm text-success" role="status"></div>';
          break;
        case "error":
          spinnerElement =
            '<div class="spinner-grow spinner-grow-sm text-danger" role="status"></div>';
          break;
        default:
          spinnerElement = "";
          break;
      }

      newRow.id = "row" + data[i].id;
      newRow.innerHTML = `
        <td id="delcamName${data[i].id}" class="col">${data[i].name}</td>
        <td class="col">${data[i].ip}</td>
        <td class="col">192.168.3.${data[i].container_ip}</td>
        <td class="col">
          ${spinnerElement} ${data[i].status}
        </td>
        <td class="col">${data[i].action}</td>
        <td class="col">
          <button type="button" class="btn btn-outline-primary" onclick="show(${data[i].id})" data-bs-toggle="modal" data-bs-target="#modifyModal">修改</button>
          <button type="button" class="btn btn-outline-danger" onclick="delcamName(${data[i].id})" data-bs-toggle="modal" data-bs-target="#delModal">刪除</button>
        </td>
        `;
      table.appendChild(newRow);
    }
  });
}

function addCamera() {
  const camName = document.getElementById("camName").value;
  const camIP = camIPDiv.getIp();
  const containerIP = parseInt(document.getElementById("containerIP").value);
  const nullValueDiv = document.getElementById("nullValueDiv");
  const addButton1 = document.getElementById("addButton1");

  if (camIP !== undefined) {
    progress("add", 1);
    axios
      .get(
        `./php/addCamera.php?camName=${camName}&camIP=${camIP}&containerIP=${containerIP}`
      )
      .then((res) => {
        const { data } = res;
        if (data == "success") {
          $("#addModal").modal("hide");
          loadCamera();
        } else {
          nullValueDiv.classList.add("alert", "alert-danger");
          nullValueDiv.textContent = data;
        }
        addButton1.innerHTML = "新增";
        addButton1.disabled = false;
      });
  } else {
    nullValueDiv.classList.add("alert", "alert-danger");
    nullValueDiv.textContent = "請輸入正確的 IP 位址";
  }
}

function delcamName(rowId) {
  currentCameraId = rowId;
  const delcamName = document.getElementById("delcamName" + rowId).textContent;
  document.getElementById("modal-delCam").textContent =
    "確定要刪除 " + delcamName + " 這台攝影機嗎？";
}

function delCamera() {
  axios.get(`./php/delCamera.php?id=${currentCameraId}`).then((res) => {
    const { data } = res;
    if (data == "success") {
      $("#delModal").modal("hide");
      loadCamera();
    } else {
      console.log(data);
    }
  });
}

// 點擊修改按鈕後，自動填入舊資料
let currentCameraId = null;
function show(rowId) {
  currentCameraId = rowId;
  const camName = document.getElementById("modifycamName");
  const containerIP = document.getElementById("modifycontainerIP");

  axios.get(`./php/showCamera.php?id=${rowId}`).then((res) => {
    const { data } = res;
    camName.value = data.name;
    modifycamIPDiv.setIp(data.ip);
    containerIP.value = data.container_ip;
  });
}

function modifyCamera() {
  const camName = document.getElementById("modifycamName").value;
  const camIP = modifycamIPDiv.getIp();
  const containerIP = document.getElementById("modifycontainerIP").value;
  const nullValueDiv = document.getElementById("nullValueDiv2");
  const modifyButton1 = document.getElementById("modifyButton1");

  if (camIP !== undefined) {
    progress("modify", 1);
    axios
      .get(
        `./php/modifyCamera.php?id=${currentCameraId}&name=${camName}&ip=${camIP}&containerIP=${containerIP}`
      )
      .then((res) => {
        const { data } = res;
        if (data == "success") {
          $("#modifyModal").modal("hide");
          loadCamera();
        } else {
          nullValueDiv.classList.add("alert", "alert-danger");
          nullValueDiv.textContent = data;
        }
        modifyButton1.innerHTML = "修改";
        modifyButton1.disabled = false;
      });
  } else {
    nullValueDiv.classList.add("alert", "alert-danger");
    nullValueDiv.textContent = "請輸入正確的 IP 位址";
  }
}