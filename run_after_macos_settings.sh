#!/bin/bash
set -euo pipefail
set -vx

# Flash the screen when a beep is played
defaults write -g "com.apple.sound.beep.flash" -int 1

# Play sounds while adjusting the volume
defaults write -g "com.apple.sound.beep.feedback" -int 1

# Show ~/Library
chflags nohidden ~/Library

# Disable holding a key for the special character menu
defaults write -g ApplePressAndHoldEnabled -bool false

# Make keys repeat moderately fast
defaults write -g KeyRepeat -int 2

# Show external volumes on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# enable ntp
systemsetup -setusingnetworktime on &>/dev/null

# restart on power failure
systemsetup -setrestartpowerfailure on &>/dev/null

# restart on freeze
systemsetup -setrestartfreeze on &>/dev/null

# Enable Safari development mode
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
