# returns the proper dalli connection for the current environment
class PeckDalli
  def self.client
    options = { namespace: 'peck', compress: true }

    if Rails.env.production?
      return Dalli::Client.new('magni.peckapp.com:11211', options)
    elsif Rails.env.staging?
      # should be different from production
      return nil # Dalli::Client.new('magni.peckapp.com:11211', options)
    elsif Rails.env.development? or Rails.env.test?
      return Dalli::Client.new('localhost:11211', options)
    end
  end
end
