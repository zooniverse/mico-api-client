#!/usr/bin/env ruby
# coding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'ruby-progressbar'
require 'fileutils'
require 'pry'

require_relative 'lib/mico/api/client'

class Downloader
  attr_reader :mico

  def initialize
    @mico = Mico::Api::Client.new
  end

  def initial_submit(id, filename, image_url)
    # puts "Submitting #{id}"
    response = mico.submit(id, image_url)

    case response.code
    when 200, 201
      write(filename, response.body)
    when 409, 502
      write(filename, JSON.dump({status: "failed", reason: response.body}))
    else
      binding.pry
      exit 1
    end
  end

  def update_or_do_nothing(id, filename, image_url)
    data = JSON.load(File.read(filename))

    case data["status"]
    when "submitted"
      # puts "CHECK #{filename}"
      response = mico.check(id)
      write(filename, response)
    when "finished", "failed"
      # puts "DONE #{filename}"
    else
      raise "unknown status #{data['status']}"
    end
  end

  private

  def write(filename, string)
    File.open(filename, 'w') { |f| f.puts(string) }
  end
end

csvfile = ARGV[0]
postfix = ARGV[1] || SecureRandom.uuid
dirname = File.basename(csvfile, File.extname(csvfile)) + "-#{postfix}"
puts "Creating #{dirname}"
FileUtils.mkdir_p(dirname)

downloader = Downloader.new
rows = CSV.read(csvfile)
bar = ProgressBar.create total: rows.size,
                         format: "%t [%e]: %bᗧ%i %c/%C done",
                         progress_mark: ' ',
                         remainder_mark: '･'


rows.each.with_index do |row, idx|
  id = "#{dirname}-#{row[0]}-#{row[1]}"
  xml_filename = File.join(dirname, "#{id}.json")

  if File.exist?(xml_filename)
    downloader.update_or_do_nothing(id, xml_filename, row[2])
  else
    downloader.initial_submit(id, xml_filename, row[2])
  end
  bar.increment
end
