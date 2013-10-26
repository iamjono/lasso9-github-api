[
	sys_listunboundmethods !>> 'br' ? define br => '<br>'
	define br => '<br>'
	sys_listtraits !>> 'github_common' ? 
		include('../../types/github_common.lasso')
	
	sys_listtypes !>> 'github_parent' ? 
		include('../../types/github_parent.lasso')
		
	sys_listtypes !>> 'github_header' ? 
		include('../../types/github_header.lasso')
		
		
	include('../../types/miscellaneous/github_meta.lasso')
	

	
	local(obj = github_meta)
	
	/* =======================================================
	Github Meta: Hooks
	======================================================= */
	'Github Meta: Hooks'+br
	#obj->hooks
	'<blockquote>'
	with i in #obj->hooks do => {^
		#i + br
	^}
	'</blockquote>'
	
	/* =======================================================
	Github Meta: Git servers at GitHub
	======================================================= */
	br
	'Git servers at GitHub'+br
	#obj->git
	'<blockquote>'
	with i in #obj->git do => {^
		#i + br
	^}
	'</blockquote>'
	
]