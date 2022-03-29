class CitiesController < ApplicationController
  
  #Lista de ciudades
  def index
    @cities = City.all
  end

  #Lista de ciudades por id
  def show
    @city = City.find(params[:id])
    require 'net/http'
    require 'json'
  #Verificación de errores
    @apikeyshow = "fGpzVJm08tx5kopcfl55lLMkD4O5BcH9"
    @urltest = "https://dataservice.accuweather.com/locations/v1/cities/search?apikey="+@apikeyshow+"&q=Santiago"
    @error = '{"Code"=>"ServiceUnavailable", "Message"=>"The allowed number of requests has been exceeded.", "Reference"=>"/locations/v1/cities/search?apikey='+@apikeyshow+'&q=Santiago"}'
  #Convertir url a uri
    @uritest = URI(@urltest)
  #Obtengo la respuesta de internet al uri
    @responsetest = Net::HTTP.get(@uritest)
  #Parseo la respuesta a formato json
    @jsonptest = JSON.parse(@responsetest)
    @jsontestparsed = @jsonptest.to_s 
  end

  #Agregar ciudad
  def new
    @city = City.new
  end
    
  def create
    @city = City.new(city_params)
    if @city.save
      redirect_to @city
    else
      render :new, status: :unprocessable_entity
    end
  end

  #Editar ciudad
  def edit
    @city = City.find(params[:id])
  end
  def update
    @city = City.find(params[:id])
    if @city.update(city_params)
      redirect_to @city
    else
      render :edit, status: :unprocessable_entity
    end
  end

  #Eliminar ciudad
  def destroy
    @city = City.find(params[:id])
    @city.destroy
    redirect_to root_path, status: :see_other
  end
    
  #Datos para pronostico
  def forecast
    require 'net/http'
    require 'json'
  #Declaracion de variables
    @loc = (params[:locationKey])
    @forecastcityname = (params[:name])
    @forecastcitycountry = (params[:country])
    @apikey = "fGpzVJm08tx5kopcfl55lLMkD4O5BcH9"
    
  #Genero la url para el pronostico
    @url = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/"+@loc+"?apikey="+@apikey+"&language=en-us"
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @jsonp = JSON.parse(@response)
    
  #Genero la url para el la geoposicion
    @url2= "http://dataservice.accuweather.com/locations/v1/cities/search?apikey="+@apikey+"&q="+@forecastcityname+"%2C%20"+@forecastcitycountry+"&language=en-us&details=false"
    @uri2 = URI(@url2)
    @response2 = Net::HTTP.get(@uri2)
    @jsonp2 = JSON.parse(@response2)

  #Obtener Geoposicion
    @output2 = @jsonp2[0]
    @geoposition = @output2["GeoPosition"]
    @lat = @geoposition["Latitude"]
    @lon = @geoposition["Longitude"]
    @lats = @lat.to_s
    @lons = @lon.to_s
    
  #Genero la url para el direccion y velocidad del viento
    @urlwind = "https://api.openweathermap.org/data/2.5/weather?lat="+@lats+"&lon="+@lons+"&appid=2fb9343bde6c7fefe15878d59c8eba2d"
    @uri3 = URI(@urlwind)
    @response3 = Net::HTTP.get(@uri3)
    @jsonp3 = JSON.parse(@response3)

  #Obtengo datos del viento
    @wind = @jsonp3["wind"]
    @windspeed = @wind["speed"]
    @windspeedkm = @windspeed*1.60934
    @windspeedkmrounded = @windspeedkm.round(2)
    @winddeg = @wind["deg"]


  #Dia 1
    @output = @jsonp["DailyForecasts"][0]
    @d0 = @output["Temperature"]
  #Temperatura minima
    @d0minimum = @d0["Minimum"]
    @d0value = @d0minimum["Value"]
  #Convertir F° a C°
    @d0celcius = ((@d0value) - 32)*(0.5555555556)
    @parsedvalue0min = @d0celcius.to_i
  #Temperatura maxima
    @d0maximum = @d0["Maximum"]
    @d0valuemax = @d0maximum["Value"]
  #Convertir F° a C°
    @d0celcius = ((@d0valuemax) - 32)*(0.5555555556)
    @parsedvalue0max = @d0celcius.to_i
  #Fecha
    @d0f = @output["Date"]
    @d0f0 = @d0f[8,2]
  #Mes
    @d0fm = @output["Date"]
    @d0f0m = @d0fm[5,2]
  #Obtener estado del clima
    @day = @output["Day"]
    @icon = @day["IconPhrase"]
    @icon.downcase!

  #Día 2
    @output = @jsonp["DailyForecasts"][1]
    @d1 = @output["Temperature"]
    @d1minimum = @d1["Minimum"]
    @d1value = @d1minimum["Value"]
    @d1celcius = ((@d1value) - 32)*(0.5555555556)
    @parsedvalue1min = @d1celcius.to_i
    @d1maximum = @d1["Maximum"]
    @d1valuemax = @d1maximum["Value"]
    @d1celcius = ((@d1valuemax) - 32)*(0.5555555556)
    @parsedvalue1max = @d1celcius.to_i
    @d1f = @output["Date"]
    @d1f1 = @d1f[8,2]
    @d1fm = @output["Date"]
    @d1f1m = @d1fm[5,2]
    @day1 = @output["Day"]
    @icon1 = @day1["IconPhrase"]
    @icon1.downcase!

  #Día 3
    @output = @jsonp["DailyForecasts"][2]
    @d2 = @output["Temperature"]
    @d2minimum = @d2["Minimum"]
    @d2value = @d2minimum["Value"]
    @d2celcius = ((@d2value) - 32)*(0.5555555556)
    @parsedvalue2min = @d2celcius.to_i
    @d2maximum = @d2["Maximum"]
    @d2valuemax = @d2maximum["Value"]
    @d2celcius = ((@d2valuemax) - 32)*(0.5555555556)
    @parsedvalue2max = @d2celcius.to_i
    @d2f = @output["Date"]
    @d2f2 = @d2f[8,2]
    @d2fm = @output["Date"]
    @d2f2m = @d2fm[5,2]
    @day2 = @output["Day"]
    @icon2 = @day2["IconPhrase"]
    @icon2.downcase!

  #Día 4
    @output = @jsonp["DailyForecasts"][3]
    @d3 = @output["Temperature"]
    @d3minimum = @d3["Minimum"]
    @d3value = @d3minimum["Value"]
    @d3celcius = ((@d3value) - 32)*(0.5555555556)
    @parsedvalue3min = @d3celcius.to_i
    @d3maximum = @d3["Maximum"]
    @d3valuemax = @d3maximum["Value"]
    @d3celcius = ((@d3valuemax) - 32)*(0.5555555556)
    @parsedvalue3max = @d3celcius.to_i
    @d3f = @output["Date"]
    @d3f3 = @d3f[8,2]
    @d3fm = @output["Date"]
    @d3f3m = @d3fm[5,2]
    @day3 = @output["Day"]
    @icon3 = @day3["IconPhrase"]
    @icon3.downcase!

  #Día 5
    @output = @jsonp["DailyForecasts"][4]
    @d4 = @output["Temperature"]
    @d4minimum = @d4["Minimum"]
    @d4value = @d4minimum["Value"]
    @d4celcius = ((@d4value) - 32)*(0.5555555556)
    @parsedvalue4min = @d4celcius.to_i
    @d4maximum = @d4["Maximum"]
    @d4valuemax = @d4maximum["Value"]
    @d4celcius = ((@d4valuemax) - 32)*(0.5555555556)
    @parsedvalue4max = @d4celcius.to_i
    @d4f = @output["Date"]
    @d4f4 = @d4f[8,2]
    @d4fm = @output["Date"]
    @d4f4m = @d4fm[5,2]
    @day4 = @output["Day"]
    @icon4 = @day4["IconPhrase"]
    @icon4.downcase! 

  #Grafico de barras
    @data = [@parsedvalue0max, @parsedvalue1max, @parsedvalue2max, @parsedvalue3max, @parsedvalue4max]


  end

  
  def codigo
    require 'net/http'
    require 'json'
    
  #Declaración de variables
    @nombreciudad = (params[:name])
    @nombrepais = (params[:country])
    @apikeycodigo = "fGpzVJm08tx5kopcfl55lLMkD4O5BcH9"
    @codigourl = "http://dataservice.accuweather.com/locations/v1/cities/search?apikey="+@apikeycodigo+"&q="+@nombreciudad+"%2C%20"+@nombrepais+"&language=en-us&details=false"
  #Convertir url a uri
    @uricodigo = URI(@codigourl)
  #Obtengo la respuesta de internet al uri
    @responsecodigo = Net::HTTP.get(@uricodigo)
  #Parseo la respuesta a formato json
    @jsonpcodigo = JSON.parse(@responsecodigo)
    @outputcode = @jsonpcodigo[0]
    @outputkey = @outputcode["Key"]
    @parsedcode = @outputkey.to_s
  end

  private
  def city_params
    params.require(:city).permit(:name, :country, :locationKey)
  end
end