def consolidate_cart(cart)
  # code here
  cart.each_with_object({}) do |items, consol|
    items.each do |item, info|
      if consol.include?(item)
        consol[item][:count] += 1
      else
        consol[item] = info
        consol[item][:count] = 1
      end
    end
  end
end

def apply_coupons(cart, coupons)
  # code here
  cart.each_with_object({}) do |(item, info), applied|
    coupon = coupons.find {|coupon| coupon[:item] == item}
    applied[item] = info
    w_coupon = "#{item} W/COUPON"
    if coupon != nil
      applied[item] = info
      applied[w_coupon] = {price: coupon[:cost], clearance: info[:clearance], count: 0}
      until applied[item][:count] < coupon[:num]
        applied[item][:count] -= coupon[:num]
        applied[w_coupon][:count] += 1
      end
    end
  end
end

def apply_clearance(cart)
  # code here
  cart.each_with_object({}) do |(item, info), applied|
    if info[:clearance]
      info[:price] -= info[:price] * 0.2
      applied[item] = info
    else
      applied[item] = info
    end
  end
end

def checkout(cart, coupons)
  # code here
  shopping = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  shopping.delete_if {|item, info| info[:count] == 0}
  total = 0
  shopping.each do |item, info|
    total += info[:price] * info[:count]
  end
  total > 100 ? (total -= total * 0.1) : total
end
