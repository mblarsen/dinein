# Dine-in 🏠

A lightweight _local_ development tool that helps you manage docker services
and website configurations.

* Lightweight; just a bunch of structured shell scrips
* Hosting and SSL/TLS using Caddy; One server for all of your projects.
* Services provided by docker. One container per service for all of your
  projects by default. But easy to add more instances.  For example, if you
  need to use both MySQL 5.7 and 8.
* Write plugins to add more services. Comes with: mysql, mongo, redis, mailhog.
  A plugin is but a few lines of code that you can mostly copy from docker
  documentation.
* Use service plugins to add functionality, e.g. to clear redit cache or create a new
  database (not the server)
* Use backend plugins to link and unlink websites. Comes with a generic backend
  and a laravel plugin.
* Bring your own language. Use [phpenv](https://github.com/phpenv/phpenv),
  [nvm](https://github.com/nvm-sh/nvm) and so on to manage your language
  enviroment.
* Works on Mac and Linux

# Install

```
npx degit https://github.com/mblarsen/dinein.git
```

…or just clone the repository.

# Usage

![usage](https://github.com/mblarsen/dinein/blob/master/usage.png)

Alias dine for easy usage:

```shell
alias dine="/path/to/dinein/dinein.sh"
```

Initialize your project:

```shell
dine init
```

This creates a `.dinein` file:

```
DINEIN_PROJECT="my-project"
DINEIN_SITE="my-project.test"
DINEIN_SERVICES=(mysql redis mailhog)
```

Commit your `.dinein` file with your project to easily recreate the services on
another system.

Use `dine up` to ensure that your local development enviroment has all of these
service containers configured. The containers will be namespaced `dinein_` to
easily see there state use: `dine ps`.

> Dine-in isn't just for PHP/Larvel, it can be used with any backend as it
really only provides the web-server and the services. You bring your own
language enviroment. Personally, I'm a big fan of phpenv, nvm, and all these
types of tools.

Anyway, in case you have Larvel application first you must link the site using
the 'laravel' backend plugin:

```shell
# Link based on .dinein
dine laravel link
# ... or without
dine laravel my-project my-site.test 127.0.0.1:8000 $(pwd}/public
```

> All the host plugins does is create Caddyfile configurations.

Once you've linked the site you start your application as you normally would:

```
php artisan serve
```

## Multiple instances

You can start multiple instances of the same service, but dine-in has sensible
defaults, so you if you do not need that most commands require no arguments.

```shell
# Creates a container named 'dinein_mysql' from the 'latest' tag on port '3306'
dine mysql add
# Creates a container named 'dinein_mysql57' from the '5.7' tag on port '3307'
dine mysql add mysql57 5.7 3307
```

To stop or remove you refere to them by their name:

```shell
dine mysql stop|remove mysql57
```

Similarly you can link any number of sites, using the hosting plugins.

```shell
# Creates a webserver config for DINEIN_SITE with root $PWD/public and
# reverse_proxy to 127.0.0.1:8000 with a projcet name of DINEIN_PROJECT
# as read from .dinein
dine laravel link
# Creates a webserver config for example-project.com and the name `my-project2`
# and reverse_proxy to 192.168.0.4:3000 and served from the 'static' dir.
dine laravel my-project2 example-project.com 192.168.0.4:3000 $(pwd)/static
```

Note: the 'laravel' backend plugin is just a thin shell on over the generic
backend plugin, called backend, when it comes to liking. Use this plugin if you
are serving anything else.

# Prior art

The tool is similar to Tighten's
[Takeout](https://github.com/tightenco/takeout); that has similar goals.

In fact I decided to clean up the scripts that I've used for years into this
repo after I saw the announcement of Takeout. You may have spotted the pun in
the name.

@egoist had the same idea with his [doko](https://github.com/egoist/doko/)
package. A Go implementation.

