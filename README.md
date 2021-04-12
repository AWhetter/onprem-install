# CodeStream On-Prem

This repo holds the packaging, control & support tools used for installation and
management of the On-Prem version of CodeStream.

[The official On-Prem administrator's guide is located
here](https://docs.codestream.com/onprem). If you've elected to try **CodeStream
On-Prem**, start with this guide.

Documentation located in this repo is targeted towards maintainers and those
interested in a more in-depth view of the on-prem architecture.

## Docker Installation Options

On-Prem is distributed through docker images which reside on [docker
hub](hub.docker.com). There are a number of installation profiles available
(called _product types_) which include containers running under **Linux** and
**OSX** using host-based networking as well as a `docker-compose` configuration
which runs the containers in a docker bridged network. The compose product type
supports **Windows** as well. At this time, all product types must run on a
single host OS.

An OS-specific _control script_ is provided which pulls down templates, the
latest version info and other resources and will prepare the host environment
for the installation. It also offers control features (start, stop, reset,
etc...) and a host of support and maintenance functions.

While all of the CodeStream software runs inside the docker containers, the
control script and supporting files in this repo are required to provide the
comprehensive on-prem feature set. Work to migrate many of the control script
features into the CodeStream product is on-going however the control script
should be considered a requirement at this time.
