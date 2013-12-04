[
/* =======================================================================
	Tags API
		Get a Tag
		Create a Tag Object

	This tags API only deals with tag objects - so only annotated tags, not lightweight tags.
======================================================================= */
define github_tags => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array

	/* =======================================================
	Get a Tag
		GET /repos/:owner/:repo/git/tags/:sha
	======================================================= */
	public get(-owner::string,-repo::string,-sha::string) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/tags/'+#sha
		return .request
	}
	/* =======================================================
	Create a Tag Object

		Note that creating a tag object does not create the reference that makes a tag in Git. 
		If you want to create an annotated tag in Git, you have to do this call to create the 
		tag object, and then create the refs/tags/[tag] reference. 
		If you want to create a lightweight tag, you only have to create the tag reference - 
		this call would be unnecessary.
		POST /repos/:owner/:repo/git/tags
		
		Parameters
		
		Name		Type	Description
		tag			string	The tag
		message		string	The tag message
		object		string	The SHA of the git object this is tagging
		type		string	The type of the object we’re tagging. 
							Normally this is a commit but it can also be a tree or a blob.
		tagger		hash	A hash with information about the individual creating the tag.
		
		The tagger hash contains the following keys:
		name		string	The name of the author of the tag
		email		string	The email of the author of the tag
		date		string	When this object was tagged. 
							This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.

	======================================================= */
	public create(
		-owner::string,
		-repo::string,
		
		-tag::string,
		-message::string,
		-object::string,
		-typeof::string,

		-tagger_name=void,
		-tagger_email=void,
		-tagger_date=void
	) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/tags'
		.request->method='POST'

		local(
			outmap = map(
				'tag'=#tag,
				'message'=#message,
				'object'=#object,
				'type'=#typeof
			),
			tagger = map
		)

		#tagger_name->isA(::string)
			? #tagger->insert('name' = #tagger_name) 
		#tagger_email->isA(::string)
			? #tagger->insert('email' = #tagger_email) 
		#tagger_date->isA(::date)
			? #tagger->insert('date' = #tagger_date->format('yyyy-MM-ddHH:mm:ssZ')) 
		#tagger->size ? #outmap->insert('tagger' = #tagger)
		
		.request->postParams = json_serialize(#outmap)
		
		return .request
	}
}
]