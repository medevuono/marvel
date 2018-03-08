require 'digest/md5'
require 'net/http'
require 'json'


def request(url, params = [])
	public_key = "8959d5fac76462407a4e63a8bf9d20db"
	private_key = "7fd52b515bdc7b3b58c686307738b73e07aa771b"
	timestamp = Time.now.to_i
	hash = Digest::MD5.hexdigest("#{timestamp}#{private_key}#{public_key}")
	default_params = ["ts=#{timestamp}", "apikey=#{public_key}", "hash=#{hash}"]
	default_params.concat params

	uri = URI("#{url}?#{default_params.join('&')}")
	JSON.parse Net::HTTP.get(uri)
end

def list_characters()

	result = request("http://gateway.marvel.com/v1/public/characters")
	characters = result.dig "data","results" 

	puts "Total characters: #{result.dig('data','count')}"
	puts "The character are:"

	characters.each do |character|
		puts "(#{character['id']}) #{character['name']}"
	end
end


def find_characters(query)

	result = request("http://gateway.marvel.com/v1/public/characters", ["nameStartsWith=#{query}"])
	characters = result.dig "data","results"

	characters.each do |character|
		puts "#{character['name']}"
	end
end

def find_characters_by(id)

	result = request("http://gateway.marvel.com/v1/public/characters/#{id}")
	characters = result.dig "data","results"

	character = characters.first
		puts "name: #{character['name']}"
		puts "Description: #{character['description']}"
end

def find_comics_by(id)
	result = request("http://gateway.marvel.com/v1/public/characters/#{id}/comics");
	comics = result.dig("data","results")

	comics.each do |comic|
		puts "title: #{comic['title']}"
		puts "description: #{comic['description']}"
		puts "format: #{comic['format']}"
		puts ""
	end

end

def find_events_by(id)	
	result = request("http://gateway.marvel.com/v1/public/characters/#{id}/events");
	events = result.dig("data","results")

	events.each do |event|
		puts "title: #{event['title']}"
		puts "description: #{event['description']}"
		puts "start: #{event['start']} - ends: #{event['end']}"		
		puts ""
	end
end

def find_series_by(id)
	result = request("http://gateway.marvel.com/v1/public/characters/#{id}/series");
	series = result.dig("data","results")

	series.each do |serie|
		puts "title: #{serie['title']}"
		puts "description: #{serie['description']}"		
		puts "start year: #{serie['startYear']} - end year: #{serie['endYear']}"		
		puts ""
	end
end

# 1010354
#list_characters
#find_characters ARGV.first
#find_characters_by ARGV.first
#find_comics_by ARGV.first
#find_events_by ARGV.first
find_series_by ARGV.first
