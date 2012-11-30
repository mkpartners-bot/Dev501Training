@RestResource (urlMapping='/mattiscool/r2d2/*')
global class sample_RestService {

	@HttpPost 
	global static Id myPostMethodName (String FirstName, String LastName, String Company, String Email) {
		Lead l = new Lead(FirstName=FirstName,LastName=LastName,Email=Email,Company=Company);
		insert l;
		return l.id;
	}

	@HttpGet
	global static String doGet() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		String leadId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		List<Lead> leadQuery = [SELECT Id, Name, Email FROM Lead WHERE Id = :leadId limit 1];
		if ( leadQuery.size() == 1 ){
			return leadQuery[0].Name;
		} else {
			return 'An Error Occurred';
		}
	}

}