# -*- coding: utf-8 -*-
namespace :raiting do
  require 'open-uri'

  desc "Load tournament rating, parse and store table"
  task :refresh => :environment do
    url = 'http://stat2clubs.khl.ru/193/269/league-269.xml'
    data = {}
    doc = Nokogiri::XML(open(url), nil, 'UTF-8')    
    doc.xpath("//Ranking[contains(@type, 'points') and contains(@period, 'game')]/Team").each do |team|
      data[team['rank']] = {
        id: team['id'],
        name: team['name'],
        games: team['gp'],
        points: team['pts']
      }
    end
    File.open(Rails.application.config.raitings_path, 'w' ) do |out|
      out.write YAML.dump(data)
    end
    puts 'DONE'
  end

end
