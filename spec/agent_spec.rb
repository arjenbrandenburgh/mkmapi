require 'spec_helper'

describe Mkmapi::Agent do
 let(:connection) { double :connection, url_prefix: 'https://sandbox.mkmapi.eu/ws/v1.1' }
 let(:header) { double :header, signed_attributes: { oauth_signature: '====' } }
 let(:response) { double :response, :body => '{"body": "body"}' }

 before do
   allow(SimpleOAuth::Header).to receive(:new).and_return(header) 
   allow(connection).to receive(:run_request).and_return(response)
 end

 describe '#get' do
   it "takes the url_prefix into account" do
     expected_url = "#{connection.url_prefix}/output.json/test"
     
     expect(SimpleOAuth::Header).to receive(:new).
       with(:get, expected_url, anything, anything).
       and_return(header)

     described_class.new(connection, nil).get 'test'
   end

   it 'generates a MKM compatible Authentication header' do
     expected_header = %Q'OAuth realm="#{connection.url_prefix}/output.json/test", oauth_signature="===="'

     expect(connection).to receive(:run_request).
       with(:get, 'output.json/test', nil, {"Authorization" => expected_header}).
       and_return(response)

     described_class.new(connection, nil).get 'test'
   end

   it "returns the parsed response body" do
     result = described_class.new(connection, nil).get 'test'
     expect(result).to eql({'body' => 'body'})
   end

   it 'stores the last response' do
     agent = described_class.new(connection, nil)
     agent.get 'test'
     expect(agent.last).to be(response)
   end
 end
end