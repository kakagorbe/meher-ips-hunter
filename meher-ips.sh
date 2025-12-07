#!/data/data/com.termux/files/usr/bin/bash

# Colors
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
      \( {blue}               Ultra Cosmic Edition v9.5 \){reset}
      \( {blue}      ✦══════════════════════════════════════════════════✦ \){reset}
"

# Settings
echo -n "\( {cyan}Max ping allowed (ms) [default: 140]: \){reset}"
read -r MAX_PING
[[ -z "$MAX_PING" ]] && MAX_PING=140

echo -n "\( {cyan}How many fast IPs? [default: 5]: \){reset}"
read -r NEED
[[ -z "$NEED" ]] && NEED=5

echo -n "\( {cyan}Output format? (v=vertical h=horizontal) [default: v]: \){reset}"
read -r format
[[ "$format" =~ ^[Hh] ]] && format="h" || format="v"

echo -e "\( {purple}Scanning for IPs ≤ \){yellow}\( {MAX_PING}ms \){purple}...${reset}\n"

# CF ranges 2025
ranges=(172.64. 172.65. 172.66. 172.67. 104.16. 104.17. 104.18. 104.19. 104.20. 104.21. 104.22. 104.23. 104.24. 104.25. 104.26. 104.27. 104.28. 104.29. 104.30. 141.101. 173.245. 190.93.)

found=()
tries=0

while (( ${#found[@]} < NEED )); do
    ((tries++))
    ip="\( {ranges[RANDOM% \){#ranges[@]}]}\( ((RANDOM%256)). \)((RANDOM%256))"

    printf "\( {yellow}%-5s \){reset} \( {cyan}%-16s \){reset}  " "$tries" "$ip"

    if ping -c1 -W1 "$ip" &>/dev/null; then
        ms=$(ping -c1 "$ip" | awk -F'time=' '{print $2}' | awk '{printf "%.0f",$1}')
        if (( ms <= MAX_PING )); then
            echo -e "\( {green}✓ \){ms}ms\( {reset} \){purple}Star found!${reset}"
            found+=("\( ip → \){ms}ms")
        else
            echo -e "\( {yellow} \){ms}ms${reset}"
        fi
    else
        echo "no reply"
    fi

    (( tries % 30 == 0 )) && echo -e "\( {cyan}   Exploring... ( \){#found[@]}/\( {NEED}) \){reset}"
done

# Final result – now 100% correct
clear
echo -e "\( {blue}✦══════════════════════════════════════════════════════════════✦ \){reset}"
echo -e "\( {purple}       Successfully discovered \){#found[@]} fast IP(s) ≤ \( {yellow} \){MAX_PING}ms\( {purple}! \){reset}"
echo -e "\( {blue}✦══════════════════════════════════════════════════════════════✦ \){reset}\n"

for i in "${!found[@]}"; do
    echo -e "\( {green} \)((i+1)). \( {found[i]} \){reset}  \( {purple}Ready for warp! \){reset}"
done

echo -e "\n\( {blue}✦──────────────────────────────────────────────────────────────✦ \){reset}"
echo -e "\( {cyan}Total attempts: \){yellow}\( {tries} \){cyan} | Verified by Meher-Ips™ 2025${reset}"
echo -e "\( {blue}✦──────────────────────────────────────────────────────────────✦ \){reset}"

echo -e "\n\( {purple}Pure IPs – copy & paste directly! \){reset}"
echo -e "\( {blue}─────────────────────────────────────────────── \){reset}"

if [[ $format == "h" ]]; then
    printf '%s, ' "${found[@]%% →*}"
    echo
else
    printf '%s\n' "${found[@]%% →*}"
fi

echo -e "\( {blue}─────────────────────────────────────────────── \){reset}\n"
echo -e "\( {purple}Mission complete – Ready for the next jump! \){reset}\n"
