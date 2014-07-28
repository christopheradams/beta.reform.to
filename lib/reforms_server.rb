require 'singleton'
require_relative 'couch'

class ReformsServer
  include Singleton

  def initialize
    host = Global.connections.host
    port = Global.connections.port
    username = Global.connections.username
    password = Global.connections.password

    @server = Couch::Server.new(host, port, username, password)
    @database = Global.connections.database
  end

  def create(id, data)
    @server.put("/#{@database}/#{id}", data)
  end

  def read(id = nil)
    unless id.nil?
      @server.get("/#{@database}/#{id}")
    else
      @server.get("/#{@database}/_all_docs?include_docs=true")
    end
  end

  def delete(id, rev)
    @server.delete("/#{@database}/#{id}?rev=#{rev}")
  end

end
