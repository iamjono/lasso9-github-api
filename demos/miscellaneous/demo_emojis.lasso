[
//	sys_listtypes !>> 'github_emojis' ? 
		include('../../types/miscellaneous/github_emojis.lasso')
	

	
	local(obj)   = github('public')
	local(emojis) = #obj->emojis
	local(result) = #emojis->get->response
	
	/* =======================================================
	Get emojis
	======================================================= */
	'Get emojis'+br
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
[with i in #result->objectdata->keys do => {^]
		<tr>
			<td>[#i]</td>
			<td><img src="[#result->objectdata->find(#i)]"></td>
			<td>[#result->objectdata->find(#i)]</td>
		</tr>
[^}]
	</tbody>
</table>
