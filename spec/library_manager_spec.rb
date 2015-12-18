require './library/library.rb'

describe Library::Book do
  describe '#add_comment' do
    let(:book) { Library::Book.new '', '' }
    before { book.add_comment 'The comment' }

    context 'when added comment' do
      it { expect(Library::Book.comments_quantity).to eq 1 }
      it { expect(Library::Commentable.total_comments_quantity).to eq 2 }
    end
  end
end

describe Library::Author do
  describe '#add_comment' do
    let!(:author) { Library::Author.new '', 0, 0 }
    before { author.add_comment 'The comment' }

    context 'when added comment' do
      it { expect(Library::Author.comments_quantity).to eq 1 }
      it { expect(Library::Commentable.total_comments_quantity).to eq 4 }
    end
  end
end

describe Library::ReaderWithBook do
  describe '#add_comment' do
    let!(:author){Library::Author.new "", 0, 0}
    let!(:reader){ Library::Reader.new "", 0 } 
    let!(:book){ Library::PublishedBook.new author, "", 1400, 300, 1996 }
    let!(:reader_wit_book){ Library::ReaderWithBook.new reader, book }
    before do
      reader_wit_book.add_comment 'The comment'
      reader_wit_book.add_comment 'The comment 2'
    end

    context 'when added comment' do
      it { expect(Library::ReaderWithBook.comments_quantity).to eq 2 }
      it { expect(Library::Commentable.total_comments_quantity).to eq 8 }
    end
  end
end

describe Library::Reader do
  describe '#add_comment' do
    let!(:reader){ Library::Reader.new "", 0 } 
    before { reader.add_comment "The comment" }

    context 'when added comment' do
      it { expect(Library::Reader.comments_quantity).to eq 1 }
      it { expect(Library::Commentable.total_comments_quantity).to eq 10 }
    end
  end
end

describe Library::PublishedBook do
  describe '#add_comment' do
    let!(:author){Library::Author.new "", 0, 0}
    let!(:book){ Library::PublishedBook.new author, "", 1400, 300, 1996 }
    before do
      book.add_comment 'The comment'
      book.add_comment 'The comment 2'
      book.add_comment 'The comment 3'
    end

    context 'when added comment' do
      it { expect(Library::PublishedBook.comments_quantity).to eq 5 }
      it { expect(Library::Commentable.total_comments_quantity).to eq 16 }
    end
  end
end

describe Library::Manager do
  describe '#add_comment' do
    let!(:manager){Library::Manager.new }
    before { manager.add_comment "The comment 1" }

    context 'when added comment' do
      it { expect(Library::Manager.comments_quantity).to eq 1 }
      it { expect(Library::Commentable.total_comments_quantity).to eq 18 }
    end
  end
end

describe Library::Reader do
  let!(:reader) { Library::Reader.new "", "" }
  let!(:reader1) { Library::Reader.new "", "" } 

  it 'reader identifier' do
    expect(Library::Reader.group_identifier).to eq 6
    expect(reader.eql? reader).to eq true
    expect(reader.eql? reader1).to eq false
    expect(reader.identifier).to eq 9
    expect(reader1.identifier).to eq 10
    expect(reader == reader).to eq true
    expect(reader == reader1).to eq false
  end

end

describe Library::Manager do

  let(:leo_tolstoy) { Library::Author.new(1828, 1910, 'Leo Tolstoy') }
  let(:war_and_peace) { Library::PublishedBook.new(leo_tolstoy, 'War and Peace', 1400, 3280, 1996) }
  let(:war_and_peace_2) { Library::PublishedBook.new(leo_tolstoy, 'War and Peace 2', 1100, 3000, 1999) }
 
  let(:oscar_wilde) { Library::Author.new(1854, 1900, 'Oscar Wilde') }
 
  let(:red_and_black) { Library::PublishedBook.new(oscar_wilde, 'Red and Black', 1300, 150, 2000) }
  let(:red_and_black_2) { Library::PublishedBook.new(oscar_wilde, 'Red and Black 2', 1800, 1500, 2001) } 

  let(:david_black) { Library::Author.new(1851, 1900, 'David A. Black') }
  
  let(:grounded_rubyist) { Library::PublishedBook.new(david_black, 'The Well-Grounded Rubyist', 2000, 10000, 2005) }

  let(:ivan) { Library::Reader.new('Ivan Testenko', 16)}
  let(:ivan_testenko_with_book) {Library::ReaderWithBook.new(war_and_peace, ivan, 333, (DateTime.now.new_offset(0) + 2.weeks)) }
  
  let(:petrenko) { Library::Reader.new('Ivan Petrenko', 18) }
  let(:petrenko_with_book) { Library::ReaderWithBook.new(war_and_peace_2, petrenko, 100, (DateTime.now.new_offset(0) + 2.weeks)) }
  
  let(:obama) { Library::Reader.new('Barak Obama', 20) }
  let(:obama_with_book) {Library::ReaderWithBook.new(red_and_black, obama, 50, (DateTime.now.new_offset(0) + 2.weeks)) }

  let(:stepan) { Library::Reader.new('Barak Stepan', 10)}
 
  let(:manager) {Library::Manager.new([stepan], [red_and_black_2, grounded_rubyist], [ivan_testenko_with_book, petrenko_with_book, obama_with_book]) }
   
  it 'should compose reader notification = Ivan Testenko' do

    expect(manager.reader_notification "Ivan Testenko").to eq <<-TEXT
Dear Ivan Testenko!

You should return a book "War and Peace" authored by Leo Tolstoy in 336.00 hours.
Otherwise you will be charged $0.16 per hour.
By the way, you are on 333 page now and you need 184.19 hours to finish reading "War and Peace"
TEXT
   end

    it 'should compose reader notification = Barak Obama' do

    expect(manager.reader_notification "Barak Obama").to eq <<-TEXT
Dear Barak Obama!

You should return a book "Red and Black" authored by Oscar Wilde in 336.00 hours.
Otherwise you will be charged $0.03 per hour.
By the way, you are on 50 page now and you need 5.00 hours to finish reading "Red and Black"
TEXT
   end

  it 'should compose librarian notification' do
 
    expect(manager.librarian_notification).to eq <<-TEXT
Hello,

There are 5 published books in the library.
There are 4 readers and 3 of them are reading the books.

Ivan Testenko is reading "War and Peace" - should return on 2015-07-30 at 6pm - 184.19 hours of reading is needed to finish.
Ivan Petrenko is reading "War and Peace 2" - should return on 2015-07-30 at 6pm - 161.11 hours of reading is needed to finish.
Barak Obama is reading "Red and Black" - should return on 2015-07-30 at 6pm - 5.00 hours of reading is needed to finish.
TEXT
  end

  it 'should compose statistics notification' do
 
    expect(manager.statistics_notification).to eq <<-TEXT
Hello,

The library has: 5 books, 3 authors, 4 readers
The most popular author is Leo Tolstoy: 433 pages has been read in 2 books by 2 readers.
The most productive reader is Ivan Testenko: he had read 333 pages in 1 books authored by 1 authors.
The most popular book is "War and Peace" authored by Leo Tolstoy: it had been read for 20.81 hours by 1 readers.
TEXT
  end

end
