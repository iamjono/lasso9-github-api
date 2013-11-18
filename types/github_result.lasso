define github_result => type {
    data
        private response::http_response,
        private objectData

    // Basic Getters
    public
        response   => .`response`,
        objectData => .`objectData`

    public onCreate(response::http_response) => {
        .response   = #response
        #response->bodyString->size ? .objectData = json_deserialize(#response->bodyString)
    }

    public headers => .response->headers
    
	public size() => { return .objectdata->size }
			
	// returns a formatted name/value pair for the properties
	// useful for debug
	public getobjectdatalist() => {
		local(out = string)
		with e in .objectdata->keys do => {
			#out->append(#e+': '+.objectdata->find(#e)+br)
		}
		return #out
	}
	// returns the properties available
	public getobjectdatakeys() => {
		local(a = array)
		with k in .objectdata->keys do => { #a->insert(#a) }
		return #a 
	}
	 
	// returns the data for the requested property
	public getobjectdata(in,num::integer=1) => {
		.objectdata->isA(::array) ? return .objectdata->get(#num)->find(#in)
		return .objectdata->find(#in)
	}

   	   	// allows lookups by property directly
	public _unknownTag(...) => {
		local(n = method_name->asString)
//		#n->removeLeading(.prefix)
		local(num = 1)
		if(#rest->isNotA(::void)) => {
			protect => {
				#num = #rest->first
			}	
		}
		return .getobjectdata(#n,#num)
	}

}