#!/bin/bash

SOURCE=/Users/aa/Sites/iboard
TARGET=aa@ib1.iboard.cc:/home/aa/public_html/

rsync -avre ssh --exclude=tmp --exclude=log --exclude=db/production.sqlite3 \
   --exclude=binary_data --exclude=public/.htaccess \
   --exclude="galleries/" \
   --exclude=".git/" \
   --exclude="db/*sqlite3" \
   --exclude="config/boot.rb" \
   --exclude="gallery_cache/" \
   --exclude=public/dispatch* --exclude=config/environment.rb $SOURCE $TARGET

rsync -avre ssh $SOURCE/app $TARGET/iboard/
