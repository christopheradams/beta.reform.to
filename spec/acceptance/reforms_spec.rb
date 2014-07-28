require 'spec_helper'
require 'rspec_api_documentation/dsl'
require 'global'

require_relative '../../lib/reforms_server'

resource "Reforms" do

  before (:all) do
    @id = "test-act"

    @data = {
      :title => "Citizen Involvement in Campaigns Act",
      :description => "Tax credit and deductions for small contributions to political campaigns",
      :sponsor => {
        "full_name" => "Rep. Thomas Petri",
        "url" => "http://petri.house.gov"
      },
      :bills => [ "hr3586-113" ],
      :url => "http://beta.congress.gov/bill/113th/house-bill/3586",
      :category => "legislative",
      :status => "introduced",
      :tags => [
        "tax credit"
      ],
      :parties => [
        "R"
      ]
    }

    response = ReformsServer.instance.create(@id, @data.to_json)
    doc = JSON.parse(response.body)
    @rev = doc['rev'];
  end

  after (:all) do
    ReformsServer.instance.delete(@id, @rev)
  end

  header "Accept", "application/vnd.api+json"
  header "Content-Type", "application/vnd.api+json"

  get "/reforms" do
    example "Getting all reforms" do
      do_request

      expect(response_body).to have_json_path("reforms")

      expect(response_body).to be_json_eql({
        :reforms => [
          {
            :id => @id,
            :href => "http://example.org/reforms/#{@id}",
            :title => @data[:title]
          }
        ]
      }.to_json)

      expect(status).to eq(200)
    end
  end

  get "/reforms/:id" do
    let(:id) { "test-act" }

    example "Getting a single reform" do
      do_request

      expect(response_body).to have_json_path("reforms")
      expect(response_body).to have_json_path("reforms/0/id")
      expect(response_body).to have_json_path("reforms/0/href")

      expect(response_body).to be_json_eql({
        :links => {
          "reforms.legislators" => "http://reform.to/#/legislators/{reforms.legislators}"
        },
        :reforms => [
          {
            :id => @id,
            :href => "http://example.org/reforms/#{@id}",
            :title => @data[:title],
            :description => @data[:description],
            :links => {
              "legislators" => ["P000265"]
            }
          }
        ]
      }.to_json)

      expect(status).to eq(200)
    end
  end
end
