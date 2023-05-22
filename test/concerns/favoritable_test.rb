# frozen_string_literal: true

require 'test_helper'

class FavoritableObjectMock < ApplicationRecord
  self.table_name = 'bills'
  include Favoritable
end

class FavoritableTest < ActiveSupport::TestCase
  setup do
    @user = users(:beth)
  end

  test 'it allows an object to be favorited' do
    bill = bills(:one)
    mock = FavoritableObjectMock.create(bill.attributes.except('id'))

    mock.favorite_for(@user)

    assert_equal mock.class.name, Favorite.last.favoritable_type
    assert_equal mock.id, Favorite.last.favoritable_id
    assert_not @user.favorites.empty?
  end

  test 'it allows an object to be unfavorited' do
    bill = bills(:one)
    mock = FavoritableObjectMock.create(bill.attributes.except('id'))

    mock.favorite_for(@user)
    mock.unfavorite_for(@user)

    assert_predicate @user.favorites, :empty?
  end
end
