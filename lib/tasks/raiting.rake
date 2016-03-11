# -*- coding: utf-8 -*-
namespace :raiting do
  require 'open-uri'

  def get_and_parse(input, output, &block)
    return unless input
    doc = Nokogiri::XML(input, nil, 'UTF-8')
    data = yield doc
    File.open(output, 'w' ) do |out|
      out.write YAML.dump(data)
    end
    Rails.cache.clear
  end

#------------------------------------------------------
  desc "Load tournament rating, parse and store table"
  task :refresh => :environment do
    url = Chunk.find_by_code('tournament-uri').content # 'http://stat2clubs.khl.ru/193/269/league-269.xml'
    return unless url
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
    Rails.cache.clear
    puts 'DONE'
  end

#------------------------------------------------------
  def teams_of(game)    
    teama = {
      'id'=> game['teama'].to_i,
      'name'=> game['homeName'],
      'city'=> game['homeCity'],
      'wins'=> 0
    }    
    teamb = {
      'id'=> game['teamb'].to_i,
      'name'=> game['visitorName'],
      'city'=> game['visitorCity'],
      'wins'=> 0
    }
    score = game['score'] ? game['score'].split(':').map(&:to_i) : false
    scores = {
      'a'=> {
        'score'=> score ? score[0] : 0,
        'win'=> (score && score[0] > score[1]) ? 1 : 0
      },
      'b'=> {
        'score'=> score ? score[1] : 0,
        'win'=> (score && score[1] > score[0]) ? 1 : 0        
      }
    }    
    if teamb['id'] < teama['id']
      teama, teamb = teamb, teama 
      scores['a'], scores['b'] = scores['b'], scores['a']
    end  
    {
      key: teama['id'],
      a: teama,
      b: teamb,
      score: scores
    }
  end
#------------------------------------------------------
  task :playoff => :environment do
    url = Chunk.find_by_code('playoff-uri').content 
    return unless url
    input = open(url) # File.open(Rails.root.join('db', 'schedule-312.xml').to_s)
    output = Rails.application.config.playoff_path 
    get_and_parse input, output do |doc|      
      data = {}
      doc.xpath('//Game').each do |game|
        round = game['round'].to_i
        data[round] ||= {'name' => '', 'teams' => {}}
        data[round]['name'] = game['roundname']
        teams = teams_of(game)        
        data[round]['teams'][teams[:key]] ||= {'a' => teams[:a], 'b' => teams[:b]}
        data[round]['teams'][teams[:key]]['a']['wins'] += teams[:score]['a']['win']
        data[round]['teams'][teams[:key]]['b']['wins'] += teams[:score]['b']['win']
        data[round]['teams'][teams[:key]]['games'] ||= {}
        data[round]['teams'][teams[:key]]['games'][game['id'].to_i] = teams[:score]        
      end
      Hash[data.to_a.reverse]
    end
  end

#------------------------------------------------------
  desc "Tasting rake tasks"
  task :test =>  :environment do
    puts 'OK'
  end

end
