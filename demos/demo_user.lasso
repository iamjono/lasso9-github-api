[
	define br => '<br>'
	sys_listtraits !>> 'github_common' ? include('../types/github_common.lasso')
//	sys_listtypes !>> 'github_user' ? 
		include('../types/github_user.lasso')
	

	
	
	/* =======================================================
	Get info about a user
	======================================================= */
	local(user = github_user)
	'Get info about a user'+br
	#user->get('users','iamjono')
	'blog: '+#user->result_blog	

	br
	br
	/* =======================================================
	Get the authenticated user
	======================================================= */
	local(user = github_user)
	'Get the authenticated user'+br
	#user->token(github_key) // not the token BTW, it's random text!
	#user->get('user',string)
//	#user->objectdata
	#user->result_location

	br
	br
	/* =======================================================
	Update a user property
	======================================================= */
	local(user = github_user)
	'Update a user property'+br
	#user->token(github_key) // not the token BTW, it's random text!
	#user->update(-location='Newmarket, Canada')
//	#user->objectdata
	#user->result_location
	

	br
	br
	'Headers:'+br
	#user->headers
	
]