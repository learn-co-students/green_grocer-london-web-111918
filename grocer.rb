require 'pry'

def consolidate_cart(cart)
  cart.each_with_object({}) do |item_hash, result|
		item_hash.each do |food, attributes|
			if result[food]
				attributes[:count] += 1
			else
				attributes[:count] = 1
				result[food] = attributes
			end
      
		end
	end
end

def apply_coupons(cart, coupons)
  new_cart = cart
  coupons.each do |coupon_hash|
    item_name = coupon_hash[:item]
    
    if !cart[item_name].nil? && cart[item_name][:count] >= coupon_hash[:num]
      item_hash = {"#{coupon_hash[:item]} W/COUPON" => {:price => coupon_hash[:cost], :clearance => cart[item_name][:clearance], :count => 1}}
    
    if cart["#{item_name} W/COUPON"].nil?
      cart.merge!(item_hash)
    else 
      cart["#{item_name} W/COUPON"][:count] += 1
    end
    
    cart[item_name][:count] -= coupon_hash[:num]
  end
  end
  return cart
end


def apply_clearance(cart)
  clearance_cart = cart
  cart.each do |item, data_hash|
      if data_hash[:clearance] == true
        discount = (data_hash[:price] * 0.8).round(2)
        data_hash[:price] = discount.to_f
      end
  end
end

def checkout(cart, coupons)
  total = 0
  updated_cart = consolidate_cart(cart)
  updated_cart1 = apply_coupons(updated_cart, coupons)
  updated_cart2 = apply_clearance(updated_cart1)
  
  updated_cart2.each do |name, data_hash|
    total = total + (data_hash[:price].to_f * data_hash[:count].to_f)
  end

  if total > 100
    total = total * 0.9
  end
  
  return total
  
end





