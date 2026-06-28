# Selena SDDM Theme

An animated SDDM login theme featuring **Selena** from *Punishing: Gray Raven* / *Wuthering Waves* (Kuro Games).  
Inspired by the Tokyo Night color palette — dark, sleek, and modern.

## Features

- **Animated background** — plays a looping background video (MP4) on the login screen
- **Clock & date** — displayed in the top-left corner
- **Weather & AQI** — auto-detects your location and shows current temperature + air quality index (via ip-api.com + Open-Meteo)
- **User switching** — cycle through available users with a single click
- **Session switching** — cycle through installed desktop sessions (niri, KDE, Hyprland, GNOME, etc.)
- **Power actions** — Suspend, Reboot, Shutdown from the Advanced menu
- **Password field** — "show password" toggle, Caps Lock indicator, shake animation on failed login
- **Fully scalable** — adapts to any screen resolution
- **Tokyo Night color palette** — easy to customize

## Preview

| Login Screen | Password Input |
|:---:|:---:|
| ![Login](preview-login.png) | ![Password](preview-password.png) |

> ⚠️ **Screenshots above show the theme layout. Your actual login screen will look different because**
> **a) you must provide your own background video, and b) weather data is fetched live from your location.**

## ⚠️ Important: You Must Provide a Background Video

This theme plays a **looping MP4 background video**. The video file is **not included in this repo** because:
- Videos are very large (often 100–200 MB)
- Everyone has different taste in backgrounds

**You must supply your own `background.mp4`** after installation. See [Adding a Background Video](#adding-a-background-video) below.

## Requirements

- **SDDM** (≥ 0.20 recommended)
- **Qt6** (Qt 6.5+ recommended) or **Qt5** (adjust `QtVersion` in `Metadata.desktop`)
- **Qt Multimedia** — for video playback (`qt6-multimedia` or `qt5-multimedia`)

## Installation

### Arch Linux / EndeavourOS / CachyOS / Manjaro

```bash
# Install dependencies
sudo pacman -S sddm qt6-multimedia qt6-wayland

# Clone the theme
git clone https://github.com/TheLiems-dev/selena-sddm-theme.git /tmp/selena
sudo cp -r /tmp/selena /usr/share/sddm/themes/selena
rm -rf /tmp/selena

# Add your background video
# Place a file named "background.mp4" in /usr/share/sddm/themes/selena/

# Set as current SDDM theme
echo "[Theme]
Current=selena" | sudo tee /etc/sddm.conf.d/theme.conf

# Or edit /etc/sddm.conf:
#   [Theme]
#   Current=selena
```

### Fedora / RHEL

```bash
# Install dependencies
sudo dnf install sddm qt6-qtmultimedia qt6-qtwayland

# Clone and install
git clone https://github.com/TheLiems-dev/selena-sddm-theme.git /tmp/selena
sudo cp -r /tmp/selena /usr/share/sddm/themes/selena
rm -rf /tmp/selena

# Add your background video
# Place "background.mp4" in /usr/share/sddm/themes/selena/

# Set as theme
echo "[Theme]
Current=selena" | sudo tee /etc/sddm.conf.d/theme.conf
```

### Debian / Ubuntu / Linux Mint

```bash
# Install dependencies
sudo apt install sddm qt6-multimedia qt6-wayland

# Clone and install
git clone https://github.com/TheLiems-dev/selena-sddm-theme.git /tmp/selena
sudo cp -r /tmp/selena /usr/share/sddm/themes/selena
rm -rf /tmp/selena

# Add your background video
# Place "background.mp4" in /usr/share/sddm/themes/selena/

# Set as theme
echo "[Theme]
Current=selena" | sudo tee /etc/sddm.conf.d/theme.conf
```

### openSUSE

```bash
# Install dependencies
sudo zypper install sddm qt6-multimedia qt6-wayland

# Clone and install
git clone https://github.com/TheLiems-dev/selena-sddm-theme.git /tmp/selena
sudo cp -r /tmp/selena /usr/share/sddm/themes/selena
rm -rf /tmp/selena

# Add background video...
# Place "background.mp4" in /usr/share/sddm/themes/selena/

# Set as theme
echo "[Theme]
Current=selena" | sudo tee /etc/sddm.conf.d/theme.conf
```

### Standalone / Independent Distros (Void Linux, Alpine, Artix, Gentoo, NixOS, etc.)

<details>
<summary><b>Void Linux</b></summary>

```bash
sudo xbps-install -S sddm qt6-multimedia qt6-wayland
git clone https://github.com/TheLiems-dev/selena-sddm-theme.git /tmp/selena
sudo cp -r /tmp/selena /usr/share/sddm/themes/selena
rm -rf /tmp/selena
# Place background.mp4 in /usr/share/sddm/themes/selena/
echo "[Theme]
Current=selena" | sudo tee /etc/sddm.conf.d/theme.conf
```
</details>

<details>
<summary><b>Artix Linux (OpenRC / runit / s6)</b></summary>

```bash
# Enable the SDDM daemon for your init:
#   OpenRC:  sudo rc-update add sddm
#   runit:   sudo ln -s /etc/runit/sv/sddm /run/runit/service/
#   s6:      sudo s6-service-add default sddm

sudo pacman -S sddm qt6-multimedia qt6-wayland
git clone https://github.com/TheLiems-dev/selena-sddm-theme.git /tmp/selena
sudo cp -r /tmp/selena /usr/share/sddm/themes/selena
rm -rf /tmp/selena
echo "[Theme]
Current=selena" | sudo tee /etc/sddm.conf.d/theme.conf
```
</details>

<details>
<summary><b>Gentoo Linux</b></summary>

```bash
sudo emerge --ask x11-misc/sddm dev-qt/qtmultimedia:6
git clone https://github.com/TheLiems-dev/selena-sddm-theme.git /tmp/selena
sudo cp -r /tmp/selena /usr/share/sddm/themes/selena
rm -rf /tmp/selena
echo "[Theme]
Current=selena" | sudo tee /etc/sddm.conf.d/theme.conf
```
</details>

<details>
<summary><b>NixOS</b></summary>

In your `/etc/nixos/configuration.nix` or flake:

```nix
{ config, pkgs, ... }:
let
  selenaTheme = pkgs.stdenv.mkDerivation {
    name = "selena-sddm-theme";
    src = pkgs.fetchFromGitHub {
      owner = "TheLiems-dev";
      repo = "selena-sddm-theme";
      rev = "main";
      sha256 = "0000000000000000000000000000000000000000000000000000"; # replace after first build
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes/selena
      cp -r ./* $out/share/sddm/themes/selena/
    '';
  };
in {
  services.displayManager.sddm = {
    enable = true;
    theme = "${selenaTheme}/share/sddm/themes/selena";
    extraConfig = ''
      [Theme]
      Current=selena
    '';
  };
}
```

Then rebuild: `sudo nixos-rebuild switch`
</details>

<details>
<summary><b>Alpine Linux</b></summary>

```bash
sudo apk add sddm qt6-qtmultimedia qt6-wayland
git clone https://github.com/TheLiems-dev/selena-sddm-theme.git /tmp/selena
sudo cp -r /tmp/selena /usr/share/sddm/themes/selena
rm -rf /tmp/selena
echo "[Theme]
Current=selena" | sudo tee /etc/sddm.conf.d/theme.conf
```
</details>

## Adding a Background Video

The theme plays `background.mp4` from its own directory.  
**You must provide this file yourself — it is not included in the repo.**

You can use **any MP4 video** — a game cutscene, an anime scene, a nature timelapse, etc.

```bash
# Copy your video to the theme directory
sudo cp /path/to/your/video.mp4 /usr/share/sddm/themes/selena/background.mp4
```

### Video Tips

| Guideline | Recommendation |
|-----------|---------------|
| Resolution | 1920×1080 or higher (matching your screen) |
| Looping | Make sure it loops seamlessly (no abrupt cuts) |
| File size | Keep under 200 MB for faster loading |
| Audio | Not needed — the theme mutes audio. Re-encode without audio to save space |
| Format | MP4 with H.264 encoding (widest compatibility) |

### Example: Re-encode a video without audio

```bash
ffmpeg -i your_source.mp4 -c:v libx264 -preset medium -an background.mp4
```

## Customization

### Colors

Colors are defined inline in `Main.qml`. Edit these values to match your preference:

| Variable | Default | Description |
|----------|---------|-------------|
| Background tint | `#1a1b26` | Tokyo Night base |
| Text | `#a9b1d6` | Tokyo Night foreground |
| Accent (focused) | `#7aa2f7` | Tokyo Night blue |
| Error | `#f7768e` | Tokyo Night red |
| Warning (Caps Lock) | `#e0af68` | Tokyo Night yellow |
| Muted | `#565f89` | Tokyo Night comment |

### Layout

- **Clock position**: adjust `topMargin` and `leftMargin` in `infoPanel`
- **Bottom group (logo + password)**: adjust `bottomMargin` in `bottomGroup`
- **Action buttons (top-right)**: adjust `topMargin` and `rightMargin` in the right column

### Weather / AQI

The theme fetches:
1. Location via [ip-api.com](http://ip-api.com) (free, no key)
2. Weather via [Open-Meteo](https://open-meteo.com) (free, no key)
3. AQI via [Open-Meteo Air Quality API](https://open-meteo.com/en/docs/air-quality-api) (free, no key)

If any request fails, the weather display is hidden.

## Troubleshooting

### SDDM shows a blank / black screen

- Make sure `qt6-multimedia` is installed
- Check if the video path in `Main.qml` line 22 matches your file
- Try disabling the video temporarily: comment out lines 19–33 in `Main.qml`
- Check SDDM logs: `journalctl -u sddm -e`

### Weather not showing

- Ensure your system has internet access at the login screen
- Check if `ip-api.com`, `api.open-meteo.com`, and `air-quality-api.open-meteo.com` are reachable
- SDDM may block network requests on some distros — try adding firewall exceptions

### User / Session switching not working

- The theme uses invisible `ListView` helpers (`userHelper`, `sessionHelper`) bound to SDDM's models (`userModel`, `sessionModel`)
- Some older SDDM versions may not expose these models — upgrade SDDM to ≥ 0.20
- Alternatively, check that your `/etc/sddm.conf` has `Relogin=true` so the session list populates

### Video has no audio (expected)

The theme explicitly sets `volume: 0.0` and `muted: true`. Re-encode your video without an audio track to reduce file size.

## File Structure

```
/usr/share/sddm/themes/selena/
├── background.mp4        # Your background video (not included)
├── Main.qml              # Main login theme script
├── preview.qml           # Preview script for theme editors
├── Metadata.desktop      # SDDM theme metadata
├── theme.conf            # Empty config (reserved)
├── Kuro_Games_Logo.png   # Kuro Games watermark logo
└── logo pgr.png          # PGR / Wuthering Waves logo
```

## Credits

- **Tokyo Night** color palette by [enkia](https://github.com/enkia)
- **Selena** character © Kuro Games (Punishing: Gray Raven)
- **SDDM** — [Simple Desktop Display Manager](https://github.com/sddm/sddm)
- **Weather data** — [Open-Meteo](https://open-meteo.com), [ip-api.com](http://ip-api.com)

## License

MIT
