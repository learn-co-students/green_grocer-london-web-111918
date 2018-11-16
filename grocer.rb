require "pry"


def consolidate_cart(cart)
	final_cart = {}
	cart.each do |food|
	  	count = cart.count(food)
	  	final_cart[food.keys[0]] = food.values[0]
	  	final_cart[food.keys[0]][:count] = count
	end
	final_cart
end


def apply_coupons(cart, coupons)
	final_cart = cart.clone
 	cart.each do |food, attributes|
 		coupons.each do |coupon|
 			if food == coupon[:item] && attributes[:count] >= coupon[:num]
 				elegible = attributes[:count] - (attributes[:count] - (coupons.count(coupon) * coupon[:num])).abs
 				new_item = "#{food} W/COUPON"
 				final_cart[new_item] = attributes.clone
 				final_cart[new_item][:count] = elegible / coupon[:num]
 				final_cart[new_item][:price] = coupon[:cost]
 				final_cart[food][:count] -= elegible
 			end
 		end
 	end
 	final_cart
end


def apply_clearance(cart)
  final_cart = cart.clone
  cart.each do |food, attributes|
  	if attributes[:clearance] == true
  		final_cart[food][:price] = (attributes[:price] * 0.8).round(2)
  	end
  end
end


def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each {|food, attributes| total += attributes[:price] * attributes[:count]}
  total = (total * 0.9).round(2) if total > 100.00
  total
end
