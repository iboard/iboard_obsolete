#!/bin/bash

SOURCE=/Users/aa/Sites/iboard.wwedu.com
TARGET=root@www.intern.wwedu.com:/Data01/Groups/Developer/Sites/

rsync -auvre ssh --exclude=tmp --exclude=log --exclude=db/production.sqlite3 \
   --exclude=binary_data --exclude=public/.htaccess \
   --exclude="galleries/" \
   --exclude="gallery_cache/" \
   --exclude=public/dispatch* --exclude=config/environment.rb $SOURCE $TARGET

rsync -avure ssh $SOURCE/app $TARGET/iboard.wwedu.com/
