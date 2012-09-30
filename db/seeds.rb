# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
companies = Company.create([{company_name:'RL360'}])
cid = companies[0].company_id
plantypes = Plantype.create([{plantype_name:'Oracle'                      , company_id: cid, state:0},
                             {plantype_name:'Quantum'                     , company_id: cid, state:0},
                             {plantype_name:'Portfolio Management Service', company_id: cid, state:0}
                           ])
currencies = Currency.create([{currency_name:'USD'},{currency_name:'GBP'},{currency_name:'EUR'}])                           
                           
