require "csv"
require "zlib"
require "stringio"
require "cgi"

module Mkmapi
  class Marketplace < Struct.new(:agent)
    def priceguide(game_id = 1)
      json_data = agent.get("priceguide", { "idGame" => game_id })

      if (json_data && json_data["priceguidefile"])
        data = Base64.decode64(json_data["priceguidefile"])
        gzip = Zlib::GzipReader.new(StringIO.new(data))

        keys = ["id", "average", "low", "trend", "german_low", "suggested", "foil", "foil_low", "foil_trend", "low_ex", "avg1", "avg7", "avg30", "foilavg1", "foilavg7", "foilavg30"]
        skip_first = gzip.readline # Skip the header

        CSV.parse(gzip.read).map do |a|
          item = keys.zip(a.map(&:to_f))
          item[0][1] = item[0][1].to_i

          Hash[item]
        end
      end
    end

    def productlist
      json_data = agent.get("productlist")

      if (json_data && json_data["productsfile"])
        data = Base64.decode64(json_data["productsfile"])
        gzip = Zlib::GzipReader.new(StringIO.new(data))

        keys = ["id", "name", "category_id", "category", "expansion_id", "date_added"]
        skip_first = gzip.readline # Skip the header

        CSV.parse(gzip.read).map do |a|
          item = keys.zip(a)
          item[0][1] = item[0][1].to_i
          item[2][1] = item[2][1].to_i
          item[4][1] = item[4][1].to_i
          item[5][1] = item[5][1].to_i
          Hash[item]
        end
      end
    end

    def expansions(game_id = 1)
      agent.get("games/#{game_id}/expansions")["expansion"].
        each { |g| g["id"] = g.delete("idExpansion") }
    end

    def singles(expansion_id = 1)
      agent.get("expansions/#{expansion_id}/singles")
    end

    def games
      agent.get("games")["game"].
        each { |g| g["id"] = g.delete("idGame") }
    end

    def product(product_id)
      agent.get("products/#{product_id}")["product"]
    end

    def card_by_name(name, game_id = 1, language_id = 1)
      # Sanitize name: remove special chars, downcase, and properly encode spaces
      sanitized_name = name.gsub(/['"]/, '')  # Remove quotes
                          .strip              # Remove leading/trailing whitespace
                          .downcase           # Convert to lowercase
      encoded_name = CGI.escape(sanitized_name).gsub('+', '%20')
      agent.get("products/#{encoded_name}/#{game_id}/#{language_id}/true")["product"]
    end

    def search(name, game_id = 1, language_id = 1)
      sanitized_name = name.gsub(/['"]/, '')
                          .strip
                          .downcase
      encoded_name = CGI.escape(sanitized_name).gsub('+', '%20')
      agent.get("products/#{encoded_name}/#{game_id}/#{language_id}/false")["product"]
    end
  end
end
