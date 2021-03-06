[
define github_common => trait {
	require
		prefix, u, p, objectdata
		
	// the following methods (.username, .password and .token) help make .u and .p write only
	provide username(u::string) => { #u->size ? .u = #u }
	provide password(p::string) => { #p->size ? .p = #p }
	provide token(u::string) => {
		if(#u->size) => {
			.u = #u 
			.p = 'x-oauth-basic'
		}
	}
	provide size() => { return .objectdata->size }
			
	// returns a formatted name/value pair for the properties
	// useful for debug
	provide getobjectdatalist() => {
		local(out = string)
		with e in .objectdata->keys do => {
			#out->append(#e+': '+.objectdata->find(#e)+br)
		}
		return #out
	}
	// returns the properties available
	provide getobjectdatakeys() => {
		local(a = array)
		with k in .objectdata->keys do => {
			#a->insert(.prefix+#a)
		}
		return #a 
	}
	 
	// returns the data for the requested property
	provide getobjectdata(in,num::integer=1) => {
		.objectdata->isA(::array) ? return .objectdata->get(#num)->find(#in)
		return .objectdata->find(#in)
	}
	 
	// allows lookups by property directly
	provide _unknownTag(...) => {
		local(n = method_name->asString)
		#n->removeLeading(.prefix)
		local(num = 1)
		if(#rest->isNotA(::void)) => {
			protect => {
				#num = #rest->first
			}	
		}
		return .getobjectdata(#n,#num)
	}

}
]