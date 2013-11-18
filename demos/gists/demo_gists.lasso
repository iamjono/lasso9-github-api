[
	/* =======================================================
	Uncomment code below to force reloads
	// This should let us run this anywhere and still properly import the file
		local(path_here) = currentCapture->callsite_file->stripLastComponent
		not #path_here->beginsWith('/')? #path_here = io_file_getcwd + '/' + #path_here
		not #path_here->endsWith('/')  ? #path_here->append('/')
	
		not ::github->isType
			? sourcefile(file(#path_here + `../helpers.lasso`), -autoCollect=false)->invoke
	
		define br => '<br />'
	======================================================= */
	
	
	local(obj)   = github(`public`)
	local(gists) = #obj->gists
	
	/* =======================================================
	Get gists from a specified user
	======================================================= */
	'Get info about a specified users gists'+br
//	#obj->get(-user='fletc3her')
	local(result) = #gists->list('iamjono')->response
	// use for troubleshooting
	//#obj->url
	//br
	// output the whole array for debug
	'<pre>'+#result->objectData+'</pre>'
]