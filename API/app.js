var express = require("express")
var app = express()
var havenondemand = require("havenondemand")
var client = new havenondemand.HODClient("85978353-ebbf-48b9-88dc-3bf559875535")
var bodyParser = require("body-parser")
var urlencoded = bodyParser.urlencoded({extended: false})

// Send diary text and get response
app.post("/entry", urlencoded, function(req, res){
	// Request has text
	if (req.body["text"]) {
		var entryText = req.body["text"]
		var textDic = {text: entryText}
		client.call("identifylanguage", textDic, function(err1, resp1, body1){
			if (err1) {
				console.error("Error: " + err1)
			} else {
				console.log(body1)
				res.status(200).send(body1)
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