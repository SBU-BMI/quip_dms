#!/bin/bash
dms_container=$(docker run --name quip-dms --net=quip_nw --restart unless-stopped -itd \
	-v $IMAGES_DIR:/data/images \
	-v $DATABASE_DIR:/data/db \
	sbubmi/quip_dms:$VERSION)
echo "Started dms container: " $dms_container
