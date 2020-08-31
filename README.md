# Dine-in 🏠

A lightweight development tool similar to Tighten's
[Takeout](https://github.com/tightenco/takeout); same goal, simpler
implementation.

* Lightweight; just one shell script
* Write plugins to add services and functionality
* No dependency on Valet; uses Caddy2 w/SSL
* Works on Mac and Linux

Philosophy

* Use only one instance per service to host all of your projects. Multiple
  versions supported, e.g. MySQL 5.7 + 5.8.
* Use [phpenv](https://github.com/phpenv/phpenv),
  [nvm](https://github.com/nvm-sh/nvm) and so on to manage your language
* Use service plugins to add functionality, e.g. to clear redit cache or create a new
  database (not the server)
* Use host plugins to link and unlink websites. Comes with php and laravel.

**STILL UNDER DEVELOPMENT**

# Install

```
npx degit https://github.com/mblarsen/dinein.git
```

…or just clone there repository.

# Usage

![usage](https://github.com/mblarsen/dinein/blob/master/usage.png)

![demo](https://github.com/mblarsen/dinein/blob/master/demo.gif)

Alias dine for easy usage:

```shell
alias dine="/path/to/dinein/dinein.sh"
```

Commit your `.dinein` file with your project to easily recreate the services on another system.

```shell
dine init
```
