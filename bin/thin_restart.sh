#!/bin/bash
thin  -S tmp/sockets/thin.sock -e production -d -l log/thin.log -P tmp/pids/thin.pid --tag YARB -s 2 restart
