(* Weatherman
by Rob Wells

An automatic weather script for the Morning Star. 

First written: 16/09/2012
Last update: 17/09/2012
*)

----------------------------------------------------------------------------------------------------
----		Global variables set up here
----------------------------------------------------------------------------------------------------

global cityList
set cityList to {}

global weekendWeather
global dateString
global Sun_dateString

global APIkey
set APIkey to "Your Met Office API key here"

global weatherTypes
set weatherTypes to {"n", "Sunny", "n", "Partly cloudy", "Not used", "Mist", "Fog", "Cloudy", "Overcast", "n", "Light showers", "Drizzle", "Light rain", "n", "Heavy showers", "Heavy rain", "n", "Sleet showers", "Sleet", "n", "Hail showers", "Hail", "n", "Snow showers", "Light snow", "n", "Snow showers", "Heavy snow", "n", "Thundery showers", "Thunder"} -- "n" refers to a night-only condition that we will never see, but is kept in the list so the other conditions have the right position.

----------------------------------------------------------------------------------------------------
----		Start of "live" script
----------------------------------------------------------------------------------------------------

newCity("Aberdeen", "310170")
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

make_dateString()

tell application "TextWrangler"
	make new text window
	repeat with city in cityList
		my callAPI(city)
	end repeat
	close front text window saving no
end tell

tell application "Adobe InDesign CS5.5"
	tell the front document
		if weekendWeather is false then -- For the weekday paper
			override group "Weather" of master spread "Feat-12-13" destination page page 2 -- Overrides the weather group so we can edit the frames
		else -- For the weekend paper
			try
				override group "Weather" of master spread "Feat-NewsRev Left" destination page page 1 -- Targets single-page news review
			end try
			try
				override group "Weather" of master spread "Feat-News reviews" destination page page 2 -- Targets a news review split spread
			end try
		end if
		
		ungroup group "Weather" -- Ungroups the frames, so they can be accessed individually
		
		repeat with city in cityList
			my setWeather(city)
		end repeat
		
	end tell
end tell


----------------------------------------------------------------------------------------------------
----		Handlers below this line
----------------------------------------------------------------------------------------------------

(*		Create city record in cityList
		==================
		Takes cityName ("Aberdeen") and cityLocation (Met location code) as parameters.
		Creates empty variables for the temperature, conditions & Sunday versions of both.
*)

on newCity(cityName, cityLocation)
	set end of cityList to {name:cityName, location:cityLocation, theTemp:"", theCondition:"", sunTemp:"", sunCondition:""}
end newCity


(*		Create date string for API call
		==================
		A YYYY-MM-DD string, and a Sunday one if needed. Also sets weekendWeather boolean.
*)

on make_dateString()
	set tomorrow to ((current date) + (24 * 60 * 60)) -- Current date plus a day
	set dayAfter to ((current date) + ((24 * 60 * 60) * 2)) -- Current date plus two days
	
	if (the weekday of tomorrow as string) is "Saturday" then
		set weekendWeather to true -- Declared global at the top, but all the setting takes place here (to keep it together, rather than "set false" earlier).
	else
		set weekendWeather to false
	end if
	
	-- Regular date string
	set theDate to the day of tomorrow as integer
	set theMonth to the month of tomorrow as integer
	set theYear to the year of tomorrow as integer
	
	if theDate is less than 10 then
		set numDate to ("0" & theDate as string)
	else
		set numDate to theDate
	end if
	if theMonth < 10 then
		set numMonth to ("0" & theMonth as string)
	else
		set numMonth to theMonth
	end if
	set dateString to (theYear & "-" & numMonth & "-" & numDate & "T00Z") as string
	
	-- Sunday date string. Essentially repeated, because two sets of variables are needed.
	if weekendWeather is true then
		set SunDate to the day of dayAfter as integer
		set SunMonth to the month of dayAfter as integer
		set SunYear to the year of dayAfter as integer
		
		
		if SunDate is less than 10 then
			set Sun_numDate to ("0" & SunDate as string)
		else
			set Sun_numDate to SunDate
		end if
		if SunMonth < 10 then
			set Sun_numMonth to ("0" & SunMonth as string)
		else
			set Sun_numMonth to Sun_numMonth
		end if
		set Sun_dateString to (SunYear & "-" & Sun_numMonth & "-" & Sun_numDate & "T00Z") as string
	end if
