require 'singleton'
require 'net/http'
require 'open-uri'

class BillsServer
  include Singleton

  def initialize
    @apikey = Global.connections.sunlight_key
    @endpoint = "http://congress.api.sunlightfoundation.com/bills"
  end

  def sponsors(bills)
    unless bills.to_a.empty?
      bill_ids = URI::encode(bills.join("|"))

      bills_uri = URI("#{@endpoint}?apikey=#{@apikey}&bill_id__in=#{bill_ids}&fields=sponsor_id,cosponsor_ids")
      bills = JSON.parse(Net::HTTP.get(bills_uri))

      sponsors = bills['results'].map do |bill|
        [bill['sponsor_id']].concat(bill['cosponsor_ids'])
      end

      sponsors.flatten.compact
    end
  end
end
