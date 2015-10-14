require 'rails_helper'
include UsersHelper

feature 'restaurants' do

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'user must be logged in to create restaurants' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(page).not_to have_content 'Name'
      expect(current_path).to eq '/users/sign_in'
    end

    scenario 'prompts user to fill out a form, then dispalys the new resaurant' do
      user = build :user
      sign_up user
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        user = build :user
        sign_up user
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){Restaurant.create(name:'KFC')}
    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do

    before { user = build :user
             sign_up user
             click_link 'Add a restaurant'
             fill_in 'Name', with: 'KFC'
             click_button 'Create Restaurant'
             }

    scenario 'let a user edit a resaurant' do
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'user can only edit restaurants that they have created' do
      click_link 'Sign out'
      user2 = build(:user, email: 'user2@test.com')
      sign_up user2
      visit '/restaurants'
      expect(page).not_to have_link 'Edit Mcdonalds'
    end

  end

  context 'deleting restaurants' do
    before {user = build :user
             sign_up user
             click_link 'Add a restaurant'
             fill_in 'Name', with: 'KFC'
             click_button 'Create Restaurant'}

    scenario 'removes a restaurant when a user clicks a delete link' do
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end





end
