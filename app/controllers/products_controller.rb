class ProductsController < ApplicationController
    def index
        if params[:set_filter] # The filter button was clicked
            if params[:min_age] == ""
                session[:min_age] = nil
            else
                session[:min_age] = params[:min_age].to_i
            end
            if params[:max_price] == ""
                session[:max_price] = nil
            else
                session[:max_price] = params[:max_price].to_f
            end
        end
        
        session[:sorted_by] = params[:sorted_by] unless !params[:sorted_by]
        if (session[:sorted_by] && !params[:sorted_by]) || 
            (session[:min_age] && params[:min_age] == "") ||
            (session[:max_price] && params[:max_price] == "")
            flash.keep
            redirect_to products_path(:sorted_by => session[:sorted_by],
                         :min_age => session[:min_age], 
                         :max_price => session[:max_price])
        end

        @products = Product.filter(session)
        
    end

    def show
        @product = Product.find(params[:id])        
    end

    def new
    end

    def create
        p = Product.new(create_update_params)
        if p.save
            flash[:notice] = "New product #{p.name} created successfully"
            redirect_to products_path
        else
            flash[:warning] = "Product couldn't be created"
            redirect_to new_product_path
        end
    end

    def edit
        @product = Product.find(params[:id])
    end

    def update
        @product = Product.find(params[:id])
        @product.update(create_update_params)
        flash[:notice] = "#{@product.name} was successfully updated."
        redirect_to product_path(@product)
    end

  #   def destroy
  #       @product = Product.find(params[:id])
  #       @product.destroy
  #       flash[:notice] = "Product #{@product.name} deleted."
  #       redirect_to products_path
  #   end

private 
    def create_update_params
        params.require(:product).permit(:name, :description, :price, 
                                        :minimum_age_appropriate,  
                                        :maximum_age_appropriate, :image)
    end
end

