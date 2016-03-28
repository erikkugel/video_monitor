# video_monitor
Video Monitor is a webcam security monitoring server

## About
Video Monitor will save videos and/or will stream in real time using a WebCam.

## Prerequisites
- Linux OS + Bash ( Should work but untested on BSD, Mac OSX ).
- V4L2 compatible webcam ( Most current webcams: http://www.exploits.org/v4l/ ).
- VLC with x264 encoder and MP4 container support ( or another encoder of your choice ).
- Hardware sufficient for encoding in real time. This of course depends on the resolution of your camera, your processor, your graphic card, your encoder of choice, etc...
- HTTP server with PHP support ( Optional, for serving past recordings via a browser ).

## Installation
### Simply run `install.sh`
### Manual:
- Create a folder for videos.
- Copy the `.php` file(s) to your web root folder.
- Copt tge `.sh` file(s) somewhere in your PATH.
- Create folder(s) for storing videos and/or a log and a pid file.
- Adjust the `.conf` file(s) to reflect your environment.
- Symlink the video folder under you web root as WWW_ROOT/video_monitor.

There is an `uninstall.sh` to undo all of this.

## Running
Simply launch the `video_monitor.sh` script. In BASH, add a `&` or use `^Z` + `bg` to send the process into the background. It should not be affected by a `SIGHUP` signal ( due to an SSH logout, for instance ). To stop the process, issue a `SIGTERM`. Note this will immediatly stop `video_monitor.sh`, but will allow the currently running recording to finish in its fullest. To stop the currently running recording immediatly, another `SIGTERM` needs to be issues to the recording VLC process (This behaviour will be addressed in the future by trapping a different signal on which VLC will be killed as well).

The default username for the HTTP live stream is `monitor`, and the default password is `vidmon`.

## A note about security
The industry standard for securing IoT devices and webcams in perticular had been historically very low. Many security camera technicians are unaware of many of the attack vectors network engeneers learned to address, yet their devices are connected to large internal networks at best, or worst - directly to the internet. video_monitor itself is not meant to resolve this problem, and on its own will not leave you with a secure installation. If you run a publically accessible webserver, and you simply run video_monitor on it as is, anyone will be able to access your videos, and the password with which the streams are protected will be sent in plain text (which is worst than not at all). If this is your setup and you are confortable with this, you can stop reading here. Otherwise, here are a few good practices:

- Do not leave the default username and password.
- Do not run `video_monitor.php` on a network accessible from the internet. Run it in an internall firewalled network instead.
- Do not stream HTTP video over a network accessible from the internet. Stream it over an internall firewalled network instead.
- Block the port on which you stream from outside access by others using a firewall or NAT.
- Reverse proxy `video_monitor.php` over an HTTPS server.
- Reverse proxy the HTTP stream over an HTTPS server, or:
- Switch VLC to stream over HTTPS directly.
- Do not run `video_monitor.sh` as root - VLC will already advise you against this. Running VLC as root might render your system unstable (as your hardware struggles with encoding), fill 100% of your disk-space, over-write something important, and expose your entire OS to any vulnerabilities VLC might have.

## To Do
### ...Lots, in no particular order:
- Refactor PHP code to create dedicated objects per video.
- Get HTML5 video support to work or introduce a JavaScript player.
- Switch from HTTP to HTTPS streaming.
- Support multiple devices simultaneously with one process and one config (seprate config and process needed at the moment per device).
- Visually appealing (preferably responsive) web page.
- Take periodic still images.
- Movement detection.
- Automated webcam settings adjustment.
