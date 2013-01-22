--	Weatherman: Morning Star automatic weather layout

--	Written by			Rob Wells
--	Created on			16/09/2012
--	Last updated			22/01/2013
--	Version:			2.2

--	This fetches tomorrow's weather forecasts and temperatures from the
--	Met Office API and places them in frames in the front InDesign document.

property APIkey : "Your Met Office API key here"


-- "Live" script --
set indesignObject to indesignCheck()
set dateObject to make_dateString()
set cityList to setCities()
callAPI(cityList, dateObject)
setWeather(cityList, indesignObject, dateObject's weekendWeather)


-- Handler definitions --

-- Check for weather page, return document details
on indesignCheck()
	tell application "Adobe InDesign CS5.5"
		tell the front document
			set weather_pages to {"TV", "NewsReview-L", "NewsReview-Split"}
			set pageCount to the the count of the pages
			
			try
				if pageCount is 1 then
					set masterName to the base name of the applied master of page 1
					set destPage to 1
				else if (pageCount is 2) or (pageCount is 3) then
					set masterName to the base name of the applied master of page 2
					set destPage to 2
				end if
			on error
				set masterName to "NO_MASTER_APPLIED"
			end try
			
			if masterName is not in weather_pages then
				display alert "The front InDesign document is not a weather page. The script will now exit."
				error number -128
			end if
			
			return {master:("Feat-" & masterName), dest:destPage}
		end tell
	end tell
end indesignCheck


-- Assemble cityList
on setCities()
	set internal_cityList to {}
	
	script cityScript -- Closure
		on newCity(cityName, cityLocation) -- City constructor
			set end of internal_cityList to {name:cityName, location:cityLocation, theTemp:"", theCondition:"", sunTemp:"", sunCondition:""}
		end newCity
		
		newCity("Aberdeen", "310170") -- Name must match InDesign label exactly, number is Met Office location code
		newCity("Birmingham", "310002")
		newCity("Cardiff", "350758")
		newCity("Edinburgh", "351351")
		newCity("Glasgow", "310009")
		newCity("Liverpool", "310012")
		newCity("London", "352409")
		newCity("Manchester", "310013")
		newCity("Newcastle", "352793")
		newCity("Norwich", "310115")
		newCity("Plymouth", "310016")
		newCity("Sheffield", "353467")
		newCity("Southampton", "353595")
	end script
	
	run cityScript
	return internal_cityList
end setCities


-- Create a YYYY-MM-DD string to use in the API call and set weekendWeather boolean
on make_dateString()
	set tomorrow to ((current date) + (24 * 60 * 60)) -- Current date plus a day
	set dateObject to {dateString:"", Sun_dateString:"", weekendWeather:""} -- Stores date variables, returned and passed to other handlers
	
	if (the weekday of tomorrow as string) is "Saturday" then
		set dateObject's weekendWeather to true
	else
		set dateObject's weekendWeather to false
	end if
	
	-- Regular date string
	set theDate to the day of tomorrow as integer
	set theMonth to the month of tomorrow as integer
	set theYear to the year of tomorrow as integer
	
	if theDate is less than 10 then set theDate to ("0" & theDate)
	if theMonth is less than 10 then set theMonth to ("0" & theMonth)
	
	set dateObject's dateString to (theYear & "-" & theMonth & "-" & theDate & "T00Z") as string
	
	-- Sunday date string
	if dateObject's weekendWeather is true then
		set dayAfter to ((current date) + ((24 * 60 * 60) * 2)) -- Current date plus two days
		
		set SunDate to the day of dayAfter as integer
		set SunMonth to the month of dayAfter as integer
		set SunYear to the year of dayAfter as integer
		
		if SunDate is less than 10 then set SunDate to ("0" & SunDate)
		if SunMonth is less than 10 then set SunMonth to ("0" & SunMonth)
		
		set dateObject's Sun_dateString to (SunYear & "-" & SunMonth & "-" & SunDate & "T00Z") as string
	end if
	
	return dateObject
end make_dateString


--	Call Met Office API & get XML weather details
--	Takes a city (designed to be "x in list"), calls the API, and picks out the needed data
on callAPI(cityList, dateObject)
	-- Closure variables
	set grepPattern to ".+Dm=\"(.{1,3})\" FDm=\".+\" W=\"(.{1,2})\".+" -- To be used in TextWrangler
	set weather_types to {"n", "Sunny", "n", "Partly cloudy", "Not used", "Mist", "Fog", "Cloudy", "Overcast", "n", "Light showers", "Drizzle", "Light rain", "n", "Heavy showers", "Heavy rain", "n", "Sleet showers", "Sleet", "n", "Hail showers", "Hail", "n", "Snow showers", "Light snow", "n", "Snow showers", "Heavy snow", "n", "Thundery showers", "Thunder"} -- "n" refers to a night-only condition that we will never see, but is kept in the list so the other conditions have the right position.
	
	script workhorse -- Closure
		tell application "TextWrangler"
			make new text window
			repeat with city in cityList
				my apiCall(city)
			end repeat
			close the front text window saving no
		end tell
		
		-- Construct API call
		on buildCall(location, when)
			return (do shell script "curl \"http://datapoint.metoffice.gov.uk/public/data/val/wxfcs/all/xml/" & location & "?res=daily&time=" & when & "&key=" & APIkey & "\" | xmllint --format - | grep \">Day</Rep>\"")
		end buildCall
		
		-- Display message when forecast is "NA"
		on noData(city, Sun) -- Which city and is the problem with Sunday's data?
			set message to "The Met Office says " & city's name & "'s weather condition is \"not available\""
			if Sun is true then set message to message & " for Sunday"
			set message to message & "." & return & return & "Do you want to continue or stop?"
			
			if button returned of (display dialog message buttons {"Continue", "Stop the script"} default button 2 with icon caution) is "Stop the script" then
				tell application "TextWrangler" to close saving no
				error number -128
			else
				set city's sunCondition to "Not available"
			end if
		end noData
		
		-- Call API and extract data from XML
		on apiCall(city)
			set XML to buildCall(city's location, dateObject's dateString)
			tell application "TextWrangler"
				tell the front text window
					set the contents to XML -- Data from API call, after terminal grep and clean-up
					find grepPattern searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match -- Searches for previously defined grep pattern
					set city's theTemp to grep substitution of "\\1" -- Gets temperature from grepPattern's first (pattern). "Max n¡C" set in InDesign handler
					if (grep substitution of "\\2") is "NA" then -- The only Met Office "weather type" without a number prefix (and so can't be fetched easily from a list)
						noData(city, false)
					else
						set city's theCondition to (item ((grep substitution of "\\2") + 1) of weather_types)
						-- Met list starts at 0, AppleScript lists start at 1. (So "0 Clear night" is effectively "1 Clear night" in our list.)
					end if
				end tell
			end tell
			
			if dateObject's weekendWeather is true then -- Same as above, just for Sunday
				set XML to buildCall(city's location, dateObject's Sun_dateString)
				tell application "TextWrangler"
					tell the front text window
						set the contents to XML
						find grepPattern searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
						set city's sunTemp to grep substitution of "\\1"
						if (grep substitution of "\\2") is "NA" then
							noData(city, true)
						else
							set city's sunCondition to (item ((grep substitution of "\\2") + 1) of weather_types)
						end if
					end tell
				end tell
			end if
		end apiCall
	end script
	
	run workhorse
	
end callAPI


-- Prep the page and set the weather
on setWeather(cityList, indesignObject, weekendWeather)
	tell application "Adobe InDesign CS5.5"
		tell the front document
			
			override group "Weather" of master spread (indesignObject's master) destination page page (indesignObject's dest)
			ungroup group "Weather" -- Ungroups the frames, so they can be accessed individually
			
			repeat with city in cityList
				set tempBox to (city's name & "_temperature") -- So we can address the frames for each city
				set conditionBox to (city's name & "_condition")
				
				tell application "Adobe InDesign CS5.5"
					tell the front document
						set the contents of text frame conditionBox to (city's theCondition) -- Puts the weather condition in the appropriate box for the specified city
						set the contents of text frame tempBox to ("max " & city's theTemp & "¡C") -- Same for temperature
					end tell
				end tell
				
				if weekendWeather is true then -- Set the Sunday weather if it's a weekend paper
					set Sun_tempBox to (city's name & "_temperature (Sun)") -- So we can address the Sunday frames for each city
					set Sun_conditionBox to (city's name & "_condition (Sun)")
					
					tell application "Adobe InDesign CS5.5"
						tell the front document
							set the contents of text frame Sun_conditionBox to (city's sunCondition) -- Puts the Sunday condition in the city's Sunday box
							set the contents of text frame Sun_tempBox to ("max " & city's sunTemp & "¡C")
						end tell
					end tell
				end if
			end repeat
			
		end tell
	end tell
end setWeather