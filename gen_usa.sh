#!/bin/bash

set -uex

areas=(alabama alaska arizona arkansas california colorado connecticut delaware district-of-columbia florida georgia hawaii idaho illinois indiana iowa kansas kentucky louisiana maine maryland massachusetts michigan minnesota mississippi missouri montana nebraska nevada new-hampshire new-jersey new-mexico new-york north-carolina north-dakota ohio oklahoma oregon pennsylvania puerto-rico rhode-island south-carolina south-dakota tennessee texas us-virgin-islands utah vermont virginia washington west-virginia wisconsin wyoming)


mkdir out
mkdir work
cd work

for a in ${areas[@]}; do 
  echo STARTING: $a
  wget https://download.geofabrik.de/north-america/us/${a}-latest.osm.pbf
  mkdir $a
  cd $a
  mkgmap-splitter --keep-complete=true ../${a}-latest.osm.pbf
  mkgmap -c template.args --gmapsupp *.osm.pbf
  ../../name-gmap.py gmapsupp.img osm-us-${a}
  mv gmapsupp.img ../out/osm-us-${a}.img
  cd ..
done
