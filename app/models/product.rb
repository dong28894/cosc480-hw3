class Product < ActiveRecord::Base
    has_attached_file :image, :styles=> {:medium => "300x300>", :thumb => "100x100>"}, :default_url => "/images/noimg.jpg"
    validates_attachment :image, :content_type => {:content_type => ["image/jpeg", "image/png", "image/gif"]}

    def age_range
        if self.minimum_age_appropriate == nil && self.maximum_age_appropriate == nil
            return '0 and above'
        elsif self.minimum_age_appropriate != nil && self.maximum_age_appropriate == nil
            return self.minimum_age_appropriate.to_s << " and above"
        else
            if self.minimum_age_appropriate == self.maximum_age_appropriate
                return "Age " << self.minimum_age_appropriate.to_s
            else
                return self.minimum_age_appropriate.to_s << " to " <<\
                self.maximum_age_appropriate.to_s
            end
        end
    end

    def age_appropriate?(age)
        if self.minimum_age_appropriate == nil 
            return true
        elsif self.maximum_age_appropriate == nil
            return age >= self.minimum_age_appropriate
        else
            return (age >= self.minimum_age_appropriate \
                    && age <= self.maximum_age_appropriate)
        end
    end

    def self.sorted_by(field)
        if !self.column_names.include?(field) 
            field = 'name' 
        end
        return self.order(field)
    end

    def self.filter(hash)
        # Only support min age and max price at the moment
        list = self.sorted_by(hash[:sorted_by])
        result = []
        if hash[:max_price]
            list = list.where("price <= ?", hash[:max_price])
        end
       
        #debugger 
        if hash[:min_age] != nil
            list.each do |product|
                if product.age_appropriate?(hash[:min_age])
                    result << product
                end
            end
        else
            result = list
        end
        

        return result
    end


end
