# Redwine profile

Redwine is a Redmine profile holding some enhancements and fixes encountered against the official Redmine release.

Tests are performed through [redmine_testsuites](https://github.com/maxrossello/redmine_testsuites) including the plugins it supports.

## Current fixes

* fixing rack gem to v2.0.8 in Gemfile until Redmine code upgrade to support rack v2.1.x. Test _test_download_should_set_sendfile_header_ failing otherwise.
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

