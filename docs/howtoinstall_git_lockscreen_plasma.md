Location: /home/fcavalcanti/.local/share/plasma/wallpapers
1) First git clone: git clone https://github.com/nhanb/com.nerdyweekly.animated.git
2) Then edit: vim com.nerdyweekly.animated/contents/ui/*.qml and replace the .gif file with the one you want
3) Create the index: metadata.desktop -> com.nerdyweekly.animated/metadata.desktop
4) Run: plasmapkg2 --generate-index
