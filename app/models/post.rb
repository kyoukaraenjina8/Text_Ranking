class Post < ApplicationRecord

  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :genre
  has_many :favorites, dependent: :destroy
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  has_one_attached :image

  def get_image(width, height)
      unless image.attached?
        file_path = Rails.root.join('app/assets/images/no_image.jpg')
        image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      end
      image.variant(resize_to_limit: [width, height]).processed
  end

  def self.post_rank
    #ランキング：commentsテーブルとの関連付けを行いpost_idでグループ化、コメントの平均値を降順で並び替え、うち三件を取得
    @posts = Post.joins(:comments).group(:post_id).order('avg(comments.total_score) desc').limit(3)
  end

# 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("text_name LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("text_name LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("text_name LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("text_name LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end

  validates :image, presence: true
  validates :text_name, presence: true
  validates :introduction, presence: true, length: {maximum: 300}
  validates :review, presence: true, length: {maximum: 300}
  validates :price, presence: true, numericality: { only_integer: true }


end
