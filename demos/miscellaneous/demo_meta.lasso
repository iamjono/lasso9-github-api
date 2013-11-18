[
	include('../../types/miscellaneous/github_meta.lasso')
	

	
	local(obj)   = github('public')
	local(meta) = #obj->meta
	local(result) = #meta->get->response

	/* =======================================================
	Github Meta: Hooks
	======================================================= */
	'Github Meta: Hooks'+br
	#result->hooks
	'<blockquote>'
	with i in #result->hooks do => {^
		#i + br
	^}
	'</blockquote>'
	
	/* =======================================================
	Github Meta: Git servers at GitHub
	======================================================= */
	br
	'Git servers at GitHub'+br
	#result->git
	'<blockquote>'
	with i in #result->git do => {^
		#i + br
	^}
	'</blockquote>'
	
]