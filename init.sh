#!/bin/bash

commands[1]="mu,migrations up,php"
commands[2]="cm,load dump and run migrations"
commands[4]="cu,composer update,php"
commands[5]="start,start environment(docker-compose up -d),start,php"
commands[6]="stop,stop containers,stop,php"
commands[7]="fr,first run - migrations up and load dump,php"
commands[8]="ca,delete all project containers and images. Be carefully!,php"
commands[9]="sa,stop all containers,php"
commands[10]="cr,remove all containers,php"
commands[11]="dc,Docker clean everything"
commands[12]="cd,Create images"
commands[15]="pgb,Run postgresql backups (daily_mode =  (12.00hh) => pg_dump',hourly_mode = (everyhour only main table with exclude table))"

options[0]="-h ,this help"
options[1]="--help,this help"
options[2]="-v,current version"
options[3]="--version,current version"

version=0.01

comand=$1
option=$1

array=''

start() {
    docker-compose up -d
    bi
    docker exec phalcon.compose.blog.php chmod -R 777 /var/www/phalcon
    # startAllListener
    sleep  10
    docker-compose ps
}

cu() {
	message "Install composer requirements"
    docker-compose exec php composer install
    docker-compose exec php chmod -R 777 /var/www/phalcon
}

stop() {
    docker-compose stop
    docker-compose ps
}

mu() {
    docker exec phalcon.compose.blog.php php app/migration/phinx migrate
}

cm()
{
    docker exec phalcon.compose.blog.postgres psql -U postgres -d postgres -f app/migration/dump/init_role_locale.sql
    docker exec phalcon.compose.blog.postgres psql -U postgres -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'blog'
  AND pid <> pg_backend_pid();"

    docker exec phalcon.compose.blog.postgres  psql -U root -d postgres -c "DROP DATABASE IF EXISTS blog"
    docker exec phalcon.compose.blog.postgres  psql -U root -d postgres -c "CREATE DATABASE blog"
    docker exec phalcon.compose.blog.postgres  pg_restore -d blog app/migration/dump/dump.dump
    docker exec phalcon.compose.blog.php  app/migration/phinx migrate

    docker exec phalcon.compose.blog.redis redis-cli flushall
}


ca() {
    #docker rm -f $(docker ps -a -q)
    docker ps -a | awk '{ print $1,$2 }' | grep $(name)_ | awk '{print $1 }' | xargs -I {} docker rm {}
    #docker rmi -f $(docker images -a -q)
    docker images | awk '{ print $1,$2 }' | grep $(name)_ | awk '{print $1 }' | xargs -I {} docker rmi {}
}

sa() {
    echo 'stop all containers'
    docker stop $(docker ps -a -q)
}

cr() {
    #docker rm $(docker ps -a -q)
    docker ps -a | awk '{ print $1,$2 }' | grep $(name)_ | awk '{print $1 }' | xargs -I {} docker rm {}
}

ir() {
    #docker rmi $(docker images -a -q)
    docker images | awk '{ print $1,$2 }' | grep $(name)_ | awk '{print $1 }' | xargs -I {} docker rmi {}
}

dc() {
    sa
    cr
    ir
    docker volume rm $(docker volume ls -qf dangling=true)
}

rdc() {
    #docker rm $(docker ps -a -q)
    docker ps -a | awk '{ print $1,$2 }' | grep $(name)_postgres_1 | awk '{print $1 }' | xargs -I {} docker rm {}
}

cd() {
     echo 'Db creating started!! Waiting!'
    docker exec phalcon.compose.blog.postgres pg_dump -Fc dev_soscredit > app/migration/dump/dump.dump
}

fr(){
    start
    ci
    ld
    mu
}

get_options () {
        for index in "${!options[@]}"
        do
            IFS='_' read -r -a array <<< "${options[index]}"
            size=${#array[0]}
            local test=" "
            for (( c=1; c<=10-$size; c++ ))
            do
                test=${test}" "
            done
            echo '       '${array[0]}"$test"${array[1]}
        done
}

get_commands () {
        for index in "${!commands[@]}"
        do
            IFS=',' read -r -a array <<< "${commands[index]}"
            size=${#array[0]}
            local test=" "
            for (( c=1; c<=10-$size; c++ ))
            do
                test=${test}" "
            done
            echo '       '${array[0]}"$test"${array[1]}
        done
}

name () {

        IFS=', /' read -r -a array <<< "$PWD"
        for index in "${!array[@]}"
        do
            i=$index
        done
        IFS='-_' read -r -a array <<< "${array[index]}"
        for index in "${!array[@]}"
        do
            str="$str${array[index]}"
        done
        echo $str
}

run_commands () {
        for index in "${!commands[@]}"
        do
            IFS=',' read -r -a array <<< "${commands[index]}"
                if [ ${array[0]}"" == $comand ]; then
                    $comand
                    exit 0;
                fi
        done
}

run_options () {
        for index in "${!options[@]}"
        do
            IFS=',' read -r -a array <<< "${options[index]}"
                if [ ${array[0]}"" == $option ]; then
                    echo "options: "${array[0]}" "${array[1]}
                    exit 1;
                fi
        done
}

name=$1
log_file="Logone.txt"

if [[ -n "$name" ]]; then

         #echo   $(name)$(run_commands)
        run_commands

        for index in "${!array[@]}"
        do
            i=$index
        done


    case $1 in
    php)
       # echo enter into php container

       #exec docker exec $(name) echo hello

       ;;
    esac

else

t="$(cat <<-EOF
Usage: Blog [OPTIONS] COMMAND [arg...]

       Blog [ --help | -v | --version ]

Help script for Blog project.

Options:

EOF
)"


b="$(cat <<-EOF

Run 'Blog COMMAND --help' for more information on a command.
EOF
)"

echo "$t"
               # if [ ${array[0]}"" == $option ]; then
               #     echo "options: "${array[0]}" "${array[1]}
               #     exit 1;
               # fi
get_options
echo "Commands:"
get_commands
echo "$b"

fi
