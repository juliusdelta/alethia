# frozen_string_literal: true

module Favoritable
  extend ActiveSupport::Concern

  included do
    has_many :favoritings, class_name: 'Favorite', as: :favoritable, dependent: :destroy
  end

  def favorite_for(user)
    favoritings.create(user:)
  end

  def unfavorite_for(user)
    favoritings.where(user:).destroy_all
  end

  def favorited_by?(user)
    favoritings.exists?(user_id: user.id)
  end

  def favoritings_count
    favoritings.all.count
  end
end
