class PlotUrlsController < ApplicationController

  def index
    plot_urls = PlotUrl.all
  end

  def create
    plot_url = PlotUrl.new(url_params)
    plot_url.save
  end

end
