# README

# Setup

To get the application up and running you'll need to install:

* Ruby 2.3.2
* PostgreSQL
* Bundled gems and their native extensions which compile to binary on your platform.

You'll also have to create a role named after your system username, and a database
for the app owned by that user in PostgreSQL via psql. In order to run the tests,
you will also need to create the test database.

# Running Tests

You can run them together:

```bash
rails test
```
Or seperately:

```bash
rails test test/integration/interface_to_filterable_charts_test.rb;
rails test test/models/sector_test.rb;
rails test test/models/emission_test.rb;
rails test test/models/period_test.rb;
rails test test/models/territory_test.rb
```

Fixtures are used and are present for all models.

# Loading Data With Rake

To find out the Rake tasks available which load the CSV file into the database, run:

```bash
rake -T | grep co2
```

To import the data, first drop, create and run migrations as needed:

```bash
rake db:drop
rake db:create
rake db:migrate
```

Then run co2 load:

```bash
rake co2data:load
```

It will log general operation straight to the console, and detailed information
to a logfile in:

```bash
~/Downloads/co2data_load.log
```

The task will take a few hours to complete depending on the hardware its run on
and the size of the co2 csv data file to be loaded which should be placed in:

```bash
~/Downloads/emissions.csv
```

The data loading doesn't use much RAM, about 2MB, but CPU load spikes very quickly
when starting the task. Initial benchmarks on a modern laptop are:

2m row 66 = 1.188s (seconds) per row
4m row 155 = 1.548s per row
12m row 500 = 1.44s per row
27m row 1165 = 1.39s per row

This means the load task for the sample data set would take around 2.1 hours,for
the full data set, 21 hours. Although feasible,this means waiting a couple of days
to load data. Optimizations have been applied to the way in which Emission data
points are created and saved to the database:

By using a single database transaction, benchmark is:

2m row 100, 1.2s per row

Or 1.6 hours, 16 hours for the whole dataset.

By reducing the number of INSERT statements, benchmarks are:

53s row 100 = 0.53s per row

Or 0.71 hours, 7.1 hours for the whole dataset, which means that
data can be reloaded overnight on a single CPU.


# What this app does and what it will be used for.

The test dataset for this app is 5'000 rows long.

It will be used to import a large dataset (just under 50'000 rows) pertaining 
to Carbon Emissions (CO<sub>2</sub>) by country, sector and region from 1850
until 2014 in a CSV file in an as of yet unknown format and imports it into
Rails models via migrations for further analysis and use in filterable charts.

# App architecture.

There are four objects in the data to be imported via CSV, Sector, Emission,
Territory and Period.

Units used for credits and debits are tonnes. Emissions are a liability, so
crediting them increases, and debiting them decreases any agregate.

I've modeled them as an accounting transaction to decrease ambiguity and
safeguard operations surrounding negative or positive numbers as they are
present in data.

The floating point features of Ruby and PostgreSQL, depending on their
respective versions, and model validations, ought to cover the rest of
the data integrity and correctness aspects of storage and computation.

If set up plainly, you can leave the database.yml file as-is.

# Other things that will be covered here soon:

* System dependencies

* Configuration

* Database initialization

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
