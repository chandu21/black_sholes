class Option < ActiveRecord::Base
  attr_accessible :price, :strike, :term, :volatility, :dividend, :riskfree, :user_id, :title ,:call_price ,:put_price
  validates_presence_of :price, :strike, :term, :volatility, :dividend, :riskfree, :title
  validates_numericality_of :price, :strike, :term, :volatility, :dividend, :riskfree
  belongs_to :user
  
  def self.black_scholes_call_price(price,strike,riskfree,dividend,term,volatility)
    time_sqrt = Math.sqrt(term)
    d1 = (Math.log(price/strike)+((riskfree/100)-(dividend/100)+(((volatility/100)**2)/2))*term)/((volatility/100)*Math.sqrt(term))
    nd1 = Statistics2.normaldist(d1)
    d2 = d1 - (volatility/100)*term**0.5
    nd2 = Statistics2.normaldist(d2)
    call = (Math.exp((0-(dividend/100))*term)*price*nd1)-strike*(Math.exp((-(riskfree/100))*term))*nd2
    put  = (strike*(Math.exp(-riskfree*time_sqrt)*nd2 - price*nd1))
    return call,put
  end
  
end
