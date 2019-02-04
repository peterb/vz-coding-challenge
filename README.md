# README

To get the application up and running you'll need to install:

* Ruby 2.3.2
* PostgreSQL
* Bundled gems and their native extensions which compile to binary on your platform.

You'll also have to create a role named after your system username, and a database
for the app owned by that user in PostgreSQL via psql. In order to run the tests,
you will also need to create the test database.

You can run them:

rails test test/integration/interface_to_filterable_charts_test.rb; rails test test/models/sector_test.rb; rails test test/models/emission_test.rb

If set up plainly, you can leave the database.yml file as-is.

Other things that will be covered here soon:

* System dependencies

* Configuration

* Database initialization

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# What this app does and what it will be used for.

The test dataset for this app is 5'000 rows long.

It will be used to import a large dataset (just under 50'000 rows) pertaining 
to Carbon Emissions (CO<sub>2</sub>) by country, sector and region from 1850
until 2014 in a CSV file in an as of yet unknown format and imports it into
Rails models via migrations for further analysis and use in filterable charts.

# App architecture.

There are four objects in the data to be imported via CSV, their relationships
are graphed in object-sketch.jpg.
