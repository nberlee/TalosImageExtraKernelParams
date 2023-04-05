# Extra kernel parameters in Talos Image
Add custom kernel parameters to Talos Images, without upgrading. Ideal for Talos cloud images.

## Run it
make sure your image, in this example `gcp-amd64.tar.gz` is in the current path
```sh
modprobe loop
docker run --privileged  -v .:/_out --rm -it ghcr.io/nberlee/talos-image-extra-kernel-params  gcp-amd64.tar.gz "cpufreq.default_governor=performance talos.dashboard.disabled=1"
```

- `--privileged` is needed for creating loop devices
- `-v .:/_out` mounts the current directory `.` to the working directory `/_out` in the container. Change `.` to any path
- `--rm` cleans up container after run
- `ghcr.io/nberlee/talos-image-extra-kernel-params` latest container image
- `gcp-amd64.tar.gz` path to talos image to modify
- `"cpufreq.default_governor=performance talos.dashboard.disabled=1"` parameters to add, encapsulate in `""` for multiple kernel parameters.