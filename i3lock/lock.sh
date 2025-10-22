#!/bin/bash
# ============================================
# i3lock-color - Minimalist Lock Screen
# Clean black & white theme
# ============================================

i3lock \
--color=000000 \
--insidever-color=00000000 \
--insidewrong-color=00000000 \
--inside-color=00000000 \
--ringver-color=ffffff33 \
--ringwrong-color=cc241d33 \
--ring-color=ffffff11 \
--line-uses-inside \
--keyhl-color=ffffff66 \
--bshl-color=cc241d66 \
--separator-color=00000000 \
--verif-color=ffffffff \
--wrong-color=cc241dff \
--modif-color=ffffffff \
--layout-color=ffffffff \
--time-color=ffffffff \
--date-color=ffffffbb \
--greeter-color=ffffff66 \
--ind-pos="x+w/2:y+h/2+100" \
--time-pos="x+w/2:y+h/2-60" \
--date-pos="x+w/2:y+h/2-20" \
--greeter-pos="x+w/2:y+h/2+20" \
--verif-pos="x+w/2:y+h/2+140" \
--wrong-pos="x+w/2:y+h/2+140" \
--time-str="%H:%M" \
--date-str="%A, %B %d" \
--greeter-text="Type password to unlock" \
--verif-text="Verifying..." \
--wrong-text="Wrong password!" \
--noinput-text="" \
--time-font="JetBrainsMono Nerd Font" \
--date-font="JetBrainsMono Nerd Font" \
--layout-font="JetBrainsMono Nerd Font" \
--verif-font="JetBrainsMono Nerd Font" \
--wrong-font="JetBrainsMono Nerd Font" \
--greeter-font="JetBrainsMono Nerd Font" \
--time-size=84 \
--date-size=20 \
--greeter-size=16 \
--verif-size=16 \
--wrong-size=16 \
--radius=80 \
--ring-width=4 \
--pass-media-keys \
--pass-screen-keys \
--pass-volume-keys \
--show-failed-attempts \
--blur=8 \
--clock \
--indicator \
--time-align=0 \
--date-align=0 \
--verif-align=0 \
--wrong-align=0 \
--greeter-align=0 \
--force-clock
