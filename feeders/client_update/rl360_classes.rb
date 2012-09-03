require '../util/wa' 
# 
# Implementation of classed for RL360
#
class DB_Table
  
    class << self     # Add class Variables
      attr_accessor :table, :instances
    end

  #self.table = nil
  #self.instances = []
  
  def upd(atr)
    atr.keys.each {|k| self.instance_variable_set("@#{k}",atr[k])}
  end
  
  def initialize(atr)
    self.upd(atr)
    self.class.instances.push(self)
  end

  def self.load(db)
    begin
      db[self.table].all.each { |atr|  self.new(atr) }
      rescue Exception => e
        raise WaError.new("E-#{self.name}:LoadFail, Load of #{self.name} from #{self.table} Failed...",e) 
    end
  end 
      
  def self.find(hsh={})
    keys = hsh.keys()
    result = nil
    self.instances.each() { |o|
      result = o
      keys.each {|k| 
        v1 = o.instance_variable_get("@#{k}")
        v2 = hsh[k]
        if ( v1 != v2 ) then
          result = nil
          break
        end  
      }
      return result if (result) 
    }
    return nil
  end  
end

class Company < DB_Table
  attr_accessor   :company_id           ,# int AUTO_INCREMENT NOT NULL,
                  :company_name         ,# varchar(45),
                  :company_last_update   # date,
  self.table = :companies
  self.instances = []
  
  def to_s
    "Company::#{@company_id}:(#{@company_name})"
  end
end


class Client < DB_Table
  attr_accessor     :client_id                      ,# int AUTO_INCREMENT NOT NULL COMMENT 'Client Identification number',
                    :client_name                    ,# varchar(45) NOT NULL COMMENT 'Client Name',
                    :full_address                   ,# tinytext COMMENT 'Address as we use it',
                    :client_company_address         ,# tinytext COMMENT 'Address as used by company',
                    :client_company_address_change  ,# int COMMENT 'Company Address has changed, Harmony needs to look at this\r\n',
                    :last_mod                       ,# date,
                    :state                          ,# smallint NOT NULL DEFAULT '0' COMMENT '0-Normal, 1-Error',
                    :reason                          # varchar(255),
  self.table = :clients
  self.instances = []
  
  def to_s
    "Client::#{@client_id}:(#{@client_name})"
  end  

end


class Plantype < DB_Table
  attr_accessor     :plantype_id        ,# int AUTO_INCREMENT NOT NULL,
                    :plantype_name      ,# varchar(20),
                    :company_id         ,# int NOT NULL,
                    :plantype_currency  ,# varchar(3) NOT NULL,
                    :deposit_fund_id     # int,    
                  
  self.table = :plantypes
  self.instances = []

  def to_s
    return "Plantype::#{@plantype_id}:(#{@plantype_name})"
  end

end

class Policy  < DB_Table
  attr_accessor   :policy_id                   ,# int AUTO_INCREMENT NOT NULL,
                  :policy_number               ,# varchar(20) NOT NULL COMMENT 'Company Policy Identifier',
                  :policy_start                ,# date NOT NULL COMMENT 'Begin date of policy',
                  :policy_currency             ,# varchar(3) NOT NULL COMMENT 'Currency of Policy',
                  :client_id                   ,# int NOT NULL COMMENT 'Internal Id of Client',
                  :plantype_id                 ,# int NOT NULL COMMENT 'Internal Id of associated Plantype',
                  :policy_amount_on_deposit    ,# double NOT NULL COMMENT 'policy Value held in deposit',
                  :strategy_id                 ,# int COMMENT 'Internal Id of associated Strategy',
                  :policy_no_markets_invested  ,# int COMMENT 'No of Markets we are \\\'In\\\'\', count non deposit funds with values, needs to be cross checked with NoMarkletsIN from strategy table every Friday\r\n',
                  :policy_value                ,# double COMMENT 'total value of Policy',
                  :policy_single_premium       ,# int,
                  :policy_total_invested       ,# double,
                  :policy_missing               # int NOT NULL DEFAULT '0' COMMENT 'Policy was included in last CVS Client Update',
  self.table = :policies
  self.instances = []
  
  def to_s
    return "Policy::#{@policy_id}:(#{@policy_number})"
  end  
  
end

class Plantypefund < DB_Table
  attr_accessor   :fund_id          ,# int AUTO_INCREMENT NOT NULL,
                  :fund_name        ,# varchar(100),
                  :fund_identifier  ,# varchar(20),
                  :market_id        ,# int,
                  :fund_currency    ,# varchar(3),
                  :fund_fkey        ,# varchar(20),
                  :fund_type        ,# varchar(20),
                  :company_id       ,# int,
                  :plantype_id      ,# int NOT NULL,
                  :fund_isin        ,# varchar(45),
                  :last_mod         ,# timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                  :state            ,# smallint NOT NULL DEFAULT '0' COMMENT '0-Okay, 1-Error',
                  :reason            # varchar(255), 
  self.table = :plantypefunds
  self.instances = []
  
  def to_s
    return "Plantypefund::#{fund_identifier}:(#{fund_name})"
  end
end


class Policyfund < DB_Table
  attr_accessor     :policyfund_id     ,# int AUTO_INCREMENT NOT NULL,
                    :policy_id         ,# int,
                    :fund_id           ,# int,
                    :policyfund_value  # double COMMENT 'Value of funds held for this policy',
  self.table = :policyfunds
  self.instances = []
  
  def to_s
    return "PolicyFund::#{@policyfund_id}:(P=#{@policy_id},F=#{@fund_id})"
  end  

  def self.get_policy_value(policy_id)
    sum = 0
    self.instances.each() { |o|
      raise WaError.new("E-PolicyFund:NoPolicyValue, #{o.to_s} has Null policyfund_value") unless (o.policyfund_value)
      sum = sum + o.policyfund_value if (o.policy_id == policy_id)
    } 
    return sum
  end
    
end
