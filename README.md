# Redwine profile

Redwine is a Redmine profile holding some enhancements and fixes encountered against the official Redmine release.

Tests are performed through [redmine_testsuites](https://github.com/maxrossello/redmine_testsuites) including the plugins it supports.

## Current fixes

* fixing rack gem to v2.0.8 in Gemfile until Redmine code upgrade to support rack v2.1.x. Some tests failing otherwise.
* tags for issue priority are created from priority positions rather than enumeration id's. 
  Since enumerations are used for multiple types, the id's are not unique and may change with runtime configuration. Themes cannot therefore style the priority tags in a unique way.
* IMAP mail folder check formerly reset the seen flag to available emails.
  Mailer filters may reset the seen flag, but Redmine's IMAP::check works only on emails that are flagged unseen

## Installation

Install this plugin into the Redmine plugins folder.

    cd {redmine root}
    git clone https://github.com/maxrossello/redwine.git plugins/redwine
    bundle install

Finally restart your server.

