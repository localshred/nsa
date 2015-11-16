require "nsa/version"
require "nsa/statsd_informant"

module NSA

  def self.inform_statsd(backend)
    yield ::NSA::StatsdInformant
    ::NSA::StatsdInformant.listen(backend)
  end

end
