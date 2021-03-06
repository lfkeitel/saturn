#!/bin/bash
#gen:module o redis_version:string,connected_clients:string,connected_slaves:string,used_memory_human:string,total_connections_received:string,total_commands_processed:string

########### Enter Your Redis Password  HERE #########
redisPassword=$REDIS_PASSWORD
########### Enter Your Redis Password  HERE #########

redisCommand=$(which redis-cli)

if [ -z $redisCommand ]; then
    echo -n "{}"
    exit
fi

if [ -n "$redisPassword" ]; then
    redisCommand="$redisCommand -a $redisPassword"
fi

result=$($redisCommand INFO \
    | grep 'redis_version\|connected_clients\|connected_slaves\|used_memory_human\|total_connections_received\|total_commands_processed' \
    | awk -F: '{print "\"" $1 "\":" "\"" $2 }' \
    | tr '\r' '"' | tr '\n' ','
    )

echo -n { ${result%?} }
