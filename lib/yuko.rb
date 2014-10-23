module Yuko

  class << self
    attr_accessor :conf
  end

  class ConfError < StandardError
    attr_accessor :messages

    def initialize(messages)
      @messages = messages
    end
  end

  class GlobalConf
    attr_accessor :irc, :mal

    def initialize
      @irc = IrcConf.new
      @mal = MyAnimeList::Credentials.new
    end

    def check
      errors = []
      errors << 'Invalid server   (irc)' unless @irc.server.is_a? String
      errors << 'Invalid channel  (irc)' unless @irc.channel.is_a? String
      errors << 'Invalid nickname (irc)' unless @irc.nickname.is_a? String
      errors << 'Invalid username (mal)' unless @mal.username.is_a?(String) || @mal.username.nil?
      errors << 'Invalid password (mal)' unless @mal.password.is_a?(String) || @mal.password.nil?
      raise ConfError, errors if errors.any?
    end
  end

  class IrcConf
    attr_accessor :server, :channel, :nickname, :greeting
  end

  def self.configure
    self.conf ||= GlobalConf.new
    yield(conf)
  end


end
