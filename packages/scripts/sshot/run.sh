mode=""
silent=0
out=""

for ((i=0; i <= $#; i++)); do
  arg="${!i}"

  if [[ $arg == "--screen" ]]; then
    mode="screen"
  elif [[ $arg == "--area" ]]; then
    mode="area"
  elif [[ $arg == "-s" ]]; then
    silent=1
  elif [[ $arg == "-o" ]]; then
    fname_i=$((i+1))
    fname="${!fname_i}"

    if [[ -n $fname ]]; then
      if [[ -d $fname ]]; then
        out=$fname
      else
        echo "error: '-o' is not a directory path."
        exit 1
      fi
    else
      echo "error: '-o' missing output path (ex.: -o \$HOME/imgs)."
      exit 1
    fi
  fi
done

if [[ -z $mode ]]; then
  echo "missing mode. (either --screen or --area)"
  exit 1
fi

if [[ -z $out ]]; then
  out=$HOME
fi

filename="$out/$(date -Ins).png"

if [[ $mode == "screen" ]]; then
  grim "$filename"
elif [[ $mode == "area" ]]; then
  area=$(slurp)
  grim -g "$area" - | tee "$filename">/dev/null
fi

if [[ $silent == 0 ]]; then
  notify-send -t 3000 "Saved $mode capture to $filename."
fi
