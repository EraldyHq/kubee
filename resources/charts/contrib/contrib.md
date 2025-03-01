

If you'd like to use helm-schema on your chart dependencies as well, you have to build and unpack them before.
You'll avoid the "missing dependency" error message.
```bash
# go where your Chart.lock/yaml is located
cd <chart-name>

# build dependencies and untar them
helm dep build
ls charts/*.tgz |xargs -n1 tar -C charts/ -xzf
```