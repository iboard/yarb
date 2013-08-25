#!/bin/bash

cd $HOME/apps/yarb

echo "UPDATE AND RESTART yarb ON EDGE.IBOARD.CC"
rvm use `cat .ruby-gemset`
git pull
if [ $? == "0" ]
then
  rake assets:precompile
  . bin/thin_restart.sh
fi
echo "DONE $0"
exit
