# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120901232944) do

  create_table "clients", :primary_key => "client_id", :force => true do |t|
    t.string   "client_name"
    t.string   "full_address"
    t.string   "client_company_address"
    t.integer  "client_company_address_change"
    t.date     "last_mod"
    t.integer  "state"
    t.string   "reason"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "companies", :primary_key => "company_id", :force => true do |t|
    t.string   "company_name"
    t.date     "company_last_update"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "currencies", :primary_key => "currency_id", :force => true do |t|
    t.string   "currency_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "markets", :primary_key => "market_id", :force => true do |t|
    t.string   "market_name"
    t.string   "query_name"
    t.string   "query_section"
    t.string   "market_msci_name"
    t.integer  "msci_index_code"
    t.integer  "market_in"
    t.date     "market_current_date"
    t.decimal  "market_current_price",        :precision => 10, :scale => 0
    t.decimal  "market_dailychange",          :precision => 10, :scale => 0
    t.date     "market_reference_date"
    t.decimal  "market_reference_price",      :precision => 10, :scale => 0
    t.decimal  "market_change_from_ref",      :precision => 10, :scale => 0
    t.decimal  "market_change_from_switch",   :precision => 10, :scale => 0
    t.integer  "market_override"
    t.string   "market_switch"
    t.date     "market_last_switch_date"
    t.decimal  "market_last_switch_price",    :precision => 10, :scale => 0
    t.date     "market_current_process_date"
    t.integer  "state"
    t.string   "reason"
    t.string   "market_currency"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "plantype_strategies", :primary_key => "plantype_strategy", :force => true do |t|
    t.integer  "plantype_id"
    t.integer  "strategy_id"
    t.integer  "plantypestrategyFund_id"
    t.integer  "deposit_fund_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "plantypefunds", :primary_key => "fund_id", :force => true do |t|
    t.string   "fund_name"
    t.string   "fund_identifier"
    t.integer  "market_id"
    t.string   "fund_currency"
    t.string   "fund_fkey"
    t.string   "fund_type"
    t.integer  "company_id"
    t.integer  "plantype_id"
    t.string   "fund_isin"
    t.string   "reason"
    t.integer  "state"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "plantypes", :primary_key => "plantype_id", :force => true do |t|
    t.string   "plantype_name"
    t.integer  "company_id"
    t.string   "plantype_currency"
    t.integer  "deposit_fund_id"
    t.date     "last_mod"
    t.integer  "state"
    t.string   "reason"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "plantypestrategyfunds", :primary_key => "plantypestrategyfund_id", :force => true do |t|
    t.integer  "plantypestrategy_id"
    t.integer  "plantypefund_id"
    t.integer  "deposit_plantype_fund_id"
    t.integer  "market_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "policies", :primary_key => "policy_id", :force => true do |t|
    t.string   "policy_number"
    t.date     "policy_start"
    t.string   "policy_currency"
    t.integer  "client_id"
    t.integer  "plantype_id"
    t.decimal  "policy_amount_on_deposit",   :precision => 10, :scale => 0
    t.integer  "strategy_id"
    t.integer  "policy_no_markets_invested"
    t.decimal  "policy_value",               :precision => 10, :scale => 0
    t.integer  "policy_single_premium"
    t.decimal  "policy_total_invested",      :precision => 10, :scale => 0
    t.integer  "policy_missing"
    t.date     "last_mod"
    t.integer  "state"
    t.string   "reason"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "policyfunds", :primary_key => "policyfund_id", :force => true do |t|
    t.integer  "policy_id"
    t.integer  "fund_id"
    t.decimal  "policyfund_value", :precision => 10, :scale => 0
    t.date     "last_mod"
    t.integer  "state"
    t.string   "reason"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "strategies", :primary_key => "strategy_id", :force => true do |t|
    t.string   "strategy_name"
    t.integer  "strategy_initial_switch_percentage"
    t.integer  "strategy_filter"
    t.decimal  "strategy_trigger_in",                :precision => 10, :scale => 0
    t.decimal  "strategy_trigger_out",               :precision => 10, :scale => 0
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  create_table "strategies_markets", :primary_key => "strategy_market_id", :force => true do |t|
    t.integer  "strategy_id"
    t.integer  "market_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
