class CreateTodoListView < ActiveRecord::Migration
    def self.up
      sql = <<-EOS
CREATE VIEW todolist
        (
        tablename,
        id,
        description,
        state,
        reason
        )
        AS
        select 
          'clients' AS tablename,
          clients.client_id AS id,
          clients.client_name AS description,
          clients.state AS state,
          clients.reason AS reason 
        from clients 
        where
          (clients.state <> 0) 
        union
        select 
          'markets' AS tablename,
          markets.market_id AS id,
          markets.market_friendly_name AS description,
          markets.state AS state,
          markets.reason AS reason 
        from markets 
        where
          (markets.state <> 0) 
        union
        select 
          'plantypefunds' AS tablename,
          plantypefunds.fund_id AS id,
          plantypefunds.fund_name AS description,
          plantypefunds.state AS state,
          plantypefunds.reason AS reason 
        from plantypefunds 
        where
          (plantypefunds.state <> 0) 
        union
        select 
          'plantypes' AS tablename,
          plantypes.plantype_id AS id,
          plantypes.plantype_name AS description,
          plantypes.state AS state,
          plantypes.reason AS reason 
        from plantypes 
        where
          (plantypes.state <> 0) 
        union
        select 
          'policies' AS tablename,
          policies.policy_id AS id,
          policies.policy_number AS description,
          policies.state AS state,
          policies.reason AS reason 
        from policies 
        where
          (policies.state <> 0) 
        union
        select 
          'policyfunds' AS tablename,
          policyfunds.policyfund_id AS id,
          concat(policyfunds.policy_id,':',policyfunds.fund_id) AS description,
          policyfunds.state AS state,
          policyfunds.reason AS reason 
        from policyfunds 
        where
          (policyfunds.state <> 0);
      EOS
    
      execute sql
    end
 
    def self.down
      sql = "DROP VIEW todolist"
      execute sql
    end
  end
