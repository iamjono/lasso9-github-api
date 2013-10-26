[
	sys_listunboundmethods !>> 'br' ? define br => '<br>'
	define br => '<br>'
	sys_listtraits !>> 'github_common' ? 
		include('../../types/github_common.lasso')
	
	sys_listtypes !>> 'github_parent' ? 
		include('../../types/github_parent.lasso')
		
	sys_listtypes !>> 'github_header' ? 
		include('../../types/github_header.lasso')
		
		
	include('../../types/gists/github_gists.lasso')
	

	
	local(obj = github_gists)
	
	/* =======================================================
	Get gists from a specified user
	======================================================= */
	'Get info about a specified users gists'+br
//	#obj->get(-user='fletc3her')
	#obj->list(-user='iamjono')
	// use for troubleshooting
	//#obj->url
	//br
	// output the whole array for debug
	'<pre>'+#obj->objectdata+'</pre>'
	
//	br+'full_name: '+#repos->repos_full_name
	loop(#obj->size) => {^
		br+br+loop_count+': description: '+#obj->description(loop_count)
		with k in #obj->objectdata->first->keys
		where #k != 'description'
		do => {^
			br+'&nbsp;&nbsp;&nbsp;&nbsp;'+#k+': '+#obj->getobjectdata(#k,loop_count)
		^}
	^}

	/* =======================================================
	Get the authenticated user
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
	======================================================= */

	/* =======================================================
	Get repos for an org
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
	======================================================= */
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
//	br
//	br
//	'Headers:'+br
//	#obj->headers
//	br+br
//	'X-RateLimit-Remaining = ' + #obj->headers->'X-RateLimit-Remaining'
	
]