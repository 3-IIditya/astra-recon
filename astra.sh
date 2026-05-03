#!/bin/bash


set -euo pipefail
trap 'echo -e "\n[!] Interrupted. Exiting cleanly..."; exit 1' INT

# // script starting time
start_time=$(date +%s)


# // BANNERS ///

banner_dir=./banners
# pick random banner
banner_file=$(ls "$banner_dir" | shuf -n 1)

# print with color
echo -e "\e[97m"
cat "$banner_dir/$banner_file"
echo -e "\e[0m"

echo ""




# check dependencise 

tools=(sublist3r subfinder assetfinder httprobe httpx-toolkit naabu nmap gowitness getallurls hakrawler wappalyzer whatweb nuclei jq)

for tool in "${tools[@]}"; do
    command -v "$tool" >/dev/null 2>&1 || {
        echo "[!] $tool not installed. Exiting."
        exit 1
    }
done


#function

print_step() {
    echo -e "\e[91m \n[$] $1\n \e[0m"
}


# Project Documentation 

target="${1:-}"

# // input validation //

if [ -z "$target" ]
then
    echo "[!] Usage: $0 <domain>"
    exit 1
fi

mkdir -p "$target"

print_step "$target Locked..."


# // SUBDOMAIN ENUMERATION //

mkdir -p "$target/recon"

# // creating main files //

touch "$target/recon/subs1.txt" "$target/recon/subs2.txt" "$target/recon/subs3.txt" "$target/recon/subdomains.txt"

print_step "STARTING SUBDOMAIN ENUMERATION"

# Sublist3r rolling..."


sublist3r -d "$target" -t 100 -o "$target/recon/subs1.txt" 2>/dev/null &



# Subfinder rolling..."

subfinder -d "$target" >> "$target/recon/subs2.txt"  &



# Asset Finder rolling..." 
assetfinder -subs-only "$target" >> "$target/recon/subs3.txt" &

wait 

# //Sorting nd filtering //

sort -u "$target"/recon/subs*.txt > "$target/recon/subdomains.txt"
rm "$target"/recon/subs*.txt

echo "$target" >> "$target/recon/subdomains.txt"
sort -u "$target/recon/subdomains.txt" -o "$target/recon/subdomains.txt"


print_step "Subdomain Enumeration Done."



# // Checking for alive hosts // 

print_step "CHECKING FOR ALIVE HOSTS"

# // making main files //

touch "$target/recon/alive1.txt" "$target/recon/alive2.txt" "$target/recon/hosts_alive.txt"


#httprobe rolling..."
cat "$target/recon/subdomains.txt" | httprobe > "$target/recon/alive1.txt" 

#httpx-toolkit rolling..."
httpx-toolkit -l "$target/recon/subdomains.txt" -threads 100 -silent > "$target/recon/alive2.txt" 
wait
# // sorting nd filtering

sort -u "$target"/recon/alive*.txt > "$target/recon/hosts_alive.txt"
rm "$target"/recon/alive*.txt


# // Port Scanning //

print_step "STARTING PORT SCAN"

mkdir -p "$target/ports"

# // creating main file //

touch "$target/recon/clean_target.txt" 

cat "$target/recon/hosts_alive.txt" | sed 's|http[s]*://||' > "$target/recon/clean_target.txt"

# Naabu rolling ..."

#// creating main file //

touch "$target/ports/naabu.txt" "$target/ports/nmap.txt"


naabu -l "$target/recon/clean_target.txt" -top-ports 1000 -rate 1000 > "$target/ports/naabu.txt"

# Nmap rolling ..."

nmap -iL "$target/recon/clean_target.txt" -sV -sC -T4 --top-ports 1000 -oN "$target/ports/nmap.txt"


print_step "PORT SCANNING DONE "


# // VISUAL RECON //

print_step "STARTING VISUAL RECON "
mkdir -p "$target/screenshots"

# "gowitness rolling ..."

gowitness scan file -f "$target/recon/hosts_alive.txt" --no-http --save-content --write-db -s "$target/screenshots"

print_step "Screenshots captured."




# // URL Gathering (goldmine phase) //

print_step "GATHERING URLs"
mkdir -p "$target/urls"
# getallurls (gau) rolling ..."

# // creating main files //

touch "$target/urls/urls1.txt" "$target/urls/urls2.txt" "$target/urls/gathered_urls.txt"


getallurls "$target" -subs -o "$target/urls/urls1.txt" &

# hakrawler rolling ..."
cat "$target/recon/hosts_alive.txt" | hakrawler -subs -d 5 -t 50 -u >> "$target/urls/urls2.txt" & 
wait 
# sorting and filtering

sort -u "$target"/urls/urls*.txt > "$target/urls/gathered_urls.txt"
rm "$target"/urls/urls*.txt

print_step " [+] URL Gathering complete."



# // Techonology Detection // 

print_step "STARTING TECHNOLOGY DETECTION"
# wappalyzer rolling ..."

mkdir -p "$target/technologies"

# // creating main files //

touch "$target/technologies/wappalyzer.txt" "$target/technologies/whatweb.txt"

cat "$target/recon/hosts_alive.txt" | xargs -I {} -P 20 sh -c 'wappalyzer "{}" 2>/dev/null | jq -c || true' >> "$target/technologies/wappalyzer.txt"



# WhatWeb rolling ..."


whatweb -a 3 -i "$target/recon/hosts_alive.txt" --log-brief="$target/technologies/whatweb.txt"




# // Vulnerability Scanning (automation layer) //


print_step "STARTING VULNERABILITY SCANNING "

mkdir -p "$target/vulns"

# // creating main files //

touch "$target/vulns/nuclei.txt"

nuclei -l "$target/recon/hosts_alive.txt" -as -severity medium,high,critical -silent -o "$target/vulns/nuclei.txt"




# // printing output stored path //

print_step ""

echo -e "\n[+] Output saved in:"
echo "   Recon        → $target/recon/"
echo "   Ports        → $target/ports/"
echo "   URLs         → $target/urls/"
echo "   Screenshots  → $target/screenshots/"
echo "   Techs        → $target/technologies"
echo "   Vulns        → $target/vulns/"

# // end time //

end_time=$(date +%s)
duration=$((end_time - start_time))

echo -e "\n[+] Execution time: ${duration}s"


# // scan complete // 


echo -e "\e[92m"
echo "======================================"
echo "        A.S.T.R.A COMPLETED"
echo "======================================"
echo -e "\e[0m"

