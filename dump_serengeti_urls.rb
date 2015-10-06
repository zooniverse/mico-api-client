#!/usr/bin/env ruby

require 'bundler/setup'
require 'mongo'
require 'csv'

db = Mongo::Client.new('mongodb://localhost:27017/serengeti')

CSV.open("serengeti.csv", 'wb') do |csv|
  db['serengeti_subjects'].find.each do |document|
    (document["location"] || {"standard" => []})["standard"].each.with_index do |url, idx|
      print '.'
      csv << [document["zooniverse_id"], idx, url]
    end
  end
end
