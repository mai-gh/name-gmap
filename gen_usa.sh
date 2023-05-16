#!/bin/bash

set -uex

# To Generate the areas array:
# go to https://download.geofabrik.de/north-america/us.html
# Array.from(document.querySelectorAll('.leftColumn > table:nth-child(11) > tbody:nth-child(1) > tr > td > a')).filter(x => x.href.match(/pbf$/)).map(x=>x.href.split('/').slice(-1)[0].split('-latest')[0]).join(" ")

areas=(alabama alaska arizona arkansas california colorado connecticut delaware district-of-columbia florida georgia hawaii idaho illinois indiana iowa kansas kentucky louisiana maine maryland massachusetts michigan minnesota mississippi missouri montana nebraska nevada new-hampshire new-jersey new-mexico new-york north-carolina north-dakota ohio oklahoma oregon pennsylvania puerto-rico rhode-island south-carolina south-dakota tennessee texas us-virgin-islands utah vermont virginia washington west-virginia wisconsin wyoming)

[ ! -d out ] && mkdir out
[ ! -d work ] && mkdir work
[ ! -d work/pbf ] && mkdir work/pbf
OUT="$(realpath out)"
WRK="$(realpath work)"
PBF="$(realpath work/pbf)"
NGM="$(realpath name-gmap.py)"

for a in ${areas[@]}; do 
  [ -e "${OUT}/osm-us-${a}.img" ] && continue
  echo "STARTING: $a"; cd "$WRK"
  wget -c https://download.geofabrik.de/north-america/us/${a}-latest.osm.pbf -P "$PBF"
  [ ! -d $a ] && mkdir "$a"; cd "$a"
  mkgmap-splitter --keep-complete=true "${PBF}/${a}-latest.osm.pbf"
  mkgmap -c template.args --gmapsupp *.osm.pbf
  "$NGM" gmapsupp.img osm-us-${a}
  mv gmapsupp.img "${OUT}/osm-us-${a}.img"
done
