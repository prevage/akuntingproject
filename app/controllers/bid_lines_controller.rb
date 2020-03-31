class BidLinesController < ApplicationController
  before_action :authenticate_employee!
  respond_to :json, :html
  def index
  	@lines = BidLine.all

  	respond_with(@lines)
  end

  def show
  	@line = BidLine.where("lines->>'line_number' = ?", params[:id]).first.lines.deep_symbolize_keys!

  	respond_with(@line)
  end
end
