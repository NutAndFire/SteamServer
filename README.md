# Rust_Server
Rust Server Installer for 64bit linux

A single run file to download Rust server and configure the run script.\n
This can be found at /home/{username}/Steam/rustserver.

Tested on:\n
  \tDebian 8-10
  \tUbuntu 18.04

The following actions will execute:\n
  \t1) Create a new user and add to sudoers
  \t2) Create a Steam directory
  \t3) Run apt-get update and install dependencies required for SteamCMD on 64-Bit server
  \t4) Download and extract SteamCMD
  \t5) Run SteamCMD and download Rust Server
  \t6) Create and configure a **startRust** script within the Rust directory
  \t7) Change directory owership
