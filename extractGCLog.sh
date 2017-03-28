#!/bin/bash
yum install pcre-tools.x86_64 -y
pcregrep -M '[0-9]+\.[0-9]{3}:(.|\n)*secs\]' $1
