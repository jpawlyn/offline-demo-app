describe 'Online only' do
  it 'Visit online and then offline' do
    visit online_only_path
    expect(page).to have_selector 'h1', text: 'Online only 🛜'

    go_offline

    expect { visit online_only_path }.to raise_error(
      Selenium::WebDriver::Error::UnknownError, /unknown error: net::ERR_INTERNET_DISCONNECTED/
    )
  end
end
