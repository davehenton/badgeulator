class Badge < ActiveRecord::Base

  def self.lookup_employee(attribute, value)
    require 'net/ldap'

    ldap_config = YAML.load(ERB.new(File.read(Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
    ldap_config["ssl"] = :simple_tls if ldap_config["ssl"] === true
    ldap_options = {}
    ldap_options[:encryption] = ldap_config["ssl"].to_sym if ldap_config["ssl"]

    ldap = Net::LDAP.new(ldap_options)
    ldap.host = ldap_config["host"]
    ldap.port = ldap_config["port"]
    ldap.base = ldap_config["base"]
    ldap.auth ldap_config["admin_user"], ldap_config["admin_password"] 

    if ldap.bind
      # active_filter = Net::LDAP::Filter.construct("(&
      #     (|(mail=*@kpb.us)(mail=*@borough.kenai.ak.us))
      #     (objectCategory=person)
      #     (objectClass=user)
      #     (givenName=*)
      #     (!(userAccountControl:1.2.840.113556.1.4.803:=2)))")
      results = ldap.search(
        filter: "(#{attribute}=#{value})",      # active_filter, 
        attributes: %w(givenname mail dn sn employeeID manager title department) )
      if results.size == 1
        results.first
      end
    end
  end

end
