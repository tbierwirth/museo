require 'minitest/autorun'
require 'minitest/pride'
require './lib/photograh'

class PhotographTest < Minitest::Test

  def setup
    attributes = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: 4,
      year: 1954
    }
    @photograph = Photograph.new(attributes)
  end

  def test_it_exists
    assert_instance_of Photoraph, @photograh
  end

end
