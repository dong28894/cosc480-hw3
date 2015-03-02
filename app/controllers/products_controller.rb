class ProductsController < ApplicationController
    def index
        if params[:sorted_by] != nil
            @products = Product.sorted_by(params[:sorted_by])
        else
            @products = Product.sorted_by('name')
        end
    end

    def show
        @product = Product.find(params[:id])        
    end

    def new
    end

    def create
        p = Product.new(create_update_params)
        if p.save
            flash[:notice] = "Product #{p.name} successfully added"
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

    def destroy
        @product = Product.find(params[:id])
        @product.destroy
        flash[:notice] = "Product #{@product.name} deleted."
        redirect_to products_path
    end

private 
    def create_update_params
        params.require(:product).permit(:name, :description, :price, 
                                        :minimum_age_appropriate,  
                                        :maximum_age_appropriate, :image)
    end
end

