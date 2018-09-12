# prosody-config


This is an example of a Prosody XMPP server configuration, similar to the one used on [trashserver.net](https://trashserver.net).

* Uses PostgreSQL database backend
* Uses HaProxy to make connections available on public network interfaces
* Prosody Community Modules are in ```/opt/prosody-modules```
* Sends statistics to Statsd backend
* Offers legacy SSL connections on different ports - forwarded via HaProxy
* Makes use of [Prosody Filer](https://github.com/ThomasLeister/prosody-filer) for file uploads
* Uses web register template in register-template directory

**!!! This example configuration needs careful customization and cannot be used as-is !!!**


