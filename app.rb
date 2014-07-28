require 'webmachine'
require 'webmachine/adapters/rack'
require 'json'
require 'global'

require_relative 'lib/reforms_server'
require_relative 'lib/bills_server'

class JsonResource < Webmachine::Resource
  def content_types_provided
    [ ["application/json", :to_json],
      ["application/vnd.api+json", :to_json] ]
  end

  def content_types_accepted
    [["application/vnd.api+json", :from_json]]
  end

  private
  def params
    JSON.parse(request.body.to_s)
  end
end

class ReformResource < JsonResource
  def allowed_methods
    ["GET"]
  end

  def id
    request.path_info[:id]
  end

  def href
    @request.base_uri.to_s + "reforms/" + id
  end

  def resource_exists?
    response = ReformsServer.instance.read(id)

    if response.code == "200"
      doc = JSON.parse(response.body)

      @resource = [
        {
          :id => id,
          :href => href,
          :title => doc['title'],
          :description => doc['description']
        }
      ]

      if doc.has_key?("bills") and not doc["bills"].to_a.empty?
        legislator_ids = BillsServer.instance.sponsors(doc["bills"])
        unless legislator_ids.nil?
          @resource[0][:links] = {"legislators" => legislator_ids}
        end
      end

      true
    else
      false
    end
  end

  def to_json
    {
      :links => {
        "reforms.legislators" => "http://reform.to/#/legislators/{reforms.legislators}"
      },
      :reforms => @resource
    }.to_json
  end
end

class ReformsResource < JsonResource
  def allowed_methods
    ["GET"]
  end

  def href
    @request.base_uri.to_s + "reforms"
  end

  def resource_exists?
    response = ReformsServer.instance.read

    docs = JSON.parse(response.body)
    @resource = docs['rows'].map do |row|
      doc = row['doc']
      id = doc['_id']
      {
        :id => id,
        :href => "#{href}/#{id}",
        :title => doc['title']
      }
    end
    true
  end

  def to_json
    {
      :reforms => @resource
    }.to_json
  end
end

App = Webmachine::Application.new do |app|
  app.configure do |config|
    config.adapter = :Rack
  end
  app.routes do
    add ["reforms"], ReformsResource
    add ["reforms", :id], ReformResource
    #add ['trace', '*'], Webmachine::Trace::TraceResource
  end
end
