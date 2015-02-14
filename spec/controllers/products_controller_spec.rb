require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  describe "root route" do
    it "routes to products#index" do
      expect(:get => '/').to route_to(:controller => "products", :action => "index")
    end
  end

  describe "GET #index" do
    it "routes correctly" do
      get :index
      expect(response.status).to eq(200)
    end

    it "renders the index template and sorts by name by default" do
      x, y = Product.create!, Product.create!
      expect(Product).to receive(:sorted_by).with("name") { [x,y] }
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:products)).to match_array([x,y])
    end

    it "calls the model to do the right sorting" do
      x, y = Product.create!(:price=>10.0), Product.create!(:price=>1.0)
      expect(Product).to receive(:sorted_by).with("price") { [y,x] }
      get :index, order: "price"
      expect(response).to render_template(:index)
      expect(assigns(:products)).to match_array([y,x])
    end

    it "handles the situation when the sort order is bogus" do
      x, y = Product.create!(:price=>10.0), Product.create!(:price=>1.0)
      expect(Product).to receive(:sorted_by).with("bogus") { [x,y] }
      get :index, order: "bogus"
      expect(response).to render_template(:index)
      expect(assigns(:products)).to match_array([x,y])
    end
  end

  describe "GET #show" do
    it "routes correctly" do
      expect(Product).to receive(:find).with("1") { p }
      get :show, id: 1
      p = Product.new
      expect(response.status).to eq(200)
    end

    it "renders the show template" do
      expect(Product).to receive(:find).with("1") { p }
      get :show, id: 1
      expect(response).to render_template(:show)
    end
  end

end
