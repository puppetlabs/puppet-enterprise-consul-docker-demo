# puppet-motd

Manage 'Message Of The Day' via Puppet

## Usage

```
    class { 'motd': }
```

## Other class parameters
* ensure: present or absent, default: present.
* config_file: string, default: OS specific. Set config_file, if platform is not supported.
* template: string, default: OS specific. Set template, if platform is not supported.
* inline_template: string, default: not set. String with the actual template, overrides *template* param.
