require 'spec_helper'

describe Mkmapi::Agent do

  let(:connection) { double :connection, url_prefix: 'https://sandbox.mkmapi.eu/ws/v1.1' }
  let(:header) { double :header, signed_attributes: { oauth_signature: '====' } }
  let(:response) { double :response, :body => '{"body": "body"}' }

  it "takes the url_prefix into account" do
    relative_path = 'test'

    expected_path = "output.json/#{ relative_path }"
    expected_url  = "#{ connection.url_prefix }/#{ expected_path }"

    expect(SimpleOAuth::Header).to receive(:new).
      with(anything, expected_url, anything, anything).
      and_return(header)

    expect(connection).to receive(:get).
      with(expected_path, anything, hash_including(headers: anything)).
      and_return(response)

    described_class.new(connection, nil).get relative_path
  end

  it 'generates a MKM compatible Authentication header' do
    allow(SimpleOAuth::Header).to receive(:new).and_return(header)

    expected_header = %Q'OAuth realm="#{ connection.url_prefix }/output.json/path", oauth_signature="===="'
    expect(connection).to receive(:get).
      with(anything, anything, hash_including(headers: { authorization: expected_header })).
      and_return(response)

    described_class.new(connection, nil).get 'path'
  end

  it "returns the parsed response body" do
    allow(SimpleOAuth::Header).to receive(:new).and_return(header)
    allow(connection).to receive(:get).and_return(response)

    subject = described_class.new(connection, nil).get 'path'
    expect(subject).to eql({'body' => 'body'})
  end

  it 'stores the last response' do
    allow(SimpleOAuth::Header).to receive(:new).and_return(header)
    allow(connection).to receive(:get).and_return(response)

    agent = described_class.new(connection, nil)
    agent.get 'path'

    expect(agent.last).to be(response)
  end

end
