const fs = require('fs');

var servers = require('./servers.json');
var new_servers = [];

const mysql_app = {
  "name": "Mysql server PORT 3306",
  "script": "_scripts/mysql.sh",
  "max_restarts": "1",
  "min_uptime": "2m"
};

const authserver_mysql =
{
  "name": "auth-server db mysql PORT 8000",
  "script": "_scripts/auth_mysql.sh",
  "cwd": "fxa-auth-db-mysql",
  "env": {
    "NODE_ENV": "dev"
  },
  "max_restarts": "2",
  "min_uptime": "2m"
};

new_servers.push(mysql_app);
new_servers.push(authserver_mysql);

for (var app of servers.apps) {
  if(app.script.indexOf('mem.js') === -1){
    if(app.cwd === 'fxa-oauth-server' || app.cwd === 'fxa-profile-server'){
      app.env.DB = 'mysql';
    }
    new_servers.push(app);
  }
}

servers = {
  "apps" : new_servers
}
fs.writeFileSync('mysql_servers.json', JSON.stringify(servers, null, 2));
