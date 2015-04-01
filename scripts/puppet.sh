#!/bin/bash
puppet agent --onetime --no-splay --ignorecache --no-daemonize --verbose --show_diff --no-usecacheonfailure --debug
