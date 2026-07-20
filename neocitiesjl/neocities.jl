
conf_path = string(@__DIR__) * "/neocities_config.jl"
default() = include(conf_path)
# default()
include("neocities_config.jl")

function myrun(x)
    println(x)
    run(x;wait=WAIT)
end

# set paths separately from newfiles.
# root = _root  expanduser(_root)

function upload(files::AbstractString, newfiles=nothing; site=SITE, path="")
    global PASS
    if isnothing(newfiles)
        newfiles = files
    end
    filestring =  ```-F "$path$newfiles=@$ROOT$files"```
    myrun(`curl -u "$site:$PASS" $filestring "https://neocities.org/api/upload"` )
end


function upload(files, newfiles=nothing; site=SITE, path="")
    filelist = []
    global PASS
    if files isa AbstractArray
        for f in files
            push!(filelist, "-F")
            push!(filelist, "$path=@$ROOT$f")
        end
    elseif files isa Dict
        for k in keys(files)
            v = files[k]
            push!(filelist, "-F")
            push!(filelist, "$path$v=@$ROOT$k")
        end
    end
    myrun(`curl -u "$site:$PASS" $filelist "https://neocities.org/api/upload"` )
    return
end

function mkdir(path; site=SITE)
    global PASS
    myrun(`curl -u "$site:$PASS" -d "path=$path" "https://neocities.org/api/create_directory"` )
    return

end

function rm(files, prefix=nothing; site=SITE)
    delfiles = []
    if files isa AbstractString
        delfiles = ["-d",""" "filenames[]=$prefix$files" """]
    else
        for i in files
            push!(delfiles, "-d")
            push!(delfiles, """ "filenames[]=$prefix$i" """)
        end
    end
    global PASS
    myrun(`curl -u "$site:$PASS" $delfiles "https://neocities.org/api/delete"` )
    return

end
function ls(path=nothing; site=SITE)
    global PASS

    if isnothing(path)
        fullpath = ""
    else
        fullpath = "?path=$path"
    end
    myrun(`curl -u "$site:$PASS" "https://neocities.org/api/list$fullpath"`)

end

function info(site=SITE)
    myrun(`curl "https://neocities.org/api/info?sitename=$site"` )
end
# """
# Note, filepath starts from your directory

# please edit te config file at ~/.julia/whatever/neocities_config.jl
# or set their values for this session

# note
# for ROOT use full path with '/' and no drive name
# use `cmd` or `pwsh` for windows, `` works otherwise
# """
