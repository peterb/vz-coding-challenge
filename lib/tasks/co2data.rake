require 'csv'

namespace :co2data do
  desc "Load CSV of CO2 data."
  task load: :emissions do
    puts DateTime.now.rfc2822 + " CO2 data load completed"
    @handler.close
  end

  task emissions: [:periods, :territories, :sector_linking] do
    puts DateTime.now.rfc2822 + " Starting emissions load."
    CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").with_index do |row, count|
      unless count == 0 # header row
        emission = Emission.new
        @years.each do |year|
          column_index = 3 + @years.index(year)
          if row[column_index].to_f.positive?
            emission.credit = row[column_index].to_f
          elsif row[column_index].to_f.negative?
            emission.debit = row[column_index].to_f.abs
          end
          emission.period = Period.where(year: year).first
          emission.territory = Territory.where(code: row[0]).first
          emission.sector = Sector.where(name: row[1]).first
          if emission.save
            @handler.print DateTime.now.rfc2822 + " Added emission " + row[column_index]
            if emission.credit.present?
              @handler.print " credit: #{emission.credit} "
            elsif emission.debit.present?
              @handler.print " debit: #{emission.debit}"
            end
            @handler.print " row #{count} column #{column_index}."
            @handler.write "\n"
          end
        end
      end
    end
    puts DateTime.now.rfc2822 + " Emissions load completed."
  end

  task sector_linking: :sectors do
    puts DateTime.now.rfc2822 + " Starting sector linking."
    CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").with_index do |row, count|
      unless count == 0 || row[2].nil?
        sector = Sector.where(name: row[1]).first
        unless sector.sector.present?
          sector.sector = Sector.where(name: row[2]).first
          if sector.save
            @handler.write DateTime.now.rfc2822 + " associated sector " + row[1] + " with mother sector " + row[2] + "."
            @handler.write "\n"
          end
        end
      end
    end
    puts DateTime.now.rfc2822 + " Sector linking completed."
  end

  task territories: :start do
    puts DateTime.now.rfc2822 + " Starting territories load."
    CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").with_index do |row, count|
      unless count == 0 # header row
        territory = Territory.new(code: row[0])
        if territory.save
          @handler.write DateTime.now.rfc2822 + " Added territory " + row[0]
          @handler.write "\n"
        end
      end
    end
    puts DateTime.now.rfc2822 + " Territories load completed."
  end

  task sectors: :start do
    puts DateTime.now.rfc2822 + " Starting sectors load."
    CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").with_index do |row, count|
      unless count == 0
        sector = Sector.new(name: row[1])
        if sector.save
          @handler.write DateTime.now.rfc2822 + " Added sector " + row[1]
          @handler.write "\n"
        end
      end
    end
    puts DateTime.now.rfc2822 + " Sectors load completed."
  end

  task periods: :start do
    puts DateTime.now.rfc2822 + " Starting periods load."
    header_row = CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").first
    @years = header_row[3..header_row.length-1]
    @years.each do |year|
      period = Period.new
      period.year = year
      if period.save
        @handler.puts DateTime.now.rfc2822 + " Added period " + year + "."
      end
    end
    puts DateTime.now.rfc2822 + " Periods load completed."
  end

  task start: :environment do
    print DateTime.now.rfc2822
    print " Expecting header row in format Country, Sector, Parent sector, 1850, 1851, ... 2013, 2014 "
    print "\n"
    puts DateTime.now.rfc2822 + " Starting CO2 data load, this will take a few minutes, logfile is " + ENV['HOME'] + "/Downloads/co2data_load.log"
    @handler = File.open(ENV['HOME'] + "/Downloads/co2data_load.log", 'w')
  end

  desc "Clean logfile."
  task clean: :environment do
    File.delete(ENV['HOME'] + "/Downloads/co2data_load.log")
  end
end

