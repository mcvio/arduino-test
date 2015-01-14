hex:
	avr-gcc -Os -DF_CPU=16000000UL -mmcu=atmega328p -c -o blink.o blink.c
	avr-gcc -mmcu=atmega328p blink.o -o blink.a
	avr-objcopy -O ihex -R .eeprom blink.a blink.hex

upload:
	avrdude -v -c arduino -p m328p -P /dev/tty.usbmodem1421 -U flash:w:blink.hex

backup:
	for op in eeprom flash lfuse hfuse efuse lock calibration signature; do avrdude -v -c arduino -p m328p -P /dev/tty.usbmodem1421 -U $$op:r:backup-$$op.hex:i; done

clean:
	rm -f blink blink.o blink.elf blink.a
