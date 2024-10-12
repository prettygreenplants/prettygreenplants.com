#!/usr/bin/env bash

sudo -Eu prettygreenplants -H ./flow flow:cache:flush --force
sudo -Eu prettygreenplants -H ./flow database:setcharset
sudo -Eu prettygreenplants -H ./flow doctrine:migrate
sudo -Eu prettygreenplants -H ./flow resource:clean
sudo -Eu prettygreenplants -H ./flow resource:publish
sudo -Eu prettygreenplants -H ./flow media:clearthumbnails
sudo -Eu prettygreenplants -H ./flow media:removeunused
sudo -Eu prettygreenplants -H ./flow media:renderthumbnails
sudo -Eu prettygreenplants -H ./flow node:repair
sudo -Eu prettygreenplants -H ./flow cache:warmup
