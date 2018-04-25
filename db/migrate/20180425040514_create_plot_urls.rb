class CreatePlotUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :plot_urls do |t|
      t.string :title
      t.string :link
      t.string :summary
      t.string :genre
      t.string :cast
      t.string :plot

      t.timestamps
    end
  end
end
