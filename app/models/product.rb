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
        result = self
        if hash[:minimum_age]
            result = result.where("minimum_age_appropriate >= ? OR minimum_age_appropriate == nil", hash[:minimum_age]) 
        end
        if hash[:maximum_price]
            result = result.where("price < ?", hash[:maximum_price])
        end
        return result
    end


end
