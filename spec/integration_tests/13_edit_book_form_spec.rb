require 'spec_helper'

describe "Book edit form" do

  let(:original_book_name) {"The Book"}
  let(:changed_book_name) {"The Changed Book"}
  let(:original_author_name) {"Authorman"}
  let(:preexisting_author_name) {"Preexisting Author"}
  let(:changed_author_name) {"Changed Authorman"}
  let(:original_publisher_name) {"Original Publishing"}
  let(:preexisting_publisher_name) {"Preexisting Publishing"}
  let(:changed_publisher_name) {"Unoriginal Publishing"}
  let(:first_edition_publishing) {1993}
  let(:second_edition_publishing) {1995}

  let!(:original_publisher) {Publisher.create(name: original_publisher_name)}
  let!(:preexisting_publisher) {Publisher.create(name: preexisting_publisher_name)}
  let!(:original_author) {Author.create(name: original_author_name)}
  let!(:preexisting_author){Author.create(name: preexisting_author_name)}
  let!(:original_book) {Book.create(name: original_book_name)}
  let!(:genre_1) {Genre.create(name: "Fantasy")}
  let!(:genre_2) {Genre.create(name: "History")}
  let!(:genre_3) {Genre.create(name: "Thriller")}

  before do
    original_book.author = original_author
    original_book.publisher = original_publisher
    original_book.has_been_read = 0
    original_book.year_published = first_edition_publishing
    original_book.genres << genre_1
    original_book.genres << genre_2
    original_book.save
    @book = original_book
    @id = original_book.id
    @authors = Author.all
    visit "/books/#{original_book.slug}/edit"
  end

  context "editing a book name" do
    it "prefills the form with original book's name" do
      expect(find_field('book_name').value).to eq original_book_name
    end

    it "saves changes to the book's name" do
      fill_in 'book_name', :with => changed_book_name
      click_on 'Edit Book'
      expect(Book.find(@id).name).to eq(changed_book_name)
    end

    it "does not create a new book" do
      expect {
        fill_in "book_name", with: changed_book_name
        click_on "Edit Book"
      }.not_to change(Book, :count)
    end
  end

  context "editing a book's author" do
    it "preselects the unchanged book's author" do
      expect(find_field('book_author').value).to eq original_author_name
    end

    it "saves changes to the author's name when new author name is created" do
      fill_in "new_book_author", :with => changed_author_name
      click_on 'Edit Book'
      expect(Book.find(@id).author.name).to eq(changed_author_name)
    end

    it "creates a new author when a new author name is input" do
      expect{
        fill_in "new_book_author", :with => changed_author_name
        click_on 'Edit Book'
      }.to change(Author, :count).by(1)
    end

    it "saves changes to the author's name when a pre-existing author name is selected" do
      select preexisting_author_name, :from => "book_author"
      click_on 'Edit Book'
      expect(Book.find(@id).author.name).to eq(preexisting_author_name)
    end

    it "does not create a new author when choosing a preexisting_author_name" do
      expect{
      select preexisting_author_name, :from => "book_author"
      click_on 'Edit Book'}.not_to change(Author, :count)
    end
  end

  context "editing a book's publisher" do
    it "preselects the unchanged book's publisher" do
      expect(find_field('book_publisher').value).to eq original_publisher_name
    end

    it "saves changes to the publisher's name when a new publisher name is created" do
      fill_in "new_publisher_name", :with => changed_publisher_name
      click_on 'Edit Book'
      expect(Book.find(@id).publisher.name).to eq(changed_publisher_name)
    end

    it "creates a new publisher when a new publisher name is passed in" do
      expect{
        fill_in "new_publisher_name", :with => changed_publisher_name
        click_on 'Edit Book'
      }.to change(Publisher, :count).by(1)
    end


    it "saves changes to the publisher's name when a pre-existing publisher name is selected" do
      select preexisting_publisher_name, :from =>'book_publisher'
      click_on 'Edit Book'
      expect(Book.find(@id).publisher.name).to eq(preexisting_publisher_name)
    end

    it "does not create a new publisher when choosing a preexisting publisher name" do
      expect{
        select preexisting_publisher_name, :from =>'book_publisher'
        click_on 'Edit Book'
      }.not_to change(Publisher, :count)
    end
  end

  context "editing year of publication" do
    it "preselects the unchanged book's year" do
      expect(find_field('book_year_published').value).to eq first_edition_publishing.to_s
    end

    it "changes the book's publication year when a new value is passed in" do
      fill_in "book_year_published", :with => second_edition_publishing
      click_on 'Edit Book'
      expect(Book.find(@id).year_published).to eq(second_edition_publishing)
    end
  end


end