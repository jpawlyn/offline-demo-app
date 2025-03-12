describe 'Warm cached' do
  it 'Visit offline and then online' do
    go_offline

    visit warm_cached_path
    expect(page).to have_selector 'h1', text: 'Warm cached ☀️'

    go_online

    visit warm_cached_path
    expect(page).to have_selector 'h1', text: 'Warm cached ☀️'
  end
end
