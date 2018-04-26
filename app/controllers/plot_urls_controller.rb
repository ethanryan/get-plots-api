class PlotUrlsController < ApplicationController

  def index
    plot_urls = PlotUrl.all
  end

  def create
    plot_url = PlotUrl.new(plot_url_params)
    plot_url.save
    link = plot_url.link
    plot_url.parse_that_ish(link)
    render json: plot_url
  end

  def plot_url_params
    params.require(:plot_url).permit(:title, :link, :summary, :genre, :cast, :plot)
  end

end
