# Redwine profile

Redwine is a Redmine profile holding some fixes encountered on the base Redmine.

## Current fixes

* fixing rack gem to v2.0.8 until Redmine code upgrade to support rack v2.1.x
* tags for issue priority are created from priority positions rather than enumeration id's. 
  Since enumerations are used for multiple types, the id's are not unique and may change with runtime configuration. Themes could not therefore style the priority tags in a unique way.
* IMAP mail folder check formerly reset the seen flag to available emails.
  Mailer filters may reset the seen flag, but Redmine's IMAP::check works only on emails that are flagged unseen

## Installation

Install this plugin into the Redmine plugins folder.

    cd {redmine root}
    git clone https://github.com/maxrossello/redwine.git plugins/redwine
    bundle install

Finally restart your server.

