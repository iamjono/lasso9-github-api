[
	define br => '<br>'
	sys_listtraits !>> 'github_common' ? include('../types/github_common.lasso')
//	sys_listtypes !>> 'github_header' ? 
		include('../types/github_header.lasso')
	sys_listtypes !>> 'github_user' ? include('../types/github_user.lasso')
//	sys_listtypes !>> 'github_repos' ? 
		include('../types/github_repos.lasso')
	

	
	local(repos = github_repos)
	
	/* =======================================================
	Get info about a specified user
	'Get info about a specified users repos'+br
//	#repos->get(-user='fletc3her')
	#repos->get(-user='zeroloop',-sort='created')
	// use for troubleshooting
	#repos->url
	br
	// output the whole array for debug
	'<pre>'+#repos->objectdata+'</pre>'
	
//	br+'full_name: '+#repos->repos_full_name
	loop(#repos->size) => {^
		br+loop_count+': full_name: '+#repos->repos_full_name(loop_count)
	^}
	======================================================= */

	/* =======================================================
	Get the authenticated user
	======================================================= */
	br+br+'Get the authenticated users repos'
	#repos->token('5ea2f6263ba7364cb187ae677f3647f4a10b7e74')
	#repos->get
	br+'url: '+#repos->url
	br+'# repos: '+#repos->size
	br+'default, first full_name: '+#repos->result_full_name
	br
	
	loop(#repos->size) => {^
		br+loop_count+': full_name: '+#repos->result_full_name(loop_count)
	^}

	/* =======================================================
	Get repos for an org
	======================================================= */
	br+br+'Get repos for an org'
	br+'Org:'+br
	#repos->get(-org='LassoSoft')
	br+'url: '+#repos->url
	br+br+br+'# repos: '+#repos->size
	br+'default, first full_name: '+#repos->result_full_name
	br
	
	loop(#repos->size) => {^
		br+loop_count+': full_name: '+#repos->result_full_name(loop_count)
	^}
//	
//	
//	/* =======================================================
//	Update a user property
//	======================================================= */
////	'Update a user property'+br
////	#user->token('5ea2f6263ba7364cb187ae677f3647f4a10b7e74')
////	#user->update(-location='Newmarket, Canada')
////	#user->user_location
//	
//
	br
	br
	'Headers:'+br
	#repos->headers
	br+br
	'X-RateLimit-Remaining = ' + #repos->headers->'X-RateLimit-Remaining'
	
]