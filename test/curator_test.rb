require 'minitest/autorun'
require 'minitest/pride'
require './lib/curator'
require './lib/photograph'
require './lib/artist'

class CuratorTest < Minitest::Test

  def setup
    @curator = Curator.new

    photo_1 = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
    }

    photo_2 = {
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
    }
    photo_3 = {
      id: "3",
      name: "Identical Twins, Roselle, New Jersey",
      artist_id: "3",
      year: "1967"
    }

    photo_4 = {
      id: "4",
      name: "Child with Toy Hand Grenade in Central Park",
      artist_id: "3",
      year: "1962"
    }

    artist_1 = {
      id: "1",
      name: "Henri Cartier-Bresson",
      born: "1908",
      died: "2004",
      country: "France"
    }

    artist_2 = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }

    artist_3 = {
      id: "3",
      name: "Diane Arbus",
      born: "1923",
      died: "1971",
      country: "United States"
    }

    @photo_1 = Photograph.new(photo_1)
    @photo_2 = Photograph.new(photo_2)
    @photo_3 = Photograph.new(photo_3)
    @photo_4 = Photograph.new(photo_4)
    @artist_1 = Artist.new(artist_1)
    @artist_2 = Artist.new(artist_2)
    @artist_3 = Artist.new(artist_3)
  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_add_photos
    assert_equal [], @curator.photographs

    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal [@photo_1, @photo_2], @curator.photographs
    assert_equal @photo_1, @curator.photographs.first
    assert_equal "Rue Mouffetard, Paris (Boy with Bottles)", @curator.photographs.first.name
  end

  def test_add_artists
    assert_equal [], @curator.artists

    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_equal [@artist_1, @artist_2], @curator.artists
    assert_equal @artist_1, @curator.artists.first
    assert_equal "Henri Cartier-Bresson", @curator.artists.first.name
  end

  def test_find_by_id
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal @artist_1, @curator.find_artist_by_id("1")
    assert_equal @photo_2, @curator.find_photo_by_id("2")
  end

  def test_find_photographs_by_artist
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)

    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)

    diane_arbus = @curator.find_artist_by_id("3")
    assert_equal [@photo_3, @photo_4], @curator.find_photographs_by_artist(diane_arbus)
  end

  def test_find_artist_with_multiple_photos
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)

    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)

    diane_arbus = @curator.find_artist_by_id("3")

    assert_equal [@artist_3], @curator.artists_with_multiple_photographs
    assert_equal 1, @curator.artists_with_multiple_photographs.length
    assert diane_arbus == @curator.artists_with_multiple_photographs.first
  end

  def test_photographs_taken_by_artist_country
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)

    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)

    assert_equal [@photo_2, @photo_3, @photo_4], @curator.photographs_taken_by_artist_from("United States")
    assert_equal [], @curator.photographs_taken_by_artist_from("Argentina")
  end

  def test_load_photographs_artists
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')

    photo_1 = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
    }

    photo_2 = {
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
    }
    photo_3 = {
      id: "3",
      name: "Identical Twins, Roselle, New Jersey",
      artist_id: "3",
      year: "1967"
    }

    photo_4 = {
      id: "4",
      name: "Child with Toy Hand Grenade in Central Park",
      artist_id: "3",
      year: "1962"
    }
    artist_1 = {
      id: "1",
      name: "Henri Cartier-Bresson",
      born: "1908",
      died: "2004",
      country: "France"
    }

    artist_2 = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }

    artist_3 = {
      id: "3",
      name: "Diane Arbus",
      born: "1923",
      died: "1971",
      country: "United States"
    }

    artist_4 = {
      id: "4",
      name: "Walker Evans",
      born: "1903",
      died: "1975",
      country: "United States"
    }

    artist_5 = {
      id: "5",
      name: "Manuel Alvarez Bravo",
      born: "1902",
      died: "2002",
      country: "Mexico"
    }

    artist_6 = {
      id: "6",
      name: "Bill Cunningham",
      born: "1929",
      died: "2016",
      country: "United States"
    }

    assert_equal [photo_1, photo_2, photo_3, photo_4], @curator.photographs
    assert_equal [artist_1, artist_2, artist_3, artist_4, artist_5, artist_6], @curator.artists
  end

  def test_find_photographs_by_date_range
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')

    photo_1 = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
    }

    photo_2 = {
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
    }
    photo_3 = {
      id: "3",
      name: "Identical Twins, Roselle, New Jersey",
      artist_id: "3",
      year: "1967"
    }

    photo_4 = {
      id: "4",
      name: "Child with Toy Hand Grenade in Central Park",
      artist_id: "3",
      year: "1962"
    }

    assert_equal [photo_1, photo_4], @curator.photographs_taken_between(1950..1965)
  end

  def test_find_artists_photographs_by_age
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')

    diane_arbus = @curator.find_artist_by_id("3")
    assert_equal ({44=>"Identical Twins, Roselle, New Jersey", 39=>"Child with Toy Hand Grenade in Central Park"}), @curator.artists_photographs_by_age(diane_arbus)
  end

end
