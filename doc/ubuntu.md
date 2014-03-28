## Installing dependencies on Ubuntu/Debian

* Install [RVM](https://rvm.io/) using:
  `sudo \curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enabled --ruby=1.9.3-p286`

* Install Git, Redis and Postgres using:
 `sudo apt-get install git redis postgresql`

* Set Postgres to start on boot:
 `sudo update-rc.d postgresql default`

* Set Redis to start on boot:
 `sudo update-rc.d redis-server`

## [Return to setup](/README.md#get-geefu)
