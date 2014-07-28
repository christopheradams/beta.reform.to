# Reform.to API

Beta of the Reform.to API.

## Requirements

* Ruby 1.9.3+
* Bundler
* CouchDB

## Installation

Clone the repository, then run:

    bundle install

## Set-up

Create an account at http://sunlightfoundation.com/api/accounts/register/ and apply for an API key.

Create one CouchDB database for development and one for testing. Add a document to your development database for each reform with the following structure:

    {
      "title": "Government By the People Act",
      "description": "Building a Government Of, By and For the People",
      "sponsor": {
        "full_name": "Rep. John Sarbanes",
        "url": "http://sarbanes.house.gov"
      },
      "bills": [
        "hr20-113"
      ],
      "url": "http://ofby.us",
      "category": "legislative",
      "status": "introduced",
      "tags": [
        "matching funds",
        "tax credit",
        "vouchers"
      ],
      "parties": [
        "D"
      ]
    }

The testing database can remain empty.

Copy `config/global/connections.yml.sample` to `config/global/connections.yml` and edit the file with your database credentials and Sunlight API key.

## Usage

To run locally:

    ruby boot.rb

To run in production:

    unicorn -Eproduction -p8080 config.ru

## Testing

Run the command:

    rspec
