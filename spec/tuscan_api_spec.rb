ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative 'spec_helpers'
require_relative '../tuscan_api'

describe 'TUSCAn API' do

  include SpecHelpers
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  context 'ITS-90' do
    context 'wr function' do
      context 'good request' do
        before do
          allow(Tuscan).to receive(:wr).and_return(1.0)
          post '/its90/wr', t90: 0.01
        end

        it 'returns json' do
          expect(last_response).to be_ok
          expect(last_response.headers['Content-Type']).to eq 'application/json'
        end

        it 'includes wr key in response' do
          expect(json_response).to have_key :wr
        end

        it 'invokes Tuscan#wr, passes standard, t90' do
          expect(Tuscan).to have_received(:wr).with(:its90, 0.01)
        end

        it 'returns computation of wr' do
          expect(response_key(:wr)).to eq 1.0
        end
      end

      context 'bad request' do
        before do
          allow(Tuscan).to receive :wr
        end

        it 'absent t90 yields client error' do
          post '/its90/wr'
          expect(last_response).to be_client_error
        end

        it 'non-numeric t90 yields client error' do
          post '/its90/wr', t90: 'non_numeric'
          expect(last_response).to be_client_error
        end

        it 'ignores extra arguments' do
          post '/its90/wr', t90: 0.0, extra: 'argument'
          expect(last_response).to be_ok
        end
      end
    end

    context 't90r function' do
      context 'good request' do
        before do
          allow(Tuscan).to receive(:t90r).and_return(0.01)
          post '/its90/t90r', wr: 1.0
        end

        it 'returns json' do
          expect(last_response).to be_ok
          expect(last_response.headers['Content-Type']).to eq 'application/json'
        end

        it 'response includes t90r key' do
          expect(json_response).to have_key :t90r
        end

        it 'invokes Tuscan#t90r, passes standard, wr' do
          expect(Tuscan).to have_received(:t90r).with(:its90, 1.0)
        end

        it 'returns computation of t90r' do
          expect(response_key(:t90r)).to eq 0.01
        end
      end

      context 'bad request' do
        before do
          allow(Tuscan).to receive :t90r
        end

        it 'absent wr yields client error' do
          post '/its90/t90r'
          expect(last_response).to be_client_error
        end

        it 'non-numeric wr yields client error' do
          post '/its90/t90r', wr: 'non_numeric'
          expect(last_response).to be_client_error
        end

        it 'ignores extra arguments' do
          post '/its90/t90r', wr: 1.0, extra: 'argument'
          expect(last_response).to be_ok
        end
      end
    end

    context 't90 function' do
      context 'good request, required arguments' do
        before do
          allow(Tuscan).to receive(:t90).and_return(10.05)
          post '/its90/t90', res: 26.0, rtpw: 25.0, subrange: 11
        end

        it 'returns json' do
          expect(last_response).to be_ok
          expect(last_response.headers['Content-Type']).to eq 'application/json'
        end

        it 'response includes t90 key' do
          expect(json_response).to have_key :t90
        end

        it 'invokes Tuscan#t90, passes standard, res, rptw, subrange' do
          expect(Tuscan).to have_received(:t90).with(:its90, 26.0, hash_including(rtpw: 25.0, subrange: 11))
        end

        it 'returns computation of t90' do
          expect(response_key(:t90)).to eq 10.05
        end
      end

      context 'good request, optional arguments' do
        it 'passes valid args to Tuscan#t90' do
          allow(Tuscan).to receive(:t90)
          post '/its90/t90', res: 26.0, rtpw: 25.0, subrange: 7, a: 1.0e-03, b: 2.0e-04
          expect(Tuscan).to have_received(:t90).with(:its90, 26.0, hash_including(rtpw: 25.0, subrange: 7, a: 1.0e-03, b: 2.0e-04))
        end
      end

      context 'bad request' do
        before do
          allow(Tuscan).to receive(:t90).and_return(10.05)
        end

        it 'absent res, rtpw, subrange yields client error' do
          post '/its90/t90'
          expect(last_response).to be_client_error
          post '/its90/t90', res: 26.0
          expect(last_response).to be_client_error
          post '/its90/t90', rtpw: 25.0
          expect(last_response).to be_client_error
          post '/its90/t90', subrange: 11
          expect(last_response).to be_client_error
          post '/its90/t90', res: 26.0, rtpw: 25.0
          expect(last_response).to be_client_error
          post '/its90/t90', res: 26.0, subrange: 11
          expect(last_response).to be_client_error
          post '/its90/t90', rtpw: 25.0, subrange: 11
          expect(last_response).to be_client_error
        end

        it 'non-numeric res, rtpw, subrange yields client error' do
          post '/its90/t90', res: 'non-numeric', rtpw: 25.0, subrange: 11
          expect(last_response).to be_client_error
          post '/its90/t90', res: 26.0, rtpw: 'non-numeric', subrange: 11
          expect(last_response).to be_client_error
          post '/its90/t90', res: 26.0, rtpw: 25.0, subrange: 'non-numeric'
          expect(last_response).to be_client_error
        end

        it 'ignores extra arguments' do
          post '/its90/t90', res: 26.0, rtpw: 25.0, subrange: 11, extra: 'argument'
          expect(last_response).to be_ok
        end
      end
    end

    context 'res function' do
      context 'good request, required arguments' do
        before do
          allow(Tuscan).to receive(:res).and_return(26.0)
          post '/its90/res', t90: 10.05, rtpw: 25.0, subrange: 11
        end

        it 'returns json' do
          expect(last_response).to be_ok
          expect(last_response.headers['Content-Type']).to eq 'application/json'
        end

        it 'response includes res key' do
          expect(json_response).to have_key :res
        end

        it 'invokes Tuscan#res, passes standard, t90, rptw, subrange' do
          expect(Tuscan).to have_received(:res).with(:its90, 10.05, hash_including(rtpw: 25.0, subrange: 11))
        end

        it 'returns computation of res' do
          expect(response_key(:res)).to eq 26.0
        end
      end

      context 'good request, optional arguments' do
        it 'passes valid args to Tuscan#res' do
          allow(Tuscan).to receive(:res)
          post '/its90/res', t90: 10.05, rtpw: 25.0, subrange: 7, a: 1.0e-03, b: 2.0e-04
          expect(Tuscan).to have_received(:res).with(:its90, 10.05, hash_including(rtpw: 25.0, subrange: 7, a: 1.0e-03, b: 2.0e-04))
        end
      end

      context 'bad request' do
        before do
          allow(Tuscan).to receive(:res).and_return(26.0)
        end

        it 'absent t90, rtpw, subrange yields client error' do
          post '/its90/res'
          expect(last_response).to be_client_error
          post '/its90/res', t90: 10.05
          expect(last_response).to be_client_error
          post '/its90/res', rtpw: 25.0
          expect(last_response).to be_client_error
          post '/its90/res', subrange: 11
          expect(last_response).to be_client_error
          post '/its90/res', t90: 10.05, rtpw: 25.0
          expect(last_response).to be_client_error
          post '/its90/res', t90: 10.05, subrange: 11
          expect(last_response).to be_client_error
          post '/its90/res', rtpw: 25.0, subrange: 11
          expect(last_response).to be_client_error
        end

        it 'non-numeric t90, rtpw, subrange yields client error' do
          post '/its90/res', t90: 'non-numeric', rtpw: 25.0, subrange: 11
          expect(last_response).to be_client_error
          post '/its90/res', t90: 10.05, rtpw: 'non-numeric', subrange: 11
          expect(last_response).to be_client_error
          post '/its90/res', t90: 10.05, rtpw: 25.0, subrange: 'non-numeric'
          expect(last_response).to be_client_error
        end

        it 'ignores extra arguments' do
          post '/its90/res', t90: 10.05, rtpw: 25.0, subrange: 11, extra: 'argument'
          expect(last_response).to be_ok
        end
      end
    end
  end
end
