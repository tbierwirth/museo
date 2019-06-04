class Curator
  attr_reader :artists, :photographs

  def initialize()
    @artists = []
    @photographs = []
  end

  def add_photograph(photo)
    @photographs << photo
  end

  def add_artist(artist)
    @artists << artist
  end

  def find_artist_by_id(id)
    @artists.find do |artist|
      artist.id == id
    end
  end

  def find_photo_by_id(id)
    @photographs.find do |photograph|
      photograph.id == id
    end
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all do |photograph|
      artist.id == photograph.artist_id
    end
  end

  def artists_with_multiple_photographs
    ids = @photographs.map do |photograph|
      photograph.artist_id
    end
    multiple = ids.select{|id| ids.count(id) > 1}
    multiple.uniq.map do |id|
      find_artist_by_id(id)
    end
  end

end