end make_dateString


(*		Call Met Office API & get XML weather details
		============================
		Takes a city (designed to be "x in list"), calls the API, and picks out the needed data.
*)

on callAPI(city)
	set grepPattern to ".+Dm=\"(.{1,3})\" FDm=\".+\" W=\"(.{1,2})\".+" -- To be used in TextWrangler
	set XML to (do shell script "curl \"http://datapoint.metoffice.gov.uk/public/data/val/wxfcs/all/xml/" & (city's location) & "?res=daily&time=" & dateString & "&key=" & APIkey & "\" | xmllint --format - | grep \">Day</Rep>\"") -- grab XML from API
	-- set XML to "        <Rep D=\"WSW\" Gn=\"31\" Hn=\"54\" PPd=\"4\" S=\"16\" V=\"VG\" Dm=\"15\" FDm=\"13\" W=\"25\" U=\"3\">Day</Rep>" -- For testing with API call disabled
	tell application "TextWrangler"
		tell the front text window
			set the contents to XML -- Data from API call, after terminal grep and clean-up
			find grepPattern searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match -- Searches for previously defined grep pattern
			set city's theTemp to grep substitution of "\\1" -- Gets temperature from grepPattern's first (pattern). "Max n¡C" set in InDesign handler
			if (grep substitution of "\\2") is "NA" then -- The only Met Office "weather type" without a number prefix (and so can't be fetched easily from a list)
				if button returned of (display dialog "The Met Office says " & city's name & "'s weather condition is \"not available\"." & return & return & Â
					"Do you want to continue or stop?" buttons {"Continue", "Stop the script"} default button 2 with icon caution) is "Stop the script" then -- Prompt to stop if weather type is "NA"
					close saving no
					error number -128
				else
					set city's theCondition to "Not available"
				end if
			else
				set city's theCondition to (item ((grep substitution of "\\2") + 1) of weatherTypes) -- Met list starts at 0, AppleScript lists start at 1. (So "0 Clear night" is effectively "1 Clear night" in our list.)
			end if
		end tell
	end tell
	
	if weekendWeather is true then -- Same as above, just for Sunday
		set XML to (do shell script "curl \"http://datapoint.metoffice.gov.uk/public/data/val/wxfcs/all/xml/" & (city's location) & "?res=daily&time=" & Sun_dateString & "&key=" & APIkey & "\" | xmllint --format - | grep \">Day</Rep>\"")
		--	set XML to "        <Rep D=\"WSW\" Gn=\"31\" Hn=\"54\" PPd=\"4\" S=\"16\" V=\"VG\" Dm=\"Sun\" FDm=\"13\" W=\"5\" U=\"3\">Day</Rep>" -- For testing with API call disabled
		tell application "TextWrangler"
			tell the front text window
				set the contents to XML
				find grepPattern searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
				set city's sunTemp to grep substitution of "\\1"
				if (grep substitution of "\\2") is "NA" then
					if button returned of (display dialog "The Met Office says " & city's name & "'s weather condition is \"not available\" for Sunday." & return & return & Â
						"Do you want to continue or stop?" buttons {"Continue", "Stop the script"} default button 2 with icon caution) is "Stop the script" then -- Message makes clear that the problem is with Sunday's data
						close saving no
						error number -128
					else
						set city's sunCondition to "Not available"
					end if
				else
					set city's sunCondition to (item ((grep substitution of "\\2") + 1) of weatherTypes)
				end if
			end tell
		end tell
	end if
end callAPI


(*		Place weather data on page
		=================
		Sets the previously gathered information in labelled InDesign text frames.
*)

on setWeather(city)
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
end setWeather