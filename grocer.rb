def consolidate_cart(cart)
  array = []
  hash = {}
  cart.each do |item|
    item.each do |key,val|
      if !hash.include?(key)
        hash[key] = val
        hash[key][:count] = 1
      else
        hash[key][:count] +=1
      end
    end
  end
  hash
end

def apply_coupons(cart, coupons)
  hash = cart
  counter = 0
  
  while counter < coupons.length
  item = coupons[counter][:item]
  
    if cart.include?(coupons[counter][:item]) && !hash.key?("#{item} W/COUPON") && hash[item][:count]>= coupons[counter][:num]
        hash["#{item} W/COUPON"] = {price: coupons[counter][:cost],clearance: cart[item][:clearance], count: 0}
      hash["#{item} W/COUPON"][:count] +=1
      hash[item][:count] -= coupons[counter][:num]
      
    elsif hash.key?("#{item} W/COUPON") && hash[item][:count]>= coupons[counter][:num]
    hash["#{item} W/COUPON"][:count] +=1
    hash[item][:count] -= coupons[counter][:num]
    end
    
    counter +=1 
  end
  hash
end

def apply_clearance(cart)
  cart.collect do |key,val|
    if val[:clearance]
      val[:price] = (val[:price] * 0.8).round(2)
    end
  end 
  cart
end

def checkout(cart, coupons)
  total = 0.0
  
  
  if cart.length == 1
    cart = consolidate_cart(cart)
    
    apply_coupons(cart,coupons)
    cart = apply_clearance(cart)
    
  
  else
  cart = consolidate_cart(cart)
  apply_coupons(cart,coupons)
  cart = apply_clearance(cart)
  end
  
  cart.each do |key,val|
      total += val[:price] * val[:count]
      #puts val
      #puts "price: #{val[:price]}"
      #puts "new total: #{total}" 
  end
  
  if total < 100
    return total
  else
    return total*0.9
  end
end
