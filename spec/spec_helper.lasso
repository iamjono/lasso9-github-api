// This should let us run this anywhere and still properly import the file
local(path_here) = currentCapture->callsite_file->stripLastComponent
not #path_here->beginsWith('/')? #path_here = io_file_getcwd + '/' + #path_here
not #path_here->endsWith('/')  ? #path_here->append('/')
if(not var_defined('_gh_loaded')) => {
    with path in (:
            `../Lasso_HTTP/http_request.lasso`,
            `../Lasso_HTTP/http_response.lasso`,
            `../types/github.lasso`,
            `../types/github_request.lasso`,
            `../types/github_result.lasso`,
            `../types/gists/github_gists.lasso`
        )
    do sourcefile(file(#path_here + #path), -autoCollect=false)->invoke

    define github->_reqObject => .`_reqObject`

    var(_gh_loaded) = true
}