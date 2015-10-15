require 'rails_helper'

feature 'reviewing' do
  before { user = build :user
           sign_up user
           click_link 'Add a restaurant'
           fill_in 'Name', with: 'KFC'
           click_button 'Create Restaurant' }

  scenario 'allows users to leave a review using a form' do
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'users can only leave one review per restaurant' do
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "very nice!"
    select '5', from: 'Rating'
    click_button 'Leave Review'
    expect(page).to have_content 'Users can only leave one review per restaurant'
    expect(current_path).to eq '/restaurants'
  end

  scenario 'users can only delete their own reviews' do
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Delete KFC Review'
    expect(page).not_to have_content 'so so'
    expect(current_path).to eq '/restaurants'
  end

  scenario 'displays an average rating for all reviews' do
    leave_review 'So so', '3'
    click_link 'Sign out'
    user2 = build :user, email: 'test2@example.com'
    sign_up user2
    leave_review 'Great', '5'
    expect(page).to have_content 'Average rating: ★★★★☆'
  end
end

def leave_review thoughts, rating
  click_link 'Review KFC'
  fill_in 'Thoughts', with: thoughts
  select rating, from: 'Rating'
  click_button 'Leave Review'
end
