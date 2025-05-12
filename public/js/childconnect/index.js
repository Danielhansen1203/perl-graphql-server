const nodes = window.nodes || [];
const edges = window.edges || [];

function updateChart() {
  const R = 250;
  const center = { x: 300, y: 300 };
  const svg = d3.select('#chart').html('').append('svg')
                .attr('width', 600)
                .attr('height', 600);

  const step = 2 * Math.PI / Math.max(nodes.length, 1);
  nodes.forEach((n, i) => {
    n.cx = center.x + R * Math.cos(i * step - Math.PI/2);
    n.cy = center.y + R * Math.sin(i * step - Math.PI/2);
  });

  edges.forEach(e => {
    const s = nodes.find(n => n.id === e.source);
    const t = nodes.find(n => n.id === e.target);
    if (s && t) {
      const midX = (s.cx + t.cx) / 2;
      const midY = (s.cy + t.cy) / 2;
      const dx = t.cx - s.cx;
      const dy = t.cy - s.cy;
      const len = Math.sqrt(dx*dx + dy*dy);
      const normX = -dy / len;
      const normY = dx / len;
      const curvature = 30;
      const cpX = midX + normX * curvature;
      const cpY = midY + normY * curvature;

      svg.append('path')
         .attr('d', `M${s.cx},${s.cy} Q${cpX},${cpY} ${t.cx},${t.cy}`)
         .attr('fill', 'none')
         .attr('stroke', s.color)
         .attr('stroke-width', 2);
    }
  });

  svg.selectAll('circle')
     .data(nodes)
     .join('circle')
     .attr('cx', d => d.cx)
     .attr('cy', d => d.cy)
     .attr('r', 20)
     .attr('fill', d => d.color)
     .attr('stroke', '#333');
}

function updateControls() {
  const container = document.getElementById('peopleList');
  container.innerHTML = '';
  const table = document.createElement('table');

  // Header row
  const headerRow = document.createElement('tr');
  headerRow.innerHTML = '<th></th>' + nodes.map(n => `<th>${n.name}</th>`).join('');
  table.appendChild(headerRow);

  // Data rows
  nodes.forEach(n => {
    const row = document.createElement('tr');
    row.innerHTML =
      `<th>${n.name} <input type="color" value="${n.color}" data-id="${n.id}"></th>` +
      nodes.map(m => `<td><input type="checkbox" data-source="${n.id}" data-target="${m.id}"></td>`).join('');
    table.appendChild(row);
  });

  container.appendChild(table);

  // Set checked state from edges
  table.querySelectorAll('input[type=checkbox]').forEach(box => {
    const { source, target } = box.dataset;
    box.checked = edges.some(e => e.source === source && e.target === target);
  });

  // Color picker events
  table.querySelectorAll('input[type=color]').forEach(input => {
    input.addEventListener('input', ev => {
      const node = nodes.find(n => n.id === ev.target.dataset.id);
      node.color = ev.target.value;
      updateChart();
    });
  });

  // Checkbox change events
  table.querySelectorAll('input[type=checkbox]').forEach(box => {
    box.addEventListener('change', ev => {
      const { source, target } = ev.target.dataset;
      if (ev.target.checked) {
        edges.push({ source, target });
      } else {
        const idx = edges.findIndex(e => e.source === source && e.target === target);
        if (idx > -1) edges.splice(idx, 1);
      }
      updateChart();
    });
  });
}

// Initialize UI on page load
window.addEventListener('load', () => {
  document.getElementById('addBtn').addEventListener('click', () => {
    const name = document.getElementById('newName').value.trim();
    if (!name) return;
    const id = Date.now().toString();
    nodes.push({ id, name, color: '#' + Math.floor(Math.random() * 16777215).toString(16) });
    updateControls();
    updateChart();
    document.getElementById('newName').value = '';
  });

  document.getElementById('saveBtn').addEventListener('click', () => {
    fetch('save', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ nodes, edges })
    })
    .then(res => res.json())
    .then(data => alert(data.status === 'ok' ? 'Gemt!' : 'Fejl ved gem'));
  });

  document.getElementById('delBtn').addEventListener('click', () => {
    fetch('del', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ nodes, edges })
    })
      .then(r => r.json())
      .then(d => alert(d.status === 'ok' ? 'Slettet!' : 'Fejl ved slet'));
  });

  updateControls();
  updateChart();
});