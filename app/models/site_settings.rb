require 'yaml'

module SiteSettings

  FILE = "config/local.yml"

  @@settings = File.exists?(FILE) ? YAML.load_file(FILE) : {}

  def self.settings
    Rails.logger.warn("Reading settings: " + @@settings.to_s)
    return @@settings
  end
  def self.settings=(s)
    @@settings = s
  end

  def self.save!
    File.open(FILE, 'w') do |out|
      YAML.dump(@@settings, out)
    end
  end

end





