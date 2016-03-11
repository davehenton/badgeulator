module LdapHelper
  def with_ldap
    require 'net/ldap'
    ldap_config = YAML.load(ERB.new(File.read(Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
    ldap_config["ssl"] = :simple_tls if ldap_config["ssl"] === true
    ldap_options = {}
    ldap_options[:encryption] = ldap_config["ssl"].to_sym if ldap_config["ssl"]
    ldap_options[:host] = ldap_config["host"]
    ldap_options[:port] = ldap_config["port"]
    ldap_options[:base] = ldap_config["base"]
    ldap_options[:auth] = { method: :simple, username: ldap_config["admin_user"], password: ldap_config["admin_password"] }
    ldap = Net::LDAP.new(ldap_options)
    ldap.open do |ldap|
      yield(ldap)
    end
  end
end
