# NixOS Configuration

## Initial setup

This assumes you are running NixOS with an internet connection.

```sh
cd ~
nix-shell -p gh
gh auth login
gh repo clone nixos-config
# edit the hostname if not using LT16

sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo ln -s /home/james/nixos-config/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

### Displaylink Docking station

This needs a binary file downloading first, or the `services.xserver.videoDrivers` line commenting out. To do the download (from this repository):

```sh
nix-shell
task displaylink
task rebuild
rm displaylink-580.zip
```

The system needs to be rebooted to detect the displays.

## System install (to USB / HDD)

Boot the minimal install

```sh
sudo -s
blkid # make a note of target device
ip a # make a note of wifi adapter

wpa_passphrase "SSID" > wifi.conf
wpa_supplicant -i <wifi adapter e.g. wlp1s0> -c wifi.conf -B
dhcpcd

fdisk /dev/sdX # where sdX is the target disk
# g, n, 1, 2048, +M, t, 1, n, 2, <enter>, <enter>, w # GPT with 500MB EFI partition and linux partition filling the rest of the disk
mkfs.fat -F 32 /dev/sdX1
fatlabel /dev/sdX1 NIXBOOT
mkfs.ext4 /dev/sdX2 -L NIXROOT
mount /dev/disk/by-label/NIXROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

nixos-generate-config --root /mnt
curl https://raw.githubusercontent.com/jamesdkelly88/nixos-config/refs/heads/main/configuration.nix > /mnt/etc/nixos/configuration.nix
cd /mnt
nixos-install

# set root password when prompted
# reboot
# login as root
# set passwd for james
# switch to user james and lock root user:
passwd -l root
```

## TODO

- samba with SMB1
- homemanager
- essential packages
- system settings