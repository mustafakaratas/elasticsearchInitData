#!/bin/sh

function initData()
{
    echo Initiating Elasticsearch Custom Index

    until $(curl -sSf -XGET --insecure --user elastic:changeme "http://localhost:9200/_cluster/health?wait_for_status=yellow" > /dev/null); do
        echo 'Waiting elasticsearch status, trying again in 5 seconds...'
        sleep 5
    done

    curl -H "Content-Type: application/json" -XPUT -d @/utils/settings.json http://localhost:9200/my-index

    curl -s -H "Content-Type: application/x-ndjson" -XPOST "http://localhost:9200/_bulk" --data-binary "@/utils/index.json"

    exit
}

initData & exec /usr/share/elasticsearch/bin/elasticsearch