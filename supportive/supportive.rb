# In case you missed them, here are the extensions: http://guides.rubyonrails.org/active_support_core_extensions.html

require 'active_support/all'
require 'pry'

class BlagPost
  attr_accessor :author, :comments, :categories, :body, :publish_date

  Author = Struct.new(:name, :url)
  DISALLOWED_CATEGORIES = [:selfposts, :gossip, :bildungsromane]

  def initialize(args)
    args.symbolize_keys!
    if args[:author] != '' && args[:author_url] != ''
      @author = Author.new(args[:author], args[:author_url])
    end
    if args[:categories]
      @categories = args[:categories].reject do |category|
        DISALLOWED_CATEGORIES.include? category
      end
    else
      @categories = []
    end

    @comments = args[:comments] || []
    @body = args[:body].squish
    @publish_date = (args[:publish_date] && Date.parse(args[:publish_date])) || Date.today
  end

  def to_s
    [ category_list, byline, abstract, commenters ].join("\n")
  end

  private

  def byline
    author.try { "By #{author.name}, at #{author.url}" } || ""
  end

  def category_list
    label = categories.empty? ? "" : "Category".pluralize(categories.length)
    label + ": " + categories.map { |cat| as_title(cat) }.to_sentence
  end

  def as_title(string)
    String(string).titleize
  end

  def commenters
    return '' unless comments_allowed?
    return '' unless comments.length > 0
    "You will be the #{comments.length.ordinalize} commenter"
  end

  def comments_allowed?
    publish_date.years_since(3) > Date.today
  end

  def abstract
    body.truncate(200)
  end

end

blag = BlagPost.new("author"        => "Foo Bar",
                    "author_url"    => "http://www.google.com",
                    "categories"    => [:theory_of_computation, :languages, :gossip],
                    "comments"      => [ [], [], [] ], # because comments are meaningless, get it?
                    "publish_date"  => "2013-02-10",
                    "body"          => <<-ARTICLE
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus.
                        Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.
                        Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam
                        tincidunt congue enim, ut porta lorem lacinia consectetur. Donec ut libero sed arcu vehicula
                        ultricies a non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut
                        gravida lorem. Ut turpis felis, pulvinar a semper sed, adipiscing id dolor. Pellentesque auctor
                        nisi id magna consequat sagittis. Curabitur dapibus enim sit amet elit pharetra tincidunt feugiat
                        nisl imperdiet. Ut convallis libero in urna ultrices accumsan. Donec sed odio eros. Donec viverra
                        mi quis quam pulvinar at malesuada arcu rhoncus. Cum sociis natoque penatibus et magnis dis
                        parturient montes, nascetur ridiculus mus. In rutrum accumsan ultricies. Mauris vitae nisi at sem
                        facilisis semper ac in est.
                        ARTICLE
                   )
puts blag.to_s
