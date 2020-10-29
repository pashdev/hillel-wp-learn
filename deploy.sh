#!/usr/bin/env bash

# Получаем из файлов json нужные переменые
Vars(){
    sitename=$(jq -r '.sitename' <<<"$1")
    siteroot_dir=$(jq -r '.siteroot_dir' <<<"$1")
    port=$(jq -r '.port' <<<"$1")
    siteaddmin=$(jq -r '.siteadmin' <<<"$1")
    #db
    username=$(jq -r '.db.username' <<<"$1")
    password=$(jq -r '.db.password' <<<"$1")
    name=$(jq -r '.db.name' <<<"$1")
}

Config_bkp(){
    count=$(jq -r '.bakup.count' <<<"$1")
    echo -e "backup conts\\t: $count"
    n=$(jq '.bakup.time|length' <<<"$1")
    # Считываем из масива время выполнения заданий в cron (30 4 * * *)
    for (( i=0; i<n; i++ ));do
        crontime=$(jq -r ".bakup.time[$i]" <<<"$1")
        echo -e "cron time\\t: $crontime"
    done
}
Write_vars(){
    echo -e "sitename\\t: $sitename"
    echo -e "siteroot_dir\\t: $siteroot_dir"
    echo -e "port\\t\\t: $port"
    echo -e "siteaddmin\\t: $siteaddmin"
    echo -e "username\\t: $username"
    echo -e "password\\t: $password"
    echo -e "name\\t\\t: $name"
}

# Считываем эл-ты масива и для каждого запускаем установку
Read_file(){
    while read -r LINE; do
        echo -e "\\t--==start of cycle==--"
        Vars "$LINE"
#        Config_wp
#        Config_mysql
#        Config_apache
        # Temp function for write vars
        Write_vars

        Config_bkp "$LINE"
        echo -e "\\t--==end of circle==--\\n"
    done < <(jq -c .[] < "$1")
}


# Проверяем возможность прочитать файл

jfile="./config.json"
if [[ -r "$jfile" ]]; then
    Read_file "$jfile"
else
    echo "The file does not exist or cannot be read"
fi

exit
#-----=====-----=====-----=====-----=====-----=====-----=====-----=====-----=====
