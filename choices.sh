#!/bin/bash
PS3='Choose an option: '
options=("Start" "Recreate" "Stop" "Top" "List Running" "Clear Cache" "Quit")
select opts in "${options[@]}"; do
    case $opts in
        "Start")
            echo "Creating and starting containers"
	    docker compose -p conda up -d --remove-orphans
            break
            ;;
        "Recreate")
            echo "Recreating and rebuilding images and containers."
	    docker compose build
            break
            ;;
        "Stop")
            echo "Stopping and removing containers and images."
	    docker compose down --rmi all
	    break
            ;;
        "Top")
            echo "Displaying running processes."
            docker compose top
            #break
            ;;
        "List Running")
            echo "Displaying containers."
            docker compose ps
            #break
            ;;
        "Clear Cache")
            echo "Clearing build cache."
            docker builder prune -af
            #break
            ;;
	"Quit")
	    echo "Exiting script"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
