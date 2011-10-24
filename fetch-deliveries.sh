#!/bin/sh

source test.config

COOKIES="temp.cookies"
USER_AGENT="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)"

function fetch_url() {
  wget --cookies=on --keep-session-cookies --load-cookies="$COOKIES" \
    --save-cookies="$COOKIES" --user-agent="$USER_AGENT" --quiet \
    -O "$2" "$1"
}

function fetch_url_with_post() {
  wget --cookies=on --keep-session-cookies --load-cookies="$COOKIES" \
    --save-cookies="$COOKIES" --user-agent="$USER_AGENT" --quiet \
    -O "$2" --post-data "$3" "$1"
}

#############

rm -f "$COOKIES" login.html captcha.jpg logged_in.html

## Get the session cookie
fetch_url 'https://www.packstation.de/registration/login!input.action' login.html
login_url="`grep '<form' login.html|cut -d\\\" -f28`"

## Get the captcha and let the user solve it
fetch_url 'https://www.packstation.de/registration/captcha/random.captcha' captcha.jpg
open captcha.jpg
echo "Please input captcha: "
read captcha

## Login and retrieve the shipment-list
fetch_url_with_post "https://www.packstation.de$login_url" logged_in.html \
	"j_username=$USERNAME&j_password=$PASSWORD&captcha=$captcha"
./shipments.py

rm -f "$COOKIES" login.html captcha.jpg logged_in.html
