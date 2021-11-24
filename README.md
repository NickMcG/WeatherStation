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

## Issues

### nerves_bootstrap not installed

For some reason, this command doesn't work in the dockerfile: `RUN su ${USERNAME} -c "mix archive.install --force hex nerves_bootstrap"`.
Instead, I need to run it once the docker container is built.

**NOTE**: This needs to run each time the VS container gets rebuilt.
