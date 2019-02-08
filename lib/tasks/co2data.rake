require 'csv'

def write_to_log(message)
  handler = Logger.new(ENV['HOME'] + "/Downloads/co2data_load.log")
  handler.info message
end

def write_to_console(message)
  handler = Logger.new(STDOUT)
  handler.info message
end

namespace :co2data do
  desc "Load CSV of CO2 data."
  task load: :emissions do
    write_to_console DateTime.now.rfc2822 + " CO2 data load completed"
  end

  task emissions: [:periods, :territories, :sector_linking] do
    write_to_console DateTime.now.rfc2822 + " Starting emissions load."
    Emission.transaction do
      CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").with_index do |row, count|
        unless count == 0 # header row
          emissions = []
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
            emissions << emission
          end
          Emission.import(emissions)
          message = "Row #{count} loaded. Added emissions for all years available (#{emissions.count}),"
          message += " territory: #{row[0]}"
          message += " sector: #{row[1]}."
          write_to_log message
        end
      end
    end
    write_to_console DateTime.now.rfc2822 + " Emissions load completed."
  end

  task sector_linking: :sectors do
    write_to_console DateTime.now.rfc2822 + " Starting sector linking."
    CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").with_index do |row, count|
      unless count == 0 || row[2].nil?
        sector = Sector.where(name: row[1]).first
        unless sector.sector.present?
          sector.sector = Sector.where(name: row[2]).first
          if sector.save
            write_to_log " Associated sector " + row[1] + " with mother sector " + row[2] + "."
          end
        end
      end
    end
    write_to_console DateTime.now.rfc2822 + " Sector linking completed."
  end

  task territories: :start do
    write_to_console DateTime.now.rfc2822 + " Starting territories load."
    CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").with_index do |row, count|
      unless count == 0 # header row
        territory = Territory.new(code: row[0])
        if territory.save
          write_to_log " Added territory " + row[0]
        end
      end
    end
    write_to_console DateTime.now.rfc2822 + " Territories load completed."
  end

  task sectors: :start do
    write_to_console DateTime.now.rfc2822 + " Starting sectors load."
    CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").with_index do |row, count|
      unless count == 0
        sector = Sector.new(name: row[1])
        if sector.save
          write_to_log " Added sector " + row[1]
        end
      end
    end
    write_to_console DateTime.now.rfc2822 + " Sectors load completed."
  end

  task periods: :start do
    write_to_console DateTime.now.rfc2822 + " Starting periods load."
    header_row = CSV.foreach(ENV['HOME'] + "/Downloads/emissions.csv").first
    @years = header_row[3..header_row.length-1]
    @years.each do |year|
      period = Period.new
      period.year = year
      if period.save
        write_to_log " Added period " + year + "."
      end
    end
    write_to_console DateTime.now.rfc2822 + " Periods load completed."
  end

  task start: :environment do
    write_to_console " Expecting header row in format Country, Sector, Parent sector, 1850, 1851, ... 2013, 2014 "
    write_to_console DateTime.now.rfc2822 + " Starting CO2 data load, this will take a few minutes, logfile is " + ENV['HOME'] + "/Downloads/co2data_load.log"
  end

  desc "Clean logfile."
  task clean: :environment do
    File.delete(ENV['HOME'] + "/Downloads/co2data_load.log")
  end
end

