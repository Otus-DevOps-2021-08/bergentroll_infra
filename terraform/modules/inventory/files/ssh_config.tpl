%{ for _, db_addr in db_hosts ~}
Host ${ db_addr }
  ProxyJump ubuntu@${ values(app_hosts)[0] }
%{ endfor ~}
