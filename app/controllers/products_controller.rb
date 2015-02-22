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
end
