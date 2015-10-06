#!/usr/bin/env ruby
# coding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'ruby-progressbar'
require 'fileutils'
require 'pry'

require_relative 'lib/mico/api/client'

class Downloader
  def initialize
    @submitted = 0
    @finished = 0
    @failed = 0
  end

  def initial_submit(filename, image_url)
    puts "SUBMIT #{image_url}"
    response = Mico::Api::Client::AnimalDetection.submit(image_url)
    write(filename, JSON.dump(response.attributes))
  rescue
    write(filename, JSON.dump({status: "failed", reason: response.attributes}))
  ensure
    @submitted += 1
  end

  def update_or_do_nothing(filename, image_url)
    file_source = File.read(filename)
    data = JSON.load(file_source)
    case data["status"]
    when "submitted"
      puts "UPDATE #{filename}"
      response = Mico::Api::Client::AnimalDetection.new(data["id"]).reload
      if response["status"]=="finished"
        @finished += 1
      elsif response["status"]=="failed"
        @failed += 1
      end
      write(filename, JSON.dump(response.attributes))
    when "finished"
      @finished += 1
      puts "SKIP #{filename}"
    when "failed"
      @failed += 1
    else
      raise "unknown status #{data['status']}"
    end
  end

  def print_status_report
    puts "Submitted: #{@submitted} - Finished: #{@finished} - Failed: #{@failed}"
  end

  private

  def write(filename, string)
    File.open(filename, 'w') { |f| f.puts(string) }
  end
end

if ARGV.length<2
  puts "\nUsage: ruby fetch-jsons.rb <csv file> <naming suffix for this run>\n\n"
else
  csvfile = ARGV[0]
  suffix = ARGV[1] || SecureRandom.uuid

  dirname = "#{suffix}/#{File.basename(csvfile, File.extname(csvfile))}"
  puts "Creating #{dirname}"
  FileUtils.mkdir_p(dirname)

  downloader = Downloader.new
  bar = ProgressBar.create total: `wc -l #{csvfile}`.to_i,
                           format: "%t [%e]: %bᗧ%i %c/%C done",
                           progress_mark: ' ',
                           remainder_mark: '･'


  CSV.foreach(csvfile) do |row|
    filename = "#{row[0]}-#{row[1]}.json"
    xml_filename = File.join(dirname, filename)

    if File.exist?(xml_filename)
      downloader.update_or_do_nothing(xml_filename, row[2])
    else
      downloader.initial_submit(xml_filename, row[2])
    end
    bar.increment
  end

  downloader.print_status_report
end
