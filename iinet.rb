#!/usr/bin/env ruby

# <bitbar.title>IINet Usage</bitbar.title>
# <bitbar.version>v0.0.1</bitbar.version>
# <bitbar.author>Ash McKenzie</bitbar.author>
# <bitbar.dependencies>ruby</bitbar.dependencies>

require 'json'
require 'net/http'

class IINetUsage
  INTERNET_LOGO = "📡"
  IINET_LOGO = ""
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

    def percent_remaining
      @percent_remaining ||= '%d' % json['percent_remaining']
    end

    def status
      # '%s%%|image=%s' % [ percent_remaining, IINET_LOGO ]
      '%s%s%%' % [ INTERNET_LOGO, percent_remaining ]
    end

end

IINetUsage.new.update!
