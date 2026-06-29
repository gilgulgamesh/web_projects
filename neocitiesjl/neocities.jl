
conf_path = string(@__DIR__) * "/neocities_config.jl"
default() = include(conf_path)
default()
# include("neocities_config.jl")



# set paths separately from newname.
# root = _root  expanduser(_root)

function upload(files, newname=nothing; site=SITE)

    if files isa AbstractString
        if isnothing(newname)
            newname = files
        end
        filestring =  ```-F "$newname=@$ROOT/$files"```
        # @show filestring typeof(filestring)
    else
        filelist = []
        for i in files
            push!(filelist, `-F `)
            push!(filelist,  `$newname$i=@$ROOT/$i`)
        end
        filestring = join(filestring)
    end
    global SHELL, PASS, ROOT, WAIT
    run(`$SHELL curl -u "$site:$PASS" $filestring "https://neocities.org/api/upload"`; wait=WAIT)
    return

end

function mkdir(path; site=SITE)
    global SHELL, PASS, WAIT
    run(`$SHELL curl -u "$site:$PASS" -d "path=$path" "https://neocities.org/api/create_directory"`, wait=WAIT)
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
    global SHELL, PASS, WAIT
    run(`$SHELL curl -u "$site:$PASS" $delfiles "https://neocities.org/api/delete"`, wait=WAIT)
    return

end
function ls(path=nothing; site=SITE)
    global SHELL, PASS, WAIT

    if isnothing(path)
        fullpath = ""
    else
        fullpath = "?path=$path"
    end
    run(`curl -u "$site:$PASS" "https://neocities.org/api/list$fullpath"`, wait=WAIT)

end

function info(site=SITE)
    global SHELL, PASS, WAIT

    run(`curl "https://neocities.org/api/info?sitename=$site"`, wait=WAIT)

end
# """
# Note, filepath starts from your directory

# please edit te config file at ~/.julia/whatever/neocities_config.jl
# or set their values for this session

# note
# for ROOT use full path with '/' and no drive name
# use `cmd` or `pwsh` for windows, `` works otherwise
# """
