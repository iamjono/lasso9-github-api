// This should let us run this anywhere and still properly import the file
local(path_here) = currentCapture->callsite_file->stripLastComponent
not #path_here->beginsWith('/')? #path_here = io_file_getcwd + '/' + #path_here
not #path_here->endsWith('/')  ? #path_here->append('/')
if(not var_defined('_gh_loaded')) => {
    sourcefile(file(#path_here + `../spec_helper.lasso`), -autoCollect=false)->invoke
}


/*
    It knows how to craft the basics of an http_request for a gist call
    It doesn't know anything about authentication or special headers
*/
describe(::github_gists) => {

    describe(`->list`) => {
        context(`Specifying a user`) => {
            it(`has a URL of /users/:user/gists`) => {
                local(req) = github_gists->list('bfad')

                expect(`/users/bfad/gists`, #req->urlPath)
            }
        }
        context(`No user specified`) => {
            it(`has a URL of /gists`) => {
                local(req) = github_gists->list

                expect(`/gists`     , #req->urlPath)
            }
            it(`has a URL of /gists/public when -public param specified`) => {
                local(req) = github_gists->list(-public)

                expect(`/gists/public`, #req->urlPath)
            }
            it(`has a URL of /gists/starred when -starred param specified`) => {
                local(req) = github_gists->list(-starred)

                expect(`/gists/starred`, #req->urlPath)
            }
        }
    }
}