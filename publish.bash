#!/bin/bash
rsync -aP --delete --stats \
  --exclude keep \
  --exclude tmp \
  --exclude laura \
  _site/ lovejoy.teeks99.com:teeks99.com/