@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock 
{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
         HttpResponse res = new HttpResponse();
	      res.setHeader('Content-Type', 'application/json');
	      res.setBody('{"success":"true"}');
	      res.setStatusCode(200);
		return res;
    }
}