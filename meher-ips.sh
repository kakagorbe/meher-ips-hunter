#!/bin/bash

# تمیز کردن ANSI با tput (بهتر از raw escape)
bold=$(tput bold)
green=$(tput setaf 2)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
reset=$(tput sgr0)

found=()
tries=0
max_tries=100  # حد تلاش

echo ""
echo "${blue}🌌 Meher-Ips™ Live Ping Hunter <120ms${reset}"

# 🚀 First: Ask for number! (جدا شده برای جلوگیری از overlap)
echo -n "${green}How many fast IPs do you want to find? (default: 3) ${reset}"
read -r num
if [[ -z "$num" ]]; then
  num=3
fi

# 🌿 Ask for output format!
echo -n "${green}Raw list format: v (vertical) or h (horizontal with comma)? (default: v) ${reset}"
read -r format
if [[ -z "$format" ]]; then
  format="v"
fi
if [[ "$format" == "h" || "$format" == "horizontal" ]]; then
  format="h"
else
  format="v"
fi

echo "${purple}🚀 Ready to explore ${num} stars? 🌌 Starting...${reset}"
echo ""

while (( ${#found[@]} < num && tries < max_tries )); do
  ((tries++))

  # 🎲 Random IP
  if (( RANDOM % 2 == 0 )); then
    ip="172.65.$((RANDOM % 256)).$((RANDOM % 256))"
  else
    ip="162.159.$((RANDOM % 256)).$((RANDOM % 256))"
  fi

  printf "${green}MehrabanScan #${tries} → %s ⏳ ${reset}" "$ip"

  ping_output=$(ping -c1 -W1 "$ip" 3>/dev/null 2>&1)
  ms=$(echo "$ping_output" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}' | cut -d'm' -f1)
  if [[ -z "$ms" ]]; then
    echo "no reply"
    continue
  fi

  if (( $(echo "$ms < 120" | bc -l) )); then
    echo -e "${green}✅ ${ms}ms${reset} ${purple}🚀 Space discovery! 🌌${reset}"
    found+=("$ip → ${ms}ms")
  else
    echo "too high (${ms}ms) – keep exploring!"
  fi
done

# Warning if less than requested
found_count=${#found[@]}
if (( found_count < num )); then
  echo ""
  echo "${blue}⚠️  Warning: Found only ${found_count} out of ${num} (after ${tries} tries). Try higher threshold or better network!${reset}"
  echo ""
fi

# Main box
echo ""
echo "${blue}✦─────────────────────────────────────────────────────✦${reset}"
echo "${purple}🌌🚀  Galactic discoveries: ${found_count} fast stars under 120ms! 🌌🚀${reset}"
echo "${blue}─────────────────────────────────────────────────────✦${reset}"

for i in {0..$((found_count-1))}; do
  echo "${green}$((i+1)). ${found[i]}${reset}  ${purple}✨ Ready to fly! ✨${reset}"
done

echo "${blue}✦─────────────────────────────────────────────────────✦${reset}"
echo "${green}📦 Verified by MehrabanScan™ – Next exploration? 🌿 (Total tries: $tries)${reset}"
echo "${blue}✦─────────────────────────────────────────────────────✦${reset}"
echo ""

# Pure copy section
if (( found_count > 0 )); then
  echo "${purple}🌌 Pure IPs ready – Direct to panel! 🚀${reset}"
  echo "${blue}📋 Pure IPs for panel (bulk copy - ${format}):${reset}"
  echo "${blue}───────────────────────────────────────────────${reset}"

  if [[ "$format" == "v" ]]; then
    for item in "${found[@]}"; do
      clean_ip=$(echo "$item" | cut -d' ' -f1)
      echo "${green}${clean_ip}${reset}"
    done
  else
    ips_clean=()
    for item in "${found[@]}"; do
      ips_clean+=($(echo "$item" | cut -d' ' -f1))
    done
    copy_line=$(IFS=', '; echo "${ips_clean[*]}")
    echo "${green}${copy_line}${reset}"
  fi

  echo "${blue}───────────────────────────────────────────────${reset}"
  echo ""
else
  echo ""
  echo "${blue}😔 No fast IPs found. Try different ranges or check your connection!${reset}"
  echo ""
fi
