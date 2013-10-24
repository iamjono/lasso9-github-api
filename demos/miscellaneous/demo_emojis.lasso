[
	sys_listunboundmethods !>> 'br' ? define br => '<br>'
	sys_listtraits !>> 'github_common' ? include('../../types/github_common.lasso')
//	sys_listtypes !>> 'github_emojis' ? 
		include('../../types/miscellaneous/github_emojis.lasso')
	

	
	local(obj = github_emojis)
	
	/* =======================================================
	Get emojis
	======================================================= */
	'Get emojis'+br
	#obj->get
	//'objectdata: '+#obj->objectdata	
]
<table>
	<thead>
		<tr>
			<th style="text-align:left">Name</th>
			<th style="text-align:left">Icon</th>
			<th style="text-align:left">URL</th>
		</tr>
	</thead>
	<tbody>
[with i in #obj->objectdata->keys do => {^]
		<tr>
			<td>[#i]</td>
			<td><img src="[#obj->objectdata->find(#i)]"></td>
			<td>[#obj->objectdata->find(#i)]</td>
		</tr>
[^}]
	</tbody>
</table>
[

	

	br
	br
	'Headers:'+br
	#obj->headers
	
]