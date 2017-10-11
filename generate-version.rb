#!/usr/bin/env ruby
require 'net/http'
require 'json'


major = 1
mood = ARGV.shift || 'lazy'
gh_uri = URI('https://api.github.com/repos/cpps/k2')
gh_json = JSON.parse(Net::HTTP.get(gh_uri))
gh_issues = gh_json['open_issues_count']
gh_social = gh_json['stargazers_count']
word = File.readlines('/usr/share/dict/words').sample.strip
time = Time.now.to_i

version = "v#{major}.#{mood}.#{gh_issues}.#{gh_social}.#{word}.#{time}.7"

puts version

File.open('version', 'w') { |file| file.write(version) }
