document.getElementById('snmp-form').addEventListener('submit', async function (e) {
    e.preventDefault();
    const ip = document.getElementById('ip').value;
    const oid = document.getElementById('oid').value;

    const response = await fetch('/graphql', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        query: `query($ip: String!, $oid: String!) {
          GetSNMPInfo(ip: $ip, oid: $oid)
        }`,
        variables: { ip, oid }
      })
    });

    const data = await response.json();
    document.getElementById('output').textContent = JSON.stringify(data, null, 2);
  });