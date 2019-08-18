# Rust_Server
Rust Server Installer for 64bit linux

A single run file to download Rust server and configure the run script.

This can be found at /home/{username}/Steam/rustserver.

Tested on:

  Debian 8-10
  
  Ubuntu 18.04

The following actions will execute:
  1) Create a new user and add to sudoers
  2) Create a Steam directory
  3) Run apt-get update and install dependencies required for SteamCMD on 64-Bit server
  4) Download and extract SteamCMD
  5) Run SteamCMD and download Rust Server
  6) Create and configure a **startRust** script within the Rust directory
  7) Change directory owership

Uninstaller is not functional, if you wish to roll back this setup use "userdel -r {username}", "nano /etc/sudoers 'remove the username'", "apt remove lib32gcc1 -y"
