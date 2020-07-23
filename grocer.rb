require "pry"

def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item|
    item.each do |name, values|
      cart_hash[name] = values
      cart_hash[name][:count] = 0
    end
  end
  cart.each do |item|
    item.each do |name, values|
      cart_hash[name][:count] += 1
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  coupon_cart = {}
  count_array = []
  cart.collect do |name, values|
    coupon_cart[name] = values
    coupons.collect do |coupon|
      coupon.collect do |item, info|
        if info == name
          count_array << info
          coupon_cart["#{name} W/COUPON"] = {}
          coupon_cart["#{name} W/COUPON"][:price] = coupon[:cost]
          coupon_cart["#{name} W/COUPON"][:count] = count_array.count(info)
          coupon_cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
          coupon_cart[name][:count] -= coupon[:num]
          if coupon_cart[name][:count] < 0
            count_array.pop
            coupon_cart["#{name} W/COUPON"][:count] = count_array.count(info)
            coupon_cart[name][:count] += coupon[:num]
          end
        end
      end
    end
  end
  coupon_cart
end

def apply_clearance(cart)
  clearance_cart = {}
  cart.each do |name, values|
      clearance_cart[name] = values
        if values[:clearance] == true
          clearance_cart[name][:price] = (clearance_cart[name][:price] * 4) / 5
        end
      end
  clearance_cart
end

def checkout(cart, coupons)
  final_cart = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  total_price = 0
  final_cart.each do |name, values|
    total_price += (values[:price] * values[:count])
  end
  if total_price > 100
    total_price -= (total_price / 10)
  end
  total_price
end
