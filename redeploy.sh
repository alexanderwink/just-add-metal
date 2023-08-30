#!/bin/bash
stack="${PWD##*/}"
app="app"
replicas=1

function waitforhealth() {
  containerprefix="$stack-$1-"

  for ((n=0;n<60;n++))
  do
    healthcount=0
    for c in $(docker ps -q --filter="name=$containerprefix")
    do
      if [[ $(docker inspect --format='{{json .State.Health.Status}}' "$c") == "\"healthy\"" ]]
      then
        ((healthcount+=1))
        if [ "$healthcount" -eq $replicas ]
        then
          echo "All containers ($healthcount) are healthy"
          break 2
        fi
      fi
    done
    sleep 1s
  done
}

/usr/local/bin/docker-compose pull

/usr/local/bin/docker-compose up -d --scale $app=$((replicas*2)) --no-recreate $app 
waitforhealth "app"
/usr/local/bin/docker-compose up -d --scale $app=$replicas --timeout 30 --no-recreate $app 
echo "Rolling update complete"