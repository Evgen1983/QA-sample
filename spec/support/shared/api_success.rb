shared_examples_for 'successfully reponsible' do
  it 'returns 200 status' do
    expect(response).to be_success
  end
end