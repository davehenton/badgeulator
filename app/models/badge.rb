class Badge < ActiveRecord::Base
  validates :name, presence: true
  validates :department, presence: true
  validates :title, presence: true
  validates :employee_id, presence: true

  def self.lookup_employee(attribute, value)
    info = {}

    if ENV["USE_LDAP"] == "true"
      Rails.logger.debug("using ldap employee lookup")
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
          Rails.logger.debug("#{results.size} results found")        
        if results.size == 1
          results = results.first
          info = {
            name: results.givenname.first + " " + results.sn.first,
            department: results.department.first,
            title: results.title.first,
            employee_id: results.employeeid.first,
          }
        end
      end
    else
      Rails.logger.debug("no employee lookup defined")
    end
    
    info
  end

end
