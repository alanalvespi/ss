# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
companies = Company.create([{company_id: 1, company_name:'RL360'}])
cid = 1

currencies = Currency.create([{currency_id: 1,currency_name:'USD'},
                              {currency_id: 2,currency_name:'GBP'},
                              {currency_id: 3,currency_name:'EUR'}])
                              
                                  
plantypes = Plantype.create([{plantype_name:'Oracle_USD'                      , company_id: cid, plantype_currency: 1, state:0},
                             {plantype_name:'Quantum_USD'                     , company_id: cid, plantype_currency: 1, state:0},
                             {plantype_name:'Portfolio Management Service_USD', company_id: cid, plantype_currency: 1, state:0},
                             {plantype_name:'Oracle_GBP'                      , company_id: cid, plantype_currency: 2, state:0},
                             {plantype_name:'Quantum_GBP'                     , company_id: cid, plantype_currency: 2, state:0},
                             {plantype_name:'Portfolio Management Service_GBP', company_id: cid, plantype_currency: 2, state:0},
                             {plantype_name:'Oracle_EUR'                      , company_id: cid, plantype_currency: 3, state:0},
                             {plantype_name:'Quantum_EUR'                     , company_id: cid, plantype_currency: 3, state:0},
                             {plantype_name:'Portfolio Management Service_EUR', company_id: cid, plantype_currency: 3, state:0}
                           ])
                           
                           
strategies = Strategies.create([{strategy_id:1, strategy_name:'Defensive', strategy_initial_switch_percentage:20, 
            strategy_filter:30, strategy_trigger_in:7.8, strategy_trigger_out:-4.3, created_at:Time.now(),  updated_at:Time.now()
}])                       

                           
