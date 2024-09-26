#!/bin/bash

#Exit immediately on error
set -e

handle_symlink() {
   local target=$1
   local symlink=$2
   local filename=$3
   echo "$target, $symlink, $filename"

   if [ -L "$symlink/$filename" ]; then
      if [[ "$(readlink "$symlink/$filename")" == "$target" ]]; then
         echo "Symlink for $filename is already in place and points to correct target"
      else
         echo "Symlink for $filename exists but doesnt point to .dotfiles/$filename"

         while true; do

            #Present user with choice: Remove or Leave
            read -p "Do you want to remove the existing Symlink and replace it with target to .dotfiles/$filename? (y/n): " choice

            if [[ "$choice" =~ [Yy]$ ]]; then
               #Remove symlink and replace
               unlink "$symlink/$filename"
               ln -s "$target" "$symlink"
               echo "Existing Symlink is removed and replaced with symlink of target .dotfiles/$filename"
               break
            elif [[ "$choice" =~ [Nn]$ ]]; then
               #Leave symlink as is
               echo "Existing Symlink remains unchanged"
               break
            else
               tput cuu1 && tput el
            fi
         done
      fi
      #Check if the file is a directory in .config
   elif [ -d "$symlink/$filename" ] || [ -f "$symlink/$filename" ]; then
      echo "$filename directory/file already exists in .config"

      # Loop until a valid choice is made
      while true; do

         # Present the user with options: Backup, Leave as is, or Delete
         echo "What would you like to do with $filename?"
         echo "1) Backup and create Symlink"
         echo "2) Delete and create Symlink"
         echo "3) Leave as is"
         read -p "Choose an option (1/2/3): " choice

         case "$choice" in
            1)
               # Create a backup by renaming the file or symlink
               mv "$symlink/$filename" "$symlink/${filename}_backup"
               ln -s "$target" "$symlink"
               echo "$filename has been renamed to ${filename}_backup as a backup and replaced with Symlink."
               break  # Exit the loop after valid action is taken
               ;;
            2)
               # Delete the file or directory
               rm -rf "$symlink/$filename"
               ln -s "$target" "$symlink"
               echo "$filename has been deleted from .config and replaced with symlink."
               break  # Exit the loop after valid action is taken
               ;;
            3)
               echo "No changes made to $filename. Keeping it as is."
               break  # Exit the loop after valid action is taken
               ;;
            *)
               tput cuu 5 && tput el
               ;;
         esac
      done
   else
      echo "Symlink not in place for $filename"
      while true; do
         read -p "Create the Symlink with target .dotfiles/$filename? (y/n)" choice

         if [[ "$choice" =~ [Yy]$ ]]; then
            #Create Symlink
            ln -s "$target" "$symlink"
            echo "Symlink created with target .dotfiles/$filename"
            break
         elif [[ "$choice" =~ [Nn]$ ]]; then
            #Leave symlink as is
            echo "No new Symlink created"
            break
         else
            tput cuu1 && tput el
         fi
      done
   fi
}

for entry in "$(pwd)"/*; do
   #Get the filename of each target
   filename=$(basename "$entry")

   #Skip the script itself
   if [[ "$filename" != "setup.sh" ]]; then
      #Handle all files in .dotfiles
      handle_symlink "$entry" "$HOME/.config" "$filename"

      #Additional file handling for .zshenv
      if [[ "$filename" = "zsh" ]]; then
         echo "If .zshenv is missing zsh config might not work properly"
         handle_symlink "$entry/.zshenv" "$HOME" ".zshenv"
      fi
   fi
done
