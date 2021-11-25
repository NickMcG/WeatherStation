# WeatherStation

Repo to follow along with the "Build a Weather Station with Elixir and Nerves"

## Sensor Hub

### Building

To get it to connect to the wireless network, you need to copy `/sensor_hub_poncho/sensor_hub/config/target.exs.template` to
`/sensor_hub_poncho/sensor_hub/config/target.exs` and fill in the network name and password. (Search for `~CHANGE-ME~`).

Once that has been corrected, you should be able to build with the following commands (from within the
`sensor_hub_poncho/sensor_hub` folder):

```bash
export MIX_TARGET=rpi3
mix deps.get
mix firmware
mix firmware.burn -d ./image_output/build.img
```

If the image has already been burnt to the device, and it is plugged in, then it can be uploaded with:

```bash
mix upload hub.local
```

Additionally, to connect to it, you can do:

```bash
ssh hub.local
```

### Notes on LED Stick

[https://github.com/sparkfun/SparkFun_Qwiic_LED_Stick_Arduino_Library/blob/master/src/Qwiic_LED_Stick.cpp]

Need to look through the code for info on how to modify it, but it doesn't look too difficult.

All of these are writes, so something like `I2C.write!(i2c, 0x23, data)`.

Key:

* `0x##` - 1-based index of LED to change
* `0xrr` - red-value (0-255)
* `0xgg` - green-value (0-255)
* `0xbb` - blue-value (0-255)
* `0xll` - length of array
* `0xbr` - brightness (0-31)

Commands:

* Change Address (`0xC7`) for changing the I2C address
* Change length (`0x70`)
* Write single LED color (`0x71`) - `I2C.write!(i2c, 0x23, <<0x71, 0x##, 0xrr, 0xgg, 0xbb>>)`
* Write all LED colors (`0x72`) - `I2C.write!(i2c, 0x23, <<0x72, 0xrr, 0xgg, 0xbb>>)`
* Write single LED brightness (`0x76`) - `I2C.write!(i2c, 0x23, <<0x76, 0x##, 0xbr>>)`
* Write all LED brightness (`0x77`) - `I2C.write!(i2c, 0x23, <<0x77, 0xbr>>)`
* Write all LED off (`0x78`) by changing brightness to 0 - `I2C.write!(i2c, 0x23, <<0x78>>)`

Writing array, either red (`0x73`), green (`0x74`), or blue (`0x75`). Up to 12 LEDs can be adjusted this way at one time.
The format of the data looks something like `<<0x73, 0x04, 0x01, 0x11, 0x22, 0x33, 0x44>>`. That would set the red (`0x73`)
values for 4 (`0x04`) LEDs, starting at index 1 (`0x01`). The first would have a red value of `0x11`, then `0x22`, then
`0x33`, and finally `0x44`.

### Notes on QuiicNES

[https://github.com/sparkfun/SparkFun_QwiicNES_Arduino_Library/blob/main/src/SparkFun_QwiicNES_Arduino_Library.cpp]

Looks like it is pretty simple - you can do `I2C.write_read!(i2c, 0x54, <<0x01>>, 1)`. That will return back the
button presses since the last call. There are 8 buttons, so each bit in the byte represents 1 button.

Instead of `<<0x01>>`, you could also send `<<0x00>>` to get the current state of key presses.

There are also commands to read the current I2C address (`<<0x02>>`) or change the I2C address (`<<0x03>>`).
Reading it probably isn't useful, but changing it can be if `0x54` conflicts with a different device.

## Issues

### nerves_bootstrap not installed

For some reason, this command doesn't work in the dockerfile: `RUN su ${USERNAME} -c "mix archive.install --force hex nerves_bootstrap"`.
Instead, I need to run it once the docker container is built. (`mix archive.install hex nerves_bootstrap`).

**NOTE**: This needs to run each time the VS container gets rebuilt.
