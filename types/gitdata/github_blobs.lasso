[
/* =======================================================================
	Blobs API

	Get a Blob
	Create a Blob
	Custom media types
	
	Since blobs can be any arbitrary binary data, the input and responses 
	for the blob API takes an encoding parameter that can be either utf-8 or base64. 
	If your data cannot be losslessly sent as a UTF-8 string, you can base64 encode it.
	
	Blobs leverage these custom media types. 
	You can read more about the use of media types in the API here - http://developer.github.com/v3/media/
======================================================================= */
define github_blobs => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array
	/* =======================================================
	Get a Blob
		GET /repos/:owner/:repo/git/blobs/:sha
	======================================================= */
	public get(-owner::string,-repo::string,-sha::string) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/blobs/'+#sha
		return .request
	}
	/* =======================================================
	Create a Blob
		POST /repos/:owner/:repo/git/blobs
		Input

		{
		  "content": "Content of the blob",
		  "encoding": "utf-8"
		}
	======================================================= */
	public create(-owner::string,-repo::string,-content,-encoding::string='utf-8') => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/blobs'
		.request->method='POST'

		local(outmap = map('content'=#content,'encoding'=#encoding))
		.request->postParams = json_serialize(#outmap)
		
		return .request
	}
}
]