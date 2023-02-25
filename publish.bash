#!/bin/bash
sed 's/teeks99.github.io/teeks99.com/' _config.yml > _config_site_build.yml \
&& docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  jekyll/jekyll \
  jekyll build --destination _site_build --config _config_site_build.yml \
&& rsync -aP --delete --stats \
  --exclude keep \
  --exclude tmp \
  --exclude laura \
  --exclude multimedia-intro \
  _site_build/ lovejoy.teeks99.com:teeks99.com/
