# README

Rails API only backend for scraping and creating a Postgres database of OSCN data. Leverages the [oscn_scraper gem](https://github.com/AyOK-Code/oscn_scraper) to scrape data and return as json.

## Getting started

TODO - Create sample .env file, Instructions for booting up

### Configurations

You can configure the following ENV variables:

#### COUNTIES

Comma separated string of the county names.

**Example**
```
COUNTIES=Tulsa,Oklahoma
```

#### CASE_TYPES_ABBREVIATION

Comma separated string of Case type abbreviations:

**Example**
```
CASE_TYPES_ABBREVIATION=CF,CM,TR,TRI,AM,CPC,DTR # default
```

#### OSCN_THROTTLE

Number of requests to send to OSCN per minute

```
OSCN_THROTTLE=120
```

#### OSCN_CONCURRENCY=10 # default

Number of [threads to run concurrently](https://github.com/mperham/sidekiq/wiki/Advanced-Options#concurrency)


```
OSCN_CONCURRENCY=120 # default
```

#### TODO ENVs

MAX_REQUESTS, MEDIUM_PRIORITY, LOW_PRIORITY, DAYS_AGO, DAYS_AHEAD

### Scraping Methodology

High Priority Cases - Any case that has appear on the docket in the past 7 days will be scraped nightly

Medium Priority Cases - Any open case (`closed_on` = `nil`). Scrapes the oldest first.

Low Priority Cases - Closed cases that likely will not be updated as often.

# DOC Import

To run on Heroku, update the following script with the apropriate month/yearh
`heroku run:detached --size performance-l -a oscn-pd rake "doc:scrape['2023-12']"`


## Roster Tables

Entity resolution is accomplished via the Roster tables.
These are all generated via Postgres materialized views then connected to rails models.
Do not use any ids from these as they can change.
The views are stacked for legibility
**To understand the order of creation and see views in use see scheduler.rb**
**To see the current state of the views themselves the safest place is to inspect the database directly**
It's possible for their to be multiple parties and dlms for the same person, which we attempt to merge using
https://dba.stackexchange.com/questions/157715/grouping-on-any-one-of-multiple-columns-in-postgres

## Users

### User Creation
See the section "Running rails console"
then run:
```ruby
emails = ["developer@9bcorp.com"] # update this
emails.each do |email|
  pass = SecureRandom.urlsafe_base64
  user = User.new({email: email, password: pass, password_confirmation: pass})
  user.otp_required_for_login = true
  user.otp_secret = User.generate_otp_secret # provide this to them
  puts "email: #{email}"
  puts "pass: #{pass}"
  puts "one time code: #{user.otp_secret}"
  user.save!
end
```
The one time code is their code to link up a multi-factor auth app.

# Elastic beanstalk

This application has partial support for Elastic Beanstalk.
## Running rails console on EB
To connect use `eb ssh`
To run rails console login as sudo first `sudo su -`
Cd to rails directory: `cd /var/app/current`
then the normal: `bundle exec rails c`
