var express = require("express")
var app = express()
var havenondemand = require("havenondemand")
var client = new havenondemand.HODClient("85978353-ebbf-48b9-88dc-3bf559875535")
var bodyParser = require("body-parser")
var urlencoded = bodyParser.urlencoded({extended: false})

// Send diary text and get response
app.post("/entry", urlencoded, function(req, res){
	// Object that will be sent to the client
	var response = {}

	// Request has text parameter
	if (req.body["text"]) {
		var entryText = req.body["text"]
		var textDic = {text: entryText}

		// Call to get the language
		client.call("identifylanguage", textDic, function(err1, resp1, body1){
			if (!err1) {	
				response["language"] = body1.language
				textDic["language"] = body1.language_iso639_2b

				// Call to get sentiment
				client.call("analyzesentiment", textDic, function(err2, resp2, body2){
					if (!err1) {
						// Sentiment analysis worked
						if (resp2.body.aggregate) {
							response["score"] = resp2.body.aggregate.score
							response["sentiment"] = resp2.body.aggregate.sentiment
						}

						// Entitites to search for
						var entitiesParams = ["people_eng", "places_eng", "companies_eng", "organizations", "universities"]
						textDic["entity_type"] = entitiesParams

						// Call to get desired entities
						client.call("extractentities", textDic, function(err3, resp3, body3){
							if (!err3) {
								var parsedEntities = parseEntities(resp3.body.entities)
								response["entities"] = parsedEntities 

								// If some entities are people
								if (parsedEntities["people_eng"]) {
									getFacesInfo(parsedEntities["people_eng"], function(facesInfo){
										response["facesInfo"] = facesInfo
										res.status(200).send(response)									
									})
								} else res.status(200).send(response)
								
							} else {
								console.error("Error: " + err2)	
							}
						})	
					} 
					else {
						console.error("Error: " + err2)	
					}
				})
			} 
			else {
				console.error("Error: " + err1)	
			}
		})
	} else {
		  res.status(400).send("Parameter text missing")
	}	
})


var server = app.listen(process.env.PORT || 8080, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('App listening at http://%s:%s', host, port);
});

// Parses entities into groups
function parseEntities(entities) {
	var parsedEntities = {}

	for (var i = 0; i<entities.length; i++) {
		if (!parsedEntities[entities[i]["type"]]) {
			parsedEntities[entities[i]["type"]] = [entities[i]]
		} else parsedEntities[entities[i]["type"]].push(entities[i])
	}

	return parsedEntities
}


// Gets position of face
function getFacesInfo(people, callback) {
	var facesInfo = {}
	var counter = 0

	// Download info for each face
	for (var j = 0; j < people.length; j++) {
		(function(j) {
			var ent = people[j]

			// Get face position from image
			client.call("detectfaces", {url: ent["additional_information"]["image"]}, function(err, resp, body){
				counter++
				facesInfo[ent["normalized_text"]] = resp.body.face

				// All requests have responded
				if (counter == people.length) {
					callback(facesInfo)
				}
			})
		})(j)
	}
}

