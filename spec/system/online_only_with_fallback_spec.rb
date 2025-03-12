describe 'Online only with fallback' do
  it 'Visit online and then offline' do
    visit online_only_with_fallback_path
    expect(page).to have_selector 'h1', text: 'Online only with fallback 🛜'

    go_offline

    visit online_only_with_fallback_path
    expect(page).to have_selector 'h1', text: 'You are offline 🔥'

    go_online

    refresh
    expect(page).to have_selector 'h1', text: 'Online only with fallback 🛜'
  end
end
