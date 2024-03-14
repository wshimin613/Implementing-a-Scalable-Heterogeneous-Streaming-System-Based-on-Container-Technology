window.onload = init;

setInterval(init, 60000);
function init() {
  const tbody = document.getElementById("table-body");
  const uniqueId = Date.now();

  while (tbody.firstChild) {
    tbody.removeChild(tbody.firstChild);
  }

  axios.get(`./php/init.php`).then((res) => {
    const { data } = res;
    for (let i = 0; i < data.length; i++) {
      const newRow = document.createElement("tr");

      newRow.id = `row${uniqueId}`;
      newRow.innerHTML = `
          <td class="col-3">
              <div class="input-group input-group-sm mb-1">
                  <input type="text" class="form-control" value="${data[i].streamName}" disabled/>
              </div>
          </td>
          <td class="col-3">
              <div class="input-group input-group-sm mb-1">
                  <select class="form-select" disabled>
                    <option>${data[i].cameraName}</option>
                  </select>
              </div>
          </td>
          <td class="col-3">${data[i].action}</td>
          <td class="col-3">
            <button type="button" class="btn btn-outline-primary" onclick="showStream()">顯示畫面</button>
            <button type="button" id="delButton${data[i].container_ip}" class="btn btn-outline-danger" onclick="delStream(${data[i].container_ip})">結束串流</button>
          </td>
      `;
      tbody.appendChild(newRow);
    }
  });
}
