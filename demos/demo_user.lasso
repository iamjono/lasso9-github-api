[
	// loades key. should be placed in the webroot, or however you wish!
	sys_listUnboundMethods !>> 'github_key' ? include('/github_key.lasso')
	
	// uncomment to force reload
	//include('../types/main/github_user.lasso')
	

	
	/* =======================================================
	Get info about a user
	======================================================= */
	local(obj)   = github('public')
	local(user) = #obj->user
		
	'Get info about a user'+br
	local(result) = #user->get('users','iamjono')->response
	'blog: '+#result->blog	

	
	br
	br
	/* =======================================================
	Get the authenticated user
	======================================================= */
	local(obj)   = github('basic')
	local(user) = #obj->user
	#user->token(github_key)
	
	'Get the authenticated user'+br
	local(result) = #user->get('user',string)->response
	#result->location
	
	
	br
	br
	/* =======================================================
	Update a user property
	======================================================= */
	local(obj)   = github('basic')
	local(user) = #obj->user
	#user->token(github_key)
	
	'Update a user property'+br
	local(result) = #user->update(-location='Newmarket, Canada')->response
	#result->location
	// useful for debug
//	'<pre>'+#result->objectData+'</pre>'

	
]