async function fetchData() {
  let arr = [];

  try {
    let res = await axios.get(`./php/loadCamera.php`);
    const { data } = res;
    for (let i = 0; i < data.length; i++) {
      arr.push(data[i].name);
    }
    return arr;
  } catch (error) {
    console.error("Error fetching data: ", error);
  }
}

function add_row() {
  const tbody = document.getElementById("table-body");
  const newRow = document.createElement("tr");
  const uniqueId = Date.now();

  fetchData().then((data) => {
    for (let i = 0; i < data.length; i++) {
      let option = document.createElement("option");
      option.value = data[i];
      option.text = data[i];
      document.getElementById("streamCam" + uniqueId).appendChild(option);
    }
  });

  newRow.id = `row${uniqueId}`;
  newRow.innerHTML = `
        <td class="col-3">
            <div class="input-group input-group-sm mb-1">
                <input type="text" class="form-control" placeholder="請輸入串流名稱" maxlength="10" id="streamName${uniqueId}" required/>
            </div>
        </td>
        <td class="col-3">
            <div class="input-group input-group-sm mb-1">
                <select class="form-select" id="streamCam${uniqueId}" required>
                  <option selected disabled value="">Choose...</option>
                </select>
            </div>
        </td>
        <td class="col-3"></td>
        <td class="col-3">
          <button type="button" id="startButton${uniqueId}" class="btn btn-outline-primary" onclick="startStream(${uniqueId})">開始串流</button>
          <button type="button" class="btn btn-outline-danger" onclick="del_row(${uniqueId})">刪除</button>
        </td>
    `;
  tbody.appendChild(newRow);

  // 排除重複的攝影機
  axios.get(`./php/init.php`).then((res) => {
    const { data } = res;
    for (let i = 0; i < data.length; i++) {
      const optionToRemove = newRow.querySelector(
        `option[value="${data[i].cameraName}"]`
      );
      if (optionToRemove) {
        optionToRemove.remove();
      }
    }
  });
}

function del_row(uniqueId) {
  const delRow = document.getElementById("row" + uniqueId);
  delRow.remove();
}
