require 'yaml'

module SiteSettings

  FILE = "config/local.yml"

  @@settings = File.exists?(FILE) ? YAML.load_file(FILE) : {}

  def self.settings
    return @@settings
  end

  def self.save!
    File.open(FILE, 'w') do |out|
      YAML.dump(@@settings, out)
    end
  end

end





