#!/bin/bash

SOURCE=/Users/aa/Sites/iboard
TARGET=/Users/aa/Sites/iboard.wwedu.com

rsync -avr --exclude=tmp --exclude=log --exclude=db/production.sqlite3 \
   --exclude=binary_data --exclude=public/.htaccess \
   --exclude="galleries/" \
   --exclude="config/" \
   --exclude="public/" \
   --exclude="script/" \
   --exclude="app/views/layouts/application.html.erb" \
   --exclude="app/views/layouts/_user_menu.html.erb" \
   --exclude="gallery_cache/" \
   --exclude=public/dispatch* --exclude=config/environment.rb $SOURCE/* $TARGET

rsync -avr \
   --exclude="app/views/layouts/application.html.erb" \
   --exclude="app/views/layouts/_user_menu.html.erb" \
   $SOURCE/app $TARGET


rsync -avr \
   $SOURCE/config/routes.rb $TARGET/config
