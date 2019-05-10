class Task < ApplicationRecord
  # validates :name, presence: true
  # validates :name, length: { maximum: 30 }

  validate :validate_name_not_including_comma

  # UserとTaskは１対多の関係
  belongs_to :user

  has_one_attached :image

  scope :recent, -> { order(created_at: :desc) }
  
  # 検索結果を絞る
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
