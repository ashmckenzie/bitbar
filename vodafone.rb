#!/usr/bin/env ruby

# <bitbar.title>Vodafone Usage</bitbar.title>
# <bitbar.version>v0.0.1</bitbar.version>
# <bitbar.author>Ash McKenzie</bitbar.author>
# <bitbar.dependencies>ruby</bitbar.dependencies>

require 'json'
require 'net/http'

class VodafoneUsage
  IMAGE = "📱"
  LINE = '---'
  API_URL = "https://usage.apps.mine.nu/"
  DIVIDER = 1024

  def update!
    puts status
  end

  private

    def url
      @url ||= URI.parse(API_URL)
    end

    def json
      @json ||= JSON.parse(Net::HTTP.get(url))['data']['mobile']
    end

    def total
      @total ||= json['quota'] / DIVIDER
    end

    def used
      @used ||= json['used'] / DIVIDER
    end

    def remaining
      @remaining ||= json['remaining'] / DIVIDER
    end

    def remaining_per_day
      @remaining_per_day ||= begin
				if days_remaining > 0
					(json['remaining'] / days_remaining) / DIVIDER
				else
					0
				end
			end
    end

    def percent_used
      @percent_used ||= json['percent_used'].ceil
    end

    def percent_remaining
      @percent_remaining ||= json['percent_remaining'].floor
    end

    def days_remaining
      @days_remaining ||= json['days_remaining']
    end

    def status
      status = []
      status << '%s%s%%' % [ IMAGE, percent_used ]
      status << LINE
      status << 'DATA | font=Arial-Bold'
      status << 'total: %s MB' % [ total ]
      status << 'used: %s MB (%s%%)' % [ used, percent_used ]
      status << 'remaining: %s MB (%s%%, %s MB p/day)' % [ remaining, percent_remaining, remaining_per_day ]
      status << LINE
      status << 'DAYS | font=Arial-Bold'
      status << 'remaining: %s' % [ days_remaining ]
      status << LINE
    end
end

VodafoneUsage.new.update!
