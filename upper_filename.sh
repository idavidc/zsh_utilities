for i in *.mp4; do j=$(tr '[:lower:]' '[:upper:]' <<< "$i") ; mv "$i" "$j" ; done
