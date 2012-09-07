tell application "Finder"
	set weather_file to ((the POSIX path of (path to desktop)) & (weekday of (current date)) & "_weather.txt")
	do shell script "curl -L http://shop.morningstaronline.co.uk/offsite/weather/test/weather-app.php -o " & weather_file
end tell

tell application "TextWrangler"
	open weather_file
	
	replace "intervals" using "spells" searching in text 1 of text document 1 options {search mode:literal, starting at top:true}
	
	find "Aberdeen_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Aberdeen_condition to (grep substitution of "\\1")
	find "Aberdeen_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Aberdeen_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Birmingham_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Birmingham_condition to (grep substitution of "\\1")
	find "Birmingham_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Birmingham_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Cardiff_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Cardiff_condition to (grep substitution of "\\1")
	find "Cardiff_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Cardiff_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Edinburgh_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Edinburgh_condition to (grep substitution of "\\1")
	find "Edinburgh_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Edinburgh_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Glasgow_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Glasgow_condition to (grep substitution of "\\1")
	find "Glasgow_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Glasgow_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Liverpool_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Liverpool_condition to (grep substitution of "\\1")
	find "Liverpool_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Liverpool_temperature to ("max " & (grep substitution of "\\1"))
	
	find "London_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set London_condition to (grep substitution of "\\1")
	find "London_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set London_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Manchester_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Manchester_condition to (grep substitution of "\\1")
	find "Manchester_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Manchester_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Newcastle upon Tyne_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Newcastle_condition to (grep substitution of "\\1")
	find "Newcastle upon Tyne_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Newcastle_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Norwich_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Norwich_condition to (grep substitution of "\\1")
	find "Norwich_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Norwich_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Plymouth_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Plymouth_condition to (grep substitution of "\\1")
	find "Plymouth_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Plymouth_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Sheffield_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Sheffield_condition to (grep substitution of "\\1")
	find "Sheffield_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Sheffield_temperature to ("max " & (grep substitution of "\\1"))
	
	find "Southampton_condition=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Southampton_condition to (grep substitution of "\\1")
	find "Southampton_temperature=(.+);" searching in text 1 of text document 1 options {search mode:grep, starting at top:true, case sensitive:false} without selecting match
	set Southampton_temperature to ("max " & (grep substitution of "\\1"))
	
end tell

tell application "Adobe InDesign CS5.5"
	tell the front document
		set locked of layer "Furniture" to false
		override group "Weather" of master spread "Feat-12-13" destination page page 2
		ungroup group "Weather" of page 2
		
		set the contents of text frame "Aberdeen_condition" to Aberdeen_condition
		set the contents of text frame "Aberdeen_temperature" to Aberdeen_temperature
		set the contents of text frame "Birmingham_condition" to Birmingham_condition
		set the contents of text frame "Birmingham_temperature" to Birmingham_temperature
		set the contents of text frame "Cardiff_condition" to Cardiff_condition
		set the contents of text frame "Cardiff_temperature" to Cardiff_temperature
		set the contents of text frame "Edinburgh_condition" to Edinburgh_condition
		set the contents of text frame "Edinburgh_temperature" to Edinburgh_temperature
		set the contents of text frame "Glasgow_condition" to Glasgow_condition
		set the contents of text frame "Glasgow_temperature" to Glasgow_temperature
		set the contents of text frame "Liverpool_condition" to Liverpool_condition
		set the contents of text frame "Liverpool_temperature" to Liverpool_temperature
		set the contents of text frame "London_condition" to London_condition
		set the contents of text frame "London_temperature" to London_temperature
		set the contents of text frame "Manchester_condition" to Manchester_condition
		set the contents of text frame "Manchester_temperature" to Manchester_temperature
		set the contents of text frame "Newcastle_condition" to Newcastle_condition
		set the contents of text frame "Newcastle_temperature" to Newcastle_temperature
		set the contents of text frame "Norwich_condition" to Norwich_condition
		set the contents of text frame "Norwich_temperature" to Norwich_temperature
		set the contents of text frame "Plymouth_condition" to Plymouth_condition
		set the contents of text frame "Plymouth_temperature" to Plymouth_temperature
		set the contents of text frame "Sheffield_condition" to Sheffield_condition
		set the contents of text frame "Sheffield_temperature" to Sheffield_temperature
		set the contents of text frame "Southampton_condition" to Southampton_condition
		set the contents of text frame "Southampton_temperature" to Southampton_temperature
		
		set locked of layer "Furniture" to true
	end tell
end tell