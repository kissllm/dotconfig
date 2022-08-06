#!/usr/bin/env sh
# setfont /usr/share/kbd/consolefonts/ter-132n.psf.gz
# setfont /usr/share/kbd/consolefonts/LatGrkCyr-12x22.psfu.gz
# Set font when running in console. For hidpi screen
# if [ $TERM = linux ]; then
    # terminus-font
    if [ -f "/mnt/setfont/consolefonts/ter-124b.psf.gz" ]; then
        setfont /mnt/setfont/consolefonts/ter-124b.psf.gz
    elif [ -f "/usr/share/consolefonts/ter-124b.psf.gz" ]; then
        setfont /usr/share/consolefonts/ter-124b.psf.gz
    elif [ -f "/usr/share/kbd/consolefonts/ter-124b.psf.gz" ]; then
        setfont /usr/share/kbd/consolefonts/ter-124b.psf.gz
    elif [ -f "/usr/share/consolefonts/LatGrkCyr-12x22.psfu.gz" ]; then
        setfont /usr/share/consolefonts/LatGrkCyr-12x22.psfu.gz
    elif [ -f "/usr/share/kbd/consolefonts/LatGrkCyr-12x22.psfu.gz" ]; then
        setfont /usr/share/kbd/consolefonts/LatGrkCyr-12x22.psfu.gz
    fi
# fi
