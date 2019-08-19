module RubyRedtrack
  # basic class to that'll provide access to other API
  class Client
    attr_reader :connection

    def initialize(login: nil, password: nil, token: nil)
      @connection = Connection.new(login, password, token)
    end

    def campaigns
      Campaigns.new(@connection)
    end

    def landers
      Landers.new(@connection)
    end

    def offers
      Offers.new(@connection)
    end

    def traffic_source
      TrafficSource.new(@connection)
    end

    def affiliate_network
      AffiliateNetwork.new(@connection)
    end

    def report(options = {})
      Report.new(options, @connection)
    end

    def miscellaneous
      Miscellaneous.new(@connection)
    end
  end
end
