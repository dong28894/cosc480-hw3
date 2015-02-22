class Product < ActiveRecord::Base
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
end
