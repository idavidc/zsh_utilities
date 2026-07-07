for i in *.mp4; do j=$(tr '[:upper:]' '[:lower:]' <<< "$i") ; mv "$i" "$j" ; done
