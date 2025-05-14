# README

Rails API only backend for scraping and creating a Postgres database of OSCN data. Leverages the [oscn_scraper gem](https://github.com/AyOK-Code/oscn_scraper) to scrape data and return as json.

## Getting started

TODO - Create sample .env file, Instructions for booting up

### Configurations

You can configure the following ENV variables:

#### COUNTIES

Comma separated string of the county names. The application uses the several of the DISTRICT COURT REPORTS to determine what cases to update and what new cases have been filed. Therefore, only the following counties are available:

Adair,Canadian,Cleveland,Comanche,Ellis,Garfield,Logan,Oklahoma,Payne,Pushmataha,Roger Mills,Rogers,Tulsa

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

## Manual Scraping/Imports

### DOC

1. Find the date to use for the run by downloading the file to your local (see the quarterly_data.rb importer for 
   location) and looking at the bottom of the sentence extract file for the maxiumum sentencing date. It will be in the 
   format 20250402 and may run into the case number (e.g, 20250402CF-2021-4596). Use that year and month for the folder name.
2. run `rake "doc:scrape['2025-04']"` (replace 2025-04 with the year and month from the last step for the folder name)
3. if there are any failures in validation update the code to address them.
4. If there are no failures run the import command. 
   For best results run this in detached mode on a scaled heroku dyno, e.g., 
   `heroku run:detached -a oscn --size=performance-l rake "doc:import['2025-04']"` (replacing 2025-04 again).
   Use the code provided to tail the logs for monitoring.
4. Run `rake "doc:link"` to link the imported data to other counties.
