[
	// stores header map, with 
	define github_header => type {
		parent map
		public onCreate(...) => {
			..onCreate(#rest)
		}
			
		public process(h::bytes) => {
			// brad this is where your header process code would go..
			// temp code, not accurate as it misses some that don't contain : or contain more than one :
			local(headers = #h->asString->split('\r\n'))
			with i in #headers do => {
				local(x = #i->split(':'))
				protect => {
					#x->size == 2 && #x->get(1)->size ? ..insert(#x->get(1) = #x->get(2))
				}
			}
		}
		public _unknownTag() => {
			return self->find(method_name->asString)
		}
	}
	


]