public with sharing class sample_CallOuts {

	public static void runMyTests(){
		String newLeadId = doTestPOST();
		newLeadId = newLeadId.replace('"','');
		String leadFullName = doTestGET(newLeadId);
	}

	public static String doTestGET(Id leadId){
		String endpoint = 'https://cs14.salesforce.com/services/apexrest/mattiscool/r2d2/'; //Make sure this exists as a RemoteSiteSetting first
		httpResponse res = doCallout(endpoint + leadId, 'GET', null);
		return res.getBody();
	}

	public static String doTestPOST(){
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
		gen.writeStringField('FirstName', 'Matt');
		gen.writeStringField('LastName', 'Kaufman');
		gen.writeStringField('Company', 'MK Partners');
		gen.writeStringField('Email', 'mkaufman@mkpartners.com');
		gen.writeEndObject();
		
		String endpoint = 'https://cs14.salesforce.com/services/apexrest/mattiscool/r2d2/'; //Make sure this exists as a RemoteSiteSetting first
		httpResponse res = doCallout(endpoint, 'POST', gen.getAsString());
		return res.getBody();
	}


	public static httpResponse doCallout(String endpoint, String method, String body){
		http h = new http();

		httpRequest req = new httpRequest();
		req.setEndpoint(endpoint);
		req.setTimeout(60000); //in milliseconds, max is 120000
		req.setMethod(method);
		if ( body != null ){
			req.setBody(body);
		}
		req.setHeader('Content-Type','application/json'); //This will vary for different web services
		if ( endpoint.indexOf('salesforce.com') > 0 ){
			//We're calling Salesforce and need to authenticate, let's use my sessionid
			req.setHeader('Authorization','Bearer '+userInfo.getSessionId());
		}

		httpResponse response = new httpResponse();
		if ( test.isRunningTest() ){
			response.setBody('This is a sample response body');
			response.setStatusCode(200); //This is a successful sample response
		} else {
			response = h.send(req);
		}
		system.debug(response.getBody());
		return response;
	}

}