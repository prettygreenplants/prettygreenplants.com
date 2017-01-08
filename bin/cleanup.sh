#!/usr/bin/env bash

sudo -u prettygreenplants -H ./flow flow:cache:flush --force
sudo -u prettygreenplants -H ./flow database:setcharset
sudo -u prettygreenplants -H ./flow doctrine:migrate
sudo -u prettygreenplants -H ./flow resource:clean
sudo -u prettygreenplants -H ./flow resource:publish
sudo -u prettygreenplants -H ./flow media:clearthumbnails
sudo -u prettygreenplants -H ./flow media:renderthumbnails
sudo -u prettygreenplants -H ./flow node:repair
sudo -u prettygreenplants -H ./flow cache:warmup
