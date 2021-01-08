#!/bin/bash
#
# This script tweaks the header of WAVE files, and replaces the WAVE_FORMAT_EXTENSIBLE (0xFFFE)
# header with WAVE_FORMAT_PCM (0x0001). This allows tools like ssrc_hp to work again.
#
# Rationale: FLAC 1.3.3 now outputs WAVE_FORMAT_EXTENSIBLE for 24-bit WAV files.
#
for i in *.wav; do
  printf '\x01\x00' | dd of="$i" bs=1 seek=20 count=2 conv=notrunc status=none
done
