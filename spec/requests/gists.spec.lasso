// This should let us run this anywhere and still properly import the file
local(path_here) = currentCapture->callsite_file->stripLastComponent
not #path_here->beginsWith('/')? #path_here = io_file_getcwd + '/' + #path_here
not #path_here->endsWith('/')  ? #path_here->append('/')
if(not var_defined('_gh_loaded')) => {
    sourcefile(file(#path_here + `spec_helper.lasso`), -autoCollect=false)->invoke
}


describe(`-> gists`) => {
    it(`Sets _reqObject to a github_gists object and returns a copy of itself`) => {
        local(gh) = github(`public`)->gists

        // If it doesn't return self, #gh will be a void
        expect(::github_gists, #gh->_reqObject->type)
    }
    it(`Allows for listing a specified user's gists`) => {
        local(gists) = github(`public`)->gists->list('bfad')->response

        expect(#gists->objectData->size > 0)
    }
}