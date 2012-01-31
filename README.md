# Puppet module for puppet

Installs puppet from rubygems. Assumes a system on which:

* rubygems is present,
* other accommodations are present for serving puppet master in a
  production-ready mode and
* does _not_ setup any daemons by default.

Provides a puppet master setup through `puppet::master`, which requires
[puppet-module-supervisor](https://github.com/blt/puppet-module-supervisor) and
[puppet-nginx](https://github.com/blt/puppet-nginx) to be present in modules
namespace.

For more details read the series that spawned this module:
[Wrangling Servers](http://blog.troutwine.us/2012/01/22/wrangling_servers_introduction_and_preliminaries.html).

## Quickstart

Install puppet-puppet into your modules (do this from the root of your versioned
puppet configuration):

    $ git submodule add git://github.com/blt/puppet-puppet.git modules/puppet

If you need only clients, that and this are sufficient:

    node default {
        include puppet
    }

Else, if you must run puppet master,

    $ git submodule add git://github.com/blt/puppet-nginx.git modules/nginx
    $ git submodule add git://github.com/blt/puppet-module-supervisor.git modules/supervisor

    node puppet {
        include supervisor, puppet::master
    }

