require 'sinatra'
require 'sinatra/json'
require 'tuscan'

post '/its90/wr' do
  json wr: Tuscan.wr(:its90, t90)
end

post '/its90/t90r' do
  json t90r: Tuscan.t90r(:its90, wr)
end

post '/its90/t90' do
  halt 400 unless params_include_all %w{ res rtpw subrange }
  json t90: Tuscan.t90(:its90, res, its90_args)
end

post '/its90/res' do
  halt 400 unless params_include_all %w{ t90 rtpw subrange }
  json res: Tuscan.res(:its90, t90, its90_args)
end

helpers do
  def t90
    Float params['t90'] rescue halt 400 
  end

  def wr
    Float params['wr'] rescue halt 400 
  end

  def res
    Float params['res'] rescue halt 400 
  end

  def its90_args
    symbolize_and_float params_matching %w{ rtpw subrange a b c d w660 c1 c2 c3 c4 c5 }
  end

  def symbolize_and_float h
    h.map{ |k, v| [k.to_sym, Float(v)] }.to_h rescue halt 400
  end

  def params_matching args
    params.select { |k| args.include? k }
  end

  def params_include_all args
    args.all? { |a| params.key? a }
  end

  def params_include_any args
    args.any? { |a| params.key? a }
  end
end
