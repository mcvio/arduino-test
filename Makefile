CC=avr-gcc

CFLAGS=-Os -DF_CPU=16000000UL -mmcu=atmega328p -c
LDFLAGS=-mmcu=atmega328p

SOURCES=blink.c
OBJECTS=$(SOURCES:.c=.o)

EXECUTABLE=blink

all: $(SOURCES) $(EXECUTABLE)
	
$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
	avr-objcopy -O ihex -R .eeprom $(EXECUTABLE) $(EXECUTABLE).hex

.c.o:
	$(CC) $(CFLAGS) $< -o $@

upload:
	avrdude -v -c arduino -p m328p -P /dev/tty.usbmodem1421 -U flash:w:$(EXECUTABLE).hex

backup:
	for op in eeprom flash lfuse hfuse efuse lock calibration signature; do avrdude -v -c arduino -p m328p -P /dev/tty.usbmodem1421 -U $$op:r:backup-$$op.hex:i; done

clean:
	rm -f $(EXECUTABLE).hex $(EXECUTABLE) $(OBJECTS) 
