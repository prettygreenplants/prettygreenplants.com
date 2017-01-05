#!/usr/bin/env bash

./flow flow:cache:flush -f
./flow database:setcharset
./flow doctrine:migrate
./flow resource:clean
./flow resource:publish
./flow media:clearthumbnails
./flow media:renderthumbnails
./flow node:repair
./flow cache:warmup

chown -R prettygreenplants:prettygreenplants /var/www/prettygreenplants
