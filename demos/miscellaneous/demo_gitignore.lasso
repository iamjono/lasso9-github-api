[
	sys_listunboundmethods !>> 'br' ? define br => '<br>'
	sys_listtraits !>> 'github_common' ? include('../../types/github_common.lasso')
//	sys_listtypes !>> 'github_gitignore' ? 
		include('../../types/miscellaneous/github_gitignore.lasso')
	

	
	local(obj = github_gitignore)
	
	/* =======================================================
	List gitignore templates
	======================================================= */
	'List gitignore templates'+br
	#obj->list
	'<blockquote>'
	with i in #obj->objectdata->find('templates') do => {^
		#i + br
	^}
	'</blockquote>'
	
	/* =======================================================
	Get a gitignore template
	======================================================= */
	'Get a gitignore template (C)'+br
	#obj->get('C')
	'Name: '+#obj->result_name+br
	'Source: '+br+encode_break(#obj->result_source)+br
	
	br
	br
	'Headers:'+br
	#obj->headers
	
]