# Note

⚠️ **Project Status: No Longer Maintained**

This repository is no longer maintained.
The code is preserved here for archival and reference purposes only.

No features or bug fixes will be added.

Issues and pull requests may not receive responses.

Feel free to fork the project if you’d like to continue development.

Thank you to everyone who has used or contributed to this project!


# DuckRails [![GitHub version](https://badge.fury.io/gh/iridakos%2Fduckrails.svg?a=5)](https://badge.fury.io/gh/iridakos%2Fduckrails?a=5) [![Build Status](https://travis-ci.org/iridakos/duckrails.svg?branch=master)](https://travis-ci.org/iridakos/duckrails)

DuckRails is a development tool.

Its main purpose is to allow developers to quickly mock API endpoints that for many possible reasons they can't reach at a specific time.

> If it looks like a duck, walks like a duck and quacks like a duck, then it's a duck :duck:

![Home Page](https://github.com/iridakos/duckrails/blob/master/documentation/readme/resources/duckrails-home-page.png?raw=true)

## How it works

The application allows creating new routes dynamically to which developers can assign static or dynamic responses:

- body
- headers
- content type
- status code

or even cause delays, timeouts etc.

### Guides

The repository's [wiki pages](https://github.com/iridakos/duckrails/wiki) contain all you need to know.
* [What is DuckRails?](https://github.com/iridakos/duckrails/wiki/What-is-DuckRails%3F)
* [Setting up the application](https://github.com/iridakos/duckrails/wiki/Setting-up-the-application)
  * [natively](https://github.com/iridakos/duckrails/wiki/Setup-DuckRails-natively)
  * [via docker](https://github.com/iridakos/duckrails/wiki/Setup-DuckRails-via-Docker)
* [Using DuckRails](https://github.com/iridakos/duckrails/wiki/Using-DuckRails)
  * [The mock form](https://github.com/iridakos/duckrails/wiki/Using-the-mock-form)
  * [The mock index page](https://github.com/iridakos/duckrails/wiki/Using-the-mock-index-page)
* [Creating mocks](https://github.com/iridakos/duckrails/wiki/Creating-mocks)
  * [Route paths with variables](https://github.com/iridakos/duckrails/wiki/Route-paths-with-variables)
  * [Static mock](https://github.com/iridakos/duckrails/wiki/Creating-a-simple-static-mock)
  * [Dynamic mock with embedded Ruby](https://github.com/iridakos/duckrails/wiki/Creating-a-dynamic-mock-with-embedded-ruby)
  * [Dynamic mock with JavaScript](https://github.com/iridakos/duckrails/wiki/Creating-a-dynamic-mock-with-Javascript)
  * [Mock wrapping an existing API call](https://github.com/iridakos/duckrails/wiki/Creating-a-dynamic-mock-that-wraps-an-existing-API-call)
  * [Advanced mock (WIP)](https://github.com/iridakos/duckrails/wiki/Creating-an-advanced-mock)

You can find the old DuckRails' guides [at my blog](http://iridakos.com/2016/04/01/duckrails-guide.html).

### Example

Mocks index page

![Mocks index page](https://github.com/iridakos/duckrails/blob/master/documentation/readme/resources/duckrails-mock-index-page.png?raw=true)

Changing mocks order

![Change mocks order](https://github.com/iridakos/duckrails/blob/master/documentation/readme/resources/duckrails-change-mock-order.png?raw=true)

Setting general mock properties

![General mock properties](https://github.com/iridakos/duckrails/blob/master/documentation/readme/resources/duckrails-mock-general-tab.png?raw=true)

Defining the response body

![Defining the response body](https://github.com/iridakos/duckrails/blob/master/documentation/readme/resources/duckrails-mock-response-body-tab.png?raw=true)

Setting response headers

![Setting response headers](https://github.com/iridakos/duckrails/blob/master/documentation/readme/resources/duckrails-mock-headers-tab.png?raw=true)

Setting some advanced configuration (delays, dynamic headers, content type & status)

![Advanced configuration](https://github.com/iridakos/duckrails/blob/master/documentation/readme/resources/duckrails-mock-advanced.png?raw=true)

Upon save the route becomes available to the application and you can use the endpoint:

![Request](http://i.imgur.com/NaCIqs9.png)
![Headers](http://i.imgur.com/1jZciKH.png)

## Supported response functionality

You can define static or dynamic responses for a mock.

Currently supported dynamic types are:

- Embedded Ruby
- JavaScript

### Embedded Ruby

When specifying dynamic content of embedded Ruby (more options to be added), you can read as local variables:

- `@parameters`: The parameters of the request
- `@request`: The request
- `@response`: The response

### JavaScript

When specifying dynamic content of JavaScript type, you can read as local variables:

- `parameters`: The parameters of the request
- `headers`: The request headers

The script should always return a string (for JSON use `JSON.stringify(your_variable)`)

### Route paths

You can specify routes and access their parts in the *@parameters* variable, for example:

`/authors/:author_id/posts/:post_id`

give you access to the parameters with:

`@parameters[:author_id]`

`@parameters[:post_id]`

## Quick setup (development environment)

* Clone the repository.
* Copy the sample database configuration file (`config/database.yml.sample`) under `config/database.yml` and edit it to reflect your preferred db configuration (defaults to sqlite3). If you change the database adapter, make sure you include the appropriate gem in your `Gemfile` (ex. for mysql `gem 'mysql2'`)
* Execute `bundle install` to install the required gems.
* Execute `rake db:setup` to setup the database.
* Execute `rails server` to start the application on the default port.
* Duckrails can be run concurrently and in parallelism, thus instead of the default rails server, you may start the [puma](https://github.com/puma/puma) server with something like: `bundle exec puma -t 8:16 -w 3`

## Better setup (production environment)
* Clone the repository.
* Copy the sample database configuration file (`config/database.yml.sample`) under `config/database.yml` and edit it to reflect your preferred db configuration (defaults to sqlite3). If you change the database adapter, make sure you include the appropriate gem in your `Gemfile` (ex. for mysql `gem 'mysql2'`)
* Execute `bundle install` to install the required gems.
* Export an env variable for your [secret key base](http://stackoverflow.com/questions/23726110/missing-production-secret-key-base-in-rails): `export SECRET_KEY_BASE="your_secret_key_base_here"`
* Execute `RAILS_ENV=production rake db:setup` to setup the database.
* Execute `RAILS_ENV=production rake assets:precompile` to generate the assets.
* Execute `bundle exec rails s -e production` to start the application on the default port.
* Duckrails can be run concurrently and in parallelism, thus instead of the default rails server, you may start the [puma](https://github.com/puma/puma) server with something like: `RAILS_ENV=production bundle exec puma -t 8:16 -w 3`

## Database configuration

The application is by default configured to use sqlite3. If you want to use another configuration, update the `config/database.yml` accordingly to match your setup.

## Docker

A docker image is available at docker hub under [iridakos/duckrails](https://hub.docker.com/r/iridakos/duckrails/).

To obtain the image use:

`docker pull iridakos/duckrails`

To start the application and bind it to a port (ex. 4000) use:

`docker run -p 4000:80 iridakos/duckrails:latest`

## Contributing

1. Fork it ( https://github.com/iridakos/duckrails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

This application is open source under the [MIT License](https://opensource.org/licenses/MIT) terms.
