# CONFIG = YAML.load_file("#{Rails.root.to_s}/config/initialize_duo_credentials.yml")[Rails.env]
DUO = YAML.load_file(Rails.root.join('config/duo_cred.yml'))