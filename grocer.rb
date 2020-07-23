def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |hash|
    hash.each do |food, info|
      consolidated_cart[food] = info 
      consolidated_cart[food][:count] ||= 0
      consolidated_cart[food][:count] += 1 
    end
  end
  consolidated_cart
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    food = coupon[:item]
    if cart[food] && cart[food][:count] >= coupon[:num]
      if cart["#{food} W/COUPON"]
        cart["#{food} W/COUPON"][:count] += 1 
    else
      cart["#{food} W/COUPON"] = {
        :price => coupon[:cost],
        :clearance => true,
        :count => 1 
      }
      cart["#{food} W/COUPON"][:clearance] = cart[food][:clearance]
    end
    cart[food][:count] -= coupon[:num]
  end
end
cart
end

def apply_clearance(cart)
  cart.each do |food, info|
    if cart[food][:clearance] == true 
      new_price = info[:price] * 0.8
      info[:price] = new_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total_price = 0 
  cart = consolidate_cart(cart)
  coupons_cart = apply_coupons(cart, coupons)
  clearance_cart = apply_clearance(coupons_cart)
  
  clearance_cart.each do |food, info|
    total_price = total_price + (info[:price].to_f * info[:count].to_f)
  end
  
  if total_price > 100 
    total_price = total_price * 0.9
  else
    total_price
  end
  
  total_price
end
