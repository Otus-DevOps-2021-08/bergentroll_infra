[app]
%{ for host, ip in app_hosts ~}
${host} ansible_host=${ip}
%{ endfor ~}

[db]
%{ for host, ip in db_hosts ~}
${host} ansible_host=${ip}
%{ endfor ~}
