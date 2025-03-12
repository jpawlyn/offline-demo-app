describe 'Offline cached' do
  it 'Visit online and then offline' do
    visit offline_cached_path
    expect(page).to have_selector 'h1', text: 'Offline cached 🛟'

    go_offline

    visit offline_cached_path
    expect(page).to have_selector 'h1', text: 'Offline cached 🛟'
  end

  it 'Visit offline and then online', :run_first do
    go_offline

    visit offline_cached_path
    expect(page).to have_selector 'h1', text: 'You are offline 🔥'

    go_online

    visit offline_cached_path
    expect(page).to have_selector 'h1', text: 'Offline cached 🛟'
  end
end
