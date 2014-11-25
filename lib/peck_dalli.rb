# returns the proper dalli connection for the current environment
class PeckDalli
  def self.client
    options = { namespace: 'peck', compress: true }

    if Rails.env.production?
      if ENV['MEMCACHEDCLOUD_SERVERS']
        return Dalli::Client.new(ENV['MEMCACHEDCLOUD_SERVERS'], username: ENV['MEMCACHEDCLOUD_USERNAME'],
                                                                password: ENV['MEMCACHEDCLOUD_PASSWORD'],
                                                                namespace: 'peck',
                                                                compress: true)
      else
        # magni only accepts memcached requests on DO private IP address
        return Dalli::Client.new('10.128.132.85:11211', options)
      end
    elsif Rails.env.staging?
      # should be different from production
      return nil # Dalli::Client.new('magni.peckapp.com:11211', options)
    elsif Rails.env.development? || Rails.env.test?
      return Dalli::Client.new('localhost:11211', options)
    end
  end
end
