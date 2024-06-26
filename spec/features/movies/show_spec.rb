require 'rails_helper'

RSpec.describe "Movie Show Page" do
  before :each do
    @studio1 = Studio.create(name: "Paramount Pictures", location: "Los Angeles, California")
    @godfather = Movie.create(title: "The Godfather", creation_year: "1972", genre: "Crime", studio: @studio1)

    @marlon_brando = Actor.create(name: "Marlon Brando", age: 50)
    @al_pacino = Actor.create(name: "Al Pacino", age: 40)
    @robert_de_niro = Actor.create(name: "Robert De Niro", age: 60)
    @blah = Actor.create(name: "Blah", age: 1337)

    @godfather.actors << [@marlon_brando, @al_pacino, @robert_de_niro]
  end

  describe 'user story 2' do
    it 'shows the movies title, creation year, and genre' do
      visit "/movies/#{@godfather.id}"

      expect(page).to have_content("Title: The Godfather")
      expect(page).to have_content("Creation Year: 1972")
      expect(page).to have_content("Genre: Crime")
    end

    it 'has a list of all its actors from youngest to oldest' do
      visit "/movies/#{@godfather.id}"

      expect("Al Pacino").to appear_before("Marlon Brando")
      expect("Marlon Brando").to appear_before("Robert")
      expect("Robert").to_not appear_before("Pacino")
    end

    it 'shows the average age of all of the movies actors' do
      visit "/movies/#{@godfather.id}"

      expect(page).to have_content("Average age of all actors: 50.0")
    end
  end

  describe 'user story 3' do
    it 'has a form to add an actor' do
      visit "/movies/#{@godfather.id}"

      expect(page).to have_button('Add Actor')
    end

    it 'can add an actor and redirect to movie show page' do
      visit "/movies/#{@godfather.id}"

      expect(page).to_not have_content(@blah.name)

      fill_in 'Actor ID', with: @blah.id
      click_button 'Add Actor'
      
      expect(current_path).to eq("/movies/#{@godfather.id}")
      expect(page).to have_content(@blah.name)
    end
  end
end