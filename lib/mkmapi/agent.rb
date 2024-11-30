require "simple_oauth"
require "oj"

module Mkmapi
  class Agent < Struct.new(:connection, :auth)
    attr_reader :last

    def get(path, query_params = {})
      process(:get, path, query_params)
    end

    def put(path, body)
      raise NotImplementedError
    end

    def post(path, body)
      raise NotImplementedError
    end

    def delete(path)
      raise NotImplementedError
    end

    private

    def process(method, path, query_params = {})
      json_path = "output.json/#{path}"
      endpoint = connection.url_prefix.to_s + "/" + json_path

      @last = connection.send(method, json_path, query_params, headers: { authorization: oauth(method, endpoint, {}, query_params) })
      Oj.load(@last.body)
    end

    def oauth(method, url, options = {}, query = {})
      url_with_params = url
      if !query.empty?
        uri = URI(url)
        uri.query = URI.encode_www_form(query)
        url_with_params = uri.to_s
      end
      header = SimpleOAuth::Header.new(method, url_with_params, options, auth)

      signed_attributes = { realm: url }.update(header.signed_attributes)
      attributes = signed_attributes.map { |(k, v)| %(#{k}="#{v}") }

      "OAuth #{attributes * ", "}"
    end
  end
end
