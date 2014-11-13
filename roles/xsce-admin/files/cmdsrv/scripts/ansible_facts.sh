#!/bin/sh

ansible localhost -m setup  --tree /tmp/facts >/dev/null