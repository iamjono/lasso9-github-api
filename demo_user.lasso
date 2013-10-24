[
	define br => '<br>'
	sys_listtraits !>> 'github_common' ? 
		include('github_common.lasso')
	sys_listtypes !>> 'github_user' ? 
		include('github_user.lasso')
	

	
	local(user = github_user)
	
	/* =======================================================
	Get info about a user
	======================================================= */
	'Get info about a user'+br
	#user->get('users','iamjono')
	'blog: '+#user->blog	

	/* =======================================================
	Get the authenticated user
	======================================================= */
//	'Get the authenticated user'+br
//	#user->token('5ea2f6263ba7364cb187ae677f3647f4a10b7e74')
//	#user->get('user',string)
//	#user->user_location

	/* =======================================================
	Update a user property
	======================================================= */
//	'Update a user property'+br
//	#user->token('5ea2f6263ba7364cb187ae677f3647f4a10b7e74')
//	#user->update(-location='Newmarket, Canada')
//	#user->user_location
	

	br
	br
	'Headers:'+br
	#user->headers
	
]