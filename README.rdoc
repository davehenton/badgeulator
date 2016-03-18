{<img src="https://travis-ci.org/KPB-US/badgeulator.svg?branch=master" alt="Build Status" />}[https://travis-ci.org/KPB-US/badgeulator]
{<img src="https://codeclimate.com/github/KPB-US/badgeulator/badges/gpa.svg" />}[https://codeclimate.com/github/KPB-US/badgeulator]
{<img src="https://codeclimate.com/github/KPB-US/badgeulator/badges/coverage.svg" />}[https://codeclimate.com/github/KPB-US/badgeulator/coverage]

== README

- A WORK IN PROGRESS

A system to keep track of and print employee identification cards.  

= FEATURES
- admin and user roles, admin can maintain users and delete data, devise ldap authentication by default
- user-defined badge layouts
- lookup employee data from external source (default is active directory) or simply fill in fields
- updates thumbnailPhoto in active directory
- takes picture via webcam

It does not do any encoding, though adding a barcode would be simple since prawn is used to generate the badge.

= CONFIGURATION
- If using active directory, you'll need to configure the ldap.yml for your connection information.
- Database connection information goes in the database.yml.
- .env (or your environment) needs the following:
  - USE_LDAP=true - to lookup employee information based on the employee id via an LDAP query
  - ALLOW_EDIT=true - to allow employee fields (for the badge) to be edited
- Devise needs to be configured in the initializer
- Errbit (airbrake) needs to be configured in the initializer
- upload your own logo for the badge
- Make sure you have pdftoppm installed.  It's in the poppler-utils apt-get package.  This is used for
converting the pdf to images for previews and does a much crisper job than imagemagick.

= DEPLOYMENT
Deploy with capistrano.  `cap staging deploy`
If you get a weird error from passenger about a binary ruby version, then check to make sure your database.yml and ldap.yml files are set up properly.

If Chrome says that you've disallowed access to your camera, it might be because you need to have SSL enabled for the site and it will only work under a secure connection to the server.

Changing the LDAP query
It currently looks up the employee information based on the employeeId attribute, you could change this to something else in badge_controller#lookup or in the badge model's lookup_employee method if more complex query is needed.

= HOW IT WORKS
Uses the jpeg_camera gem to take a snapshot from the webcam and saves it in the /tmp directory using the name picture_#{number}.jpg where number comes from the employee id/number field in the form.

When prawn generates the pdf of the badge it is stored in the /tmp directory using the name badge_#{number}.pdf

ATTRIBUTION
Badger image taken from photo by (James Perdue)[https://www.flickr.com/photos/rvguy/3860650150], via (CC2 license)[https://creativecommons.org/licenses/by/2.0/].
