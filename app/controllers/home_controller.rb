require 'net/http'
require 'json'

class HomeController < ApplicationController
    def index
	# calculator expression
    if params[:expression]
      begin
        @result = eval(params[:expression])
      rescue
        @result = "Error"
      end
    end
	# unit convertor
	if params[:value] && params[:type]
	   type = params[:type].to_f
	   value = params[:value].to_f
	   
	   case params[:type]
	   when "km_to_m"
	   @converted = value * 1000
	   when "m_to_km"
	   @converted = value / 1000
	   when "kg_to_g"
	   @converted = value * 1000
	   when "g_to_kg"
	   @converted = value / 1000
	   when "mm_to_inch"
	   @converted = value / 25.4
	   when "mm_to_cm"
	   @converted = value / 10
	   when "cm_to_mm"
	   @converted = value * 10
	   else 
	   @converted = "Invalid"
	   end
	  end
	   
	# currency converter
    if params[:amount] && params[:from] && params[:to]
       amount = params[:amount].to_f
       from = params[:from]
       to = params[:to]

	   url = URI("https://api.exchangerate-api.com/v4/latest/#{from}")
	   responce = Net::HTTP.get(url)
	   data = JSON.parse(responce)
	   
	   rate = data["rates"][to]
	   @currency_result = amount *rate if rate
     end
    end

  def about
  @data = []
  end
   def sheet_metal
  if params[:shape] && params[:thickness] && params[:density]

    t = params[:thickness].to_f / 1000   # mm → m
    density = params[:density].to_f      # kg/m³

    case params[:shape]

    when "plate"
      l = params[:length].to_f / 1000
      w = params[:width].to_f / 1000
      volume = l * w * t

    when "circle"
      d = params[:diameter].to_f / 1000
      r = d / 2
      volume = Math::PI * r * r * t

    when "ring"
      d1 = params[:outer_diameter].to_f / 1000
      d2 = params[:inner_diameter].to_f / 1000
      r1 = d1 / 2
      r2 = d2 / 2
      volume = Math::PI * (r1**2 - r2**2) * t

    else
      volume = 0
    end

    @weight = volume * density
   end
  
    # 🔩 Bend Allowance
    if params[:angle] && params[:radius] && params[:thickness] && params[:k_factor]

    angle = params[:angle].to_f
    radius = params[:radius].to_f
    thickness = params[:thickness].to_f
    k = params[:k_factor].to_f

    @bend_allowance = (Math::PI / 180) * angle * (radius + k * thickness)
     end
	  # Multi-bend flat pattern
  if params[:lengths] && params[:angles]

    lengths = params[:lengths].split(",").map(&:to_f)
    angles = params[:angles].split(",").map(&:to_f)

    radius = params[:radius].to_f
    thickness = params[:thickness].to_f
    k = params[:k_factor].to_f

    total_length = lengths.sum
    total_ba = 0

    angles.each do |angle|
      ba = (Math::PI / 180) * angle * (radius + k * thickness)
      total_ba += ba
    end

    @flat_length = total_length - total_ba
  end
    end
end
