class PostsController < ApplicationController
  before_action :authenticate_employee!
  before_filter :post, only: [:destroy]

  respond_to  :js