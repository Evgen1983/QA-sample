shared_examples_for "API CreateAuthenticable" do
  context 'unauthorized' do
      context 'there is no acess_token' do
        it 'does not create the question' do
          expect{
            do_request
          }.to_not change(Question, :count)
        end

        it 'returns 401 status' do
          do_request
          expect(response.status).to eq 401
        end
      end

      context 'acess_token is invalid' do
        it 'does not create the question' do
          expect{
            do_request
          }.to_not change(Question, :count)
        end

        it 'returns 401 status' do
          do_request
          expect(response.status).to eq 401
        end
      end
    end

end