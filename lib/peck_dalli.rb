# returns the proper dalli connection for the current environment
class PeckDalli
  def self.client
    options = { namespace: 'peck', compress: true }

    if Rails.env.production?
      # magni only accepts memcahced requests on DO private IP address
      return Dalli::Client.new('10.128.132.85:11211', options)
    elsif Rails.env.staging?
      # should be different from production
      return nil # Dalli::Client.new('magni.peckapp.com:11211', options)
    elsif Rails.env.development? || Rails.env.test?
      return Dalli::Client.new('localhost:11211', options)
    end
  end
end
