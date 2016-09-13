#!/usr/bin/env ruby

# <bitbar.title>IINet Usage</bitbar.title>
# <bitbar.version>v0.0.1</bitbar.version>
# <bitbar.author>Ash McKenzie</bitbar.author>
# <bitbar.dependencies>ruby</bitbar.dependencies>

require 'json'
require 'net/http'

class IINetUsage
  IMAGE = "📡"
  LINE = '---'
  API_URL = "http://localhost:3000/"

  def update!
    puts status
  end

  private

    def url
      @url ||= URI.parse(API_URL)
    end

    def json
      @json ||= JSON.parse(Net::HTTP.get(url))['internet']
    end

    def percent_used
      @percent_used ||= json['percent_used'].ceil
    end

    def percent_remaining
      @percent_remaining ||= json['percent_remaining'].floor
    end

    def status
      status = []
      status << '%s%s%%' % [ IMAGE, percent_used ]
      status << LINE
      status << 'Used: %s%%' % [ percent_used ]
      status << 'Remaining: %s%%' % [ percent_remaining ]
      status << LINE
    end
end

IINetUsage.new.update!
