#!/bin/bash

G='\033[0;32m'; B='\033[1;34m'; P='\033[0;35m'; N='\033[0m'
found=()
tries=0

echo -e "\n${B}🌌 Meher-Ips™ Live Ping Hunter <110ms${N}\n"

# 🚀 First: Ask for number!
read -p "${G}How many fast IPs do you want to find? (default: 3) ${N}" num
if [[ -z "$num" ]]; then
  num=3
fi

# 🌿 Ask for output format!
read -p "${G}Raw list format: v (vertical) or h (horizontal with comma)? (default: v) ${N}" format
if [[ -z "$format" ]]; then
  format="v"
fi
if [[ "$format" == "h" || "$format" == "horizontal" ]]; then
  format="h"
else
  format="v"
fi

echo -e "${P}🚀 Ready to explore ${num} stars? 🌌 Starting...${N}\n"

while (( ${#found[@]} < num )); do
  ((tries++))

  # 🎲 Choose random range between 172.67 and 162.159
  if (( RANDOM % 2 == 0 )); then
    ip="172.65.$((RANDOM % 256)).$((RANDOM % 256))"
  else
    ip="162.159.$((RANDOM % 256)).$((RANDOM % 256))"
  fi

  echo -ne "${G}MehrabanScan${N} #$tries → $ip ⏳ "

  ping_output=$(ping -c1 -W1 $ip 3>/dev/null 2>&1)
  ms=$(echo "$ping_output" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}' | cut -d'm' -f1)
  [[ -z "$ms" ]] && echo "no reply" && continue

  if (( $(echo "$ms < 105" | bc -l) )); then
    echo -e "${G}✅ ${ms}ms${N} ${P}🚀 Space discovery! 🌌${N}"
    found+=("$ip → ${ms}ms")
  else
    echo "too high (${ms}ms) – keep exploring!"
  fi
done

# 🔵 Main output - Exciting and ordered! (with arrow and ms)
echo -e "\n${B}✦─────────────────────────────────────────────────────✦${N}"
echo -e "${P}🌌🚀  Galactic discoveries: ${#found[@]} fast stars under 105ms! 🌌🚀${N}"
echo -e "${B}─────────────────────────────────────────────────────✦${N}"

for i in {0..$((num-1))}; do
  echo -e "${G}$((i+1)). ${found[i]}${N}  ${P}✨ Ready to fly! ✨${N}"
done

echo -e "${B}✦─────────────────────────────────────────────────────✦${N}"
echo -e "${G}📦 Verified by MehrabanScan™ – Next exploration? 🌿 (Total tries: $tries)${N}"
echo -e "${B}✦─────────────────────────────────────────────────────✦${N}\n"

# 📋 Easy copy section - Pure IPs only!
echo -e "\n${P}🌌 Pure IPs ready – Direct to panel! 🚀${N}"
echo -e "${B}📋 Pure IPs for panel (bulk copy - ${format}):${N}"
echo -e "${B}───────────────────────────────────────────────${N}"

if [[ "$format" == "v" ]]; then
  for item in "${found[@]}"; do
    clean_ip=$(echo "$item" | cut -d' ' -f1)  # Just IP (before →)
    echo -e "${G}${clean_ip}${N}"
  done
else
  # Horizontal: Pure IPs in one line with comma
  ips_clean=()
  for item in "${found[@]}"; do
    ips_clean+=($(echo "$item" | cut -d' ' -f1))
  done
  copy_line=$(IFS=', '; echo "${ips_clean[*]}")
  echo -e "${G}${copy_line}${N}"
fi

echo -e "${B}───────────────────────────────────────────────${N}\n"
