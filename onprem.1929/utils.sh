#!/bin/bash

. framework.sh

function print_menu() {
  broadcast 'g' "Please Select From The Following List Of Options"
  broadcast 'g' "1.  Cleanup Sysdig Install"
  broadcast 'g' "2.  Deploy Agents"
  broadcast 'g' "3.  Deploy Watchtower"
  broadcast 'g' "4.  Enable Kube Audit"
  broadcast 'g' "5.  Update CNAME Records"
  broadcast 'g' "6.  Fix Ingress Files"
  broadcast 'g' "7.  Setup Scanning"
  broadcast 'g' "8.  Update Falco Rules"
  broadcast 'g' "9.  Prep Cluster For Openshift"
}

function read_input() {
  broadcast 'r' "Enter Selection"
  read input
 while [[ -n ${input//[0-9]/} ]] || [[ "$input" -gt 9 ]]; do
    broadcast 'r'  "Please enter a valid Selection"
    broadcast 'r' "Enter Selection"
    read input
 done
}

function process_input() {
  input=$1
  if [[ $input -eq 1 ]]; then
    cleanup_sysdig
  elif [[ $input -eq 2 ]]; then
    deploy_agents
  elif [[ $input -eq 3 ]]; then
    deploy_watchtower
  elif [[ $input -eq 4 ]]; then
    enable_k8s_audit ~/.ssh/testinfrastructure.pem admin
  elif [[ $input -eq 5 ]]; then
    cname_manipulation
  elif [[ $input -eq 6 ]]; then
    fix_ingress
  elif [[ $input -eq 7 ]]; then
    setup_scanning
  elif [[ $input -eq 8 ]]; then
    update_falco_rules
  elif [[ $input -eq 9 ]]; then
    openshift_prep
  fi
}

function main() {
  input=$1
  if [ -z "$input" ]; then
    print_menu
    read_input
    process_input $input
  elif [[ -n ${input//[0-9]/} ]] || [[ "$input" -gt 9 ]]; then
    broadcast 'r' "You did not provide a valid option"
  else
    process_input $input
  fi
}

input=$1
main $input

