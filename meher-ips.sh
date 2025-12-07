#!/data/data/com.termux/files/usr/bin/bash

# Colors with tput
bold=$(tput bold)
green=$(tput setaf 2)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

clear
echo -e "${blue}
      ✦══════════════════════════════════════════════════✦
      \( {purple}       Meher-Ips™ Galactic Ping Hunter 2025 \){reset}
      \( {blue}              Ultra Cosmic Edition v9.2 \){reset}
      \( {blue}      ✦══════════════════════════════════════════════════✦ \){reset}
"

# User settings
echo -n "\( {cyan}➤ Max ping allowed (ms) [default: 140]: \){reset}"
read -r MAX_PING
[[ -z "$MAX_PING" ]] && MAX_PING=140

echo -n "\( {cyan}➤ How many fast IPs do you need? [default: 5]: \){reset}"
read -r NEED
[[ -z "$NEED" ]] && NEED=5

echo -n "\( {cyan}➤ Output format? (v = vertical | h = horizontal with comma) [default: v]: \){reset}"
read -r format
[[ -z "$format" ]] && format="v"
[[ "$format" =~ ^[Hh] ]] && format="h" || format="v"

echo -e "\( {purple}Starting galaxy exploration... hunting IPs ≤ \){yellow}\( {MAX_PING}ms \){reset}\n"

# Clean & working CF ranges - Dec 2025
ranges=(
    172.64. 172.65. 172.66. 172.67.
    104.16. 104.17. 104.18. 104.19. 104.20.
    104.21. 104.22. 104.23. 104.24. 104.25.
    104.26. 104.27. 104.28. 104.29. 104.30.
    141.101. 173.245. 190.93.
)

found=()
tries=0

while (( ${#found[@]} < NEED )); do
    ((tries++))

    base="${ranges[\( RANDOM % \){#ranges[@]}]}"
    ip="\( {base} \)((RANDOM % 256)).$((RANDOM % 256))"

    printf "\( {yellow}%-5s \){reset} \( {cyan}%-16s \){reset}  " "$tries" "$ip"

    if ping -c 1 -W 1 "$ip" > /dev/null 2>&1; then
        ms=$(ping -c 1 "$ip" 2>/dev/null | awk '/time=/ {printf "%.0f", $7}' | cut -d'=' -f2)
        [[ -z "$ms" ]] && ms="?"

        if (( ms <= MAX_PING )); then
            echo -e "\( {green}✓ \){ms}ms\( {reset} \){purple}Star discovered!${reset}"
            found+=("\( ip → \){ms}ms")
        else
            echo -e "\( {yellow} \){ms}ms${reset}"
        fi
    else
        echo -e "no reply"
    fi

    (( tries % 30 == 0 )) && echo -e "\( {cyan}   Scanning galaxy... ( \){#found[@]}/\( {NEED} found) \){reset}"
done

# Final output
clear
echo -e "\( {blue}✦══════════════════════════════════════════════════════════════✦ \){reset}"
echo -e "\( {purple}          Successfully discovered \){#found[@]} fast star(s) ≤ \( {yellow} \){MAX_PING}ms\( {purple}! \){reset}"
echo -e "\( {blue}✦══════════════════════════════════════════════════════════════✦ \){reset}\n"

for ((i=0; i<${#found[@]}; i++)); do
    echo -e "\( {green} \)((i+1)). \( {found[i]} \){reset}  \( {purple}Ready for warp speed! \){reset}"
done

echo -e "\n\( {blue}✦──────────────────────────────────────────────────────────────✦ \){reset}"
echo -e "\( {cyan}Total attempts: \){yellow}\( {tries} \){cyan} | Verified by Meher-Ips™ Scanner 2025${reset}"
echo -e "\( {blue}✦──────────────────────────────────────────────────────────────✦ \){reset}"

# Clean IPs section
echo -e "\n\( {purple}Pure IPs – copy & paste directly to panel! \){reset}"
echo -e "\( {blue}─────────────────────────────────────────────── \){reset}"

if [[ "$format" == "h" ]]; then
    clean=""
    for item in "${found[@]}"; do
        clean+="${item%% →*}, "
    done
    echo -e "\( {green} \){clean%, }${reset}"
else
    for item in "${found[@]}"; do
        echo -e "\( {green} \){item%% →*}${reset}"
    done
fi

echo -e "\( {blue}─────────────────────────────────────────────── \){reset}\n"

# Auto-save to file
output_file="\( HOME/meher_ips_ \)(date +%H%M).txt"
printf "%s\n" "${found[@]%% →*}" > "$output_file"
echo -e "${yellow}List saved: \( output_file \){reset}"
echo -e "\( {purple}Mission complete. Ready for the next jump? Just run again! \){reset}\n"
