#!/usr/bin/env ruby

require 'bundler/setup'
require 'mongo'
require 'csv'

db = Mongo::Client.new('mongodb://localhost:27017/talk')

CSV.open("talk.csv", 'wb', headers: [:discussion_id, :comment_id, :subject_id, :user_id, :body, :timestamp]) do |csv|
  db['discussions'].find(project_id: BSON::ObjectId("5077375154558fabd7000001")).each do |discussion|
    print '.'

    discussion["comments"].each do |comment|
      next if comment["body"].nil?

      csv << {
        discussion_id: discussion["_id"],
        comment_id: comment["_id"],
        subject_id: discussion["focus"]["_id"],
        user_id: comment["user_id"],
        body: comment["body"],
        timestamp: comment["created_at"]
      }
    end
  end
end
