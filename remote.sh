# Exec this on the remote pi as root, right after plugging in the sd card and power for the first time
pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syyu --noconfirm
pacman -S base-devel python3 --noconfirm
