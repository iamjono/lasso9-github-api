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

	
]