# Redwine profile

Redwine is a Redmine profile holding some enhancements and fixes encountered against the official Redmine release.

## Version

Tests are performed through [redmine_testsuites](https://github.com/maxrossello/redmine_testsuites) including all the plugins it supports.

The plugin version corresponds to minimum version of Redmine required. Look at dedicated branch for each Redmine version.

## Enhancements

### Plugin compatibility checks
Redmine::Plugin is enriched with the `compatible_redmine_plugins` method which extends the capabilities of `requires_redmine_plugin`. It supports optional presence of a plugin dependency, in which case only if a targeted plugin is installed a supported version check is performed.  

The `compatible_redmine_plugins` method can check a dictionary of plugins in one shot.

#### Supported clauses

* `:version`
  an explicit version or array of versions is compatible only
* `:version_or_higher`
  a minimum version is required
* `:version_lower_than`
  a maximum version is required
* `:tilde_greater_than`
  acceptable versions include numbers higher than the specified only for the last digit
* `:required` or `:mandatory`
  a boolean enforcing the required installation of a plugin (default true)

#### Multiple clauses

Multiple conditions can be checked per each dependency plugin in logical and.

#### No load order dependency

Check about any other plugin does not depend on the load order of the same, which is mainly based on the lexicographical order applied to the plugins' name, as long as the compatibility is checked within `Rails.configuration.after_initialize`.

#### Behavior on exceptions

A second optional boolean method parameter can make the check to raise an exception if any plugin dependency is not satisfied, otherwise a warning is simply logged on console. Default: hard fail.

#### Presence of unknown plugins

A third optional boolean method parameter defines if unlisted plugins can be complained for. If set to `true`, then the presence of an unlisted plugin raises an exception. Default: false (ignore unknown plugins).

#### Example

```ruby
plugin = Redmine::Plugin.register :redmine_my_plugin do
  ...
end

# each hash contains conditions in AND; plugin is supported if any hash in array matches 
supported_plugins = {
  redmine_any:               { required: true }, # any version, but required
  redmine_any_too:           { },                # this is also required
  redmine_specific:          { version: '5.1.0' }
  redmine_list:              { version: ['5.1.0', '5.1.1'] }, # explicit set
  redmine_same_minor:        { tilde_greater_than: '5.1.0' },
  redmine_same_major:        { tilde_greater_than: '5.1' },
  redmine_minimum:           { version_or_higher:  '5.1.0' },
  redmine_string:            '5.1.1',            # equivalent to :version_or_higher
  redmine_maximum:           { version_lower_than: '5.2.0' },
  redmine_in_between:        { tilde_greater_than: '5.1.0', 
                               version_lower_than: '5.1.11' },
  redmine_optional:          { version_or_higher:  '5.1.0', mandatory: false }
}

Rails.configuration.after_initialize do
  # raise exception in case. Ignore call if Redwine is not installed
  if plugin.methods.include? :compatible_redmine_plugins
    plugin.compatible_redmine_plugins(supported_plugins, true);
  end
end
```

## Current fixes

* tags for issue priority are created from priority positions rather than enumeration id's. 
  Since enumerations are used for multiple types, the id's are not unique and may change with runtime configuration. Legacy themes cannot therefore style the priority tags in a unique way.
  The issue remains if more priority entries are created runtime. Newer themes adopting the named tags, e.g. _priority-lowest_, are unaffected and are able to style the issues adequately.
* IMAP mail folder check formerly reset the seen flag to available emails.
  Mailer filters may reset the seen flag, but Redmine's IMAP::check works only on emails that are flagged unseen

## Installation

Install this plugin into the Redmine plugins folder.

    cd {redmine root}
    git clone https://github.com/maxrossello/redwine.git plugins/redwine
    bundle install

Finally restart your server.

