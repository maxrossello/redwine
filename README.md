# Redwine profile

Redwine is a Redmine profile holding some enhancements and fixes encountered against the official Redmine release.

## Version

Tests are performed through [redmine_testsuites](https://github.com/maxrossello/redmine_testsuites) including all the plugins it supports.

The plugin version corresponds to minimum version of Redmine required. Look at dedicated branch for each Redmine version.

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

