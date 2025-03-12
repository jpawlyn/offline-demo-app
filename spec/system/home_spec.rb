describe 'Home' do
  it 'Visit online and then offline' do
    visit root_path
    expect(page).to have_selector 'h1', text: 'Home 🏡'

    go_offline

    visit root_path
    expect(page).to have_selector 'h1', text: 'Home 🏡'
  end
end
