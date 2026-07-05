
conf_path = string(@__DIR__) * "/neocities_config.jl"
default() = include(conf_path)
# default()
include("neocities_config.jl")

function myrun(x)
    println(x)
    run(x; wait=WAIT)
end

# set paths separately from newname.
# root = _root  expanduser(_root)
@tags
function upload(files, newname=nothing; site=SITE)

    if files isa AbstractString
        if isnothing(newname)
            newname = files
        end
        filestring =  ```-F "$newname=@$ROOT$files"```
        # @show filestring typeof(filestring)
    else
        filelist = []
        for i in files
            push!(filelist, `-F `)
            push!(filelist,  `$newname$i=@$ROOT$i`)
        end
        filestring = join(filestring)
    end
    global PASS
    myrun(`curl -u "$site:$PASS" $filestring "https://neocities.org/api/upload"` )
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
