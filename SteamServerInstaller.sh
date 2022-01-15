#!/bin/bash

user='steam'
steam_loc='Steam'
val_server_name='valserver'
rust_server_name='rustserver'
steamCMD_commands='+quit'

run_init() {
    add_userAccount $1
    add_sudoers $1
    create_dir $1
    add_depend
    get_steamCMD $1
    run_steamCMD $1
    create_rustinit $1
    create_valinit $1
    change_owership $1
}

steamCMD_Setup() {
    # Rust
    steamCMD_commands="+force_install_dir /home/$1/${steam_loc}/${rust_server_name} +login anonymous +app_update 258550 +quit"
    # Val
    steamCMD commands="+force install dir /home/$1/${stream_loc}/${val_server_name} +login anonymous +app_update 896660 validate +quit"
}

add_userAccount() {
    stty -echo
    read -p "Enter Password for account: " userPW
    stty echo
    echo
    adduser --quiet --disabled-password --shell /bin/bash --home /home/$1 --gecos "User" $1
    echo "$1:${userPW}" | chpasswd
}

add_sudoers() {
    echo "adduser $1 sudo"
}

create_dir() {
    mkdir /home/$1/${steam_loc}
}

add_depend() {
    apt-get update && apt install lib32gcc-s1 libsdl2-2.0-0 -y
}

get_steamCMD() {
    cd /home/$1/${steam_loc}
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
}

run_steamCMD() {
    steamCMD_Setup $1
    /home/$1/${steam_loc}/steamcmd.sh ${steamCMD_commands}
}

create_valinit() {
    printf "#!/bin/bash\n\nexport templdpath=$LD_LIBRARY_PATH\n\nexport LD_LIBRARY_PATH=/home/$1/${steam_loc}/${val_server_name}/linux64:$LD_LIBRARY_PATH\n\nexport SteamAppID=896660\n\necho 'Starting server PRESS CTRL-C to exit'\n\n/home/$1/${steam_loc}/${val_server_name}/valheim_server.x86_64 -name '<servername>' \x5c\n -port 2456 \x5c\n -nographics \x5c\n -bathmode \x5c\n -world '<worldname>' \x5c\n -password '<serverpassword> \x5c\n -public 0'" >> /home/$1/${steam_loc}/${val_server_name}/startVal.sh
    chmod u+x /home/$1/${steam_loc}/${val_server_name}/startVal.sh
}

create_rustinit() {
    printf "#!/bin/bash\n\nexport LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/$1/${steam_loc}/${rust_server_name}/RustDedicated_Data/Plugins/x86_64\n\n/home/$1/${steam_loc}/steamcmd.sh ${steamCMD_commands}\n\nwhile:do\n    nohup ./RustDedicated -batchmode -nographics \x5C\n    -server.port 28015 \x5C\n    -rcon.port 28016 \x5C\n    -rcon.password 'superpassword' \x5C\n    -server.maxplayers 60 \x5C\n    -server.hostname 'Server Name' \x5C\n    -server.identity 'node1' \x5C\n    -server.level 'Procedural Map' \x5C\n    -server.seed 12345 \x5C\n    -server.worldsize 3000 \x5C\n    -server.saveinterval 300 \x5C\n    -server.globalchat true \x5C\n    -server.description 'Description Here' \x26\ndone" >> /home/$1/${steam_loc}/${rust_server_name}/startRust.sh
    chmod u+x /home/$1/${steam_loc}/${rust_server_name}/startRust.sh
}

change_owership() {
    chown -R $1:$1 /home/$1/${steam_loc}
}

installer() {

    echo
    echo "Welcome to SteamServerInstaller, a quick way to get your server up and running."
    echo "The following tasks will run to get you setup and configured!"
    echo
    echo "1) Create a new user and add to sudoers"
    echo "2) Create a Steam directory"
    echo "3) Run apt-get update and install dependencies required for SteamCMD on 64-Bit server"
    echo "4) Download and extract SteamCMD"
    echo "5) Run SteamCMD and download Server"
    echo "6) Create and configure a **start{Name}.sh** script within the server directory"
    echo "7) Change directory owership"
    echo
    echo "Starting..."
    echo

    sleep 5

    echo "Setting up new user!"
    echo
    echo "( Leave blank for Default username )"
    read -p "What would you like to call the new user? [Default 'steam'] " name


    if [ "$name" != "" ]; then
        echo ${name}
        run_init ${name}
    else
        echo ${user}
        run_init ${user}
    fi
}

# Uninstaller is not functional, if you wish to roll back this setup use "userdel -r {username}", "nano /etc/sudoers 'remove the username'", "apt remove lib32gcc1 -y"
uninstaller() {
    echo "Test"
    location=$(find / | grep "\<RustDedicated\>")
    echo $location
}

help() {
    echo "Usage:"
    echo "    SteamServerInstaller -h               Display this help message."
    echo "    SteamServerInstaller -i               Install Server."
    echo "    SteamServerInstaller -u               Uninstall Server."
}

main() {
    local OPTIND opt i
    while getopts ":hiu" opt; do
        case $opt in
            i )
              installer
              ;;
            u )
              uninstaller
              ;;
            h )
              help
              exit 0
              ;;
            \? )
              echo "Invalid Option: -$OPTARG" 1>&2
              echo
              help
              exit 1
              ;;
        esac
    done

    if [ $OPTIND -eq 1 ]; then
        echo "No options were passed"
        echo
        help
    fi

    shift $((OPTIND -1))
}

main $@
