using Dates, DelimitedFiles, Hyperscript #my fork


HTML_FILE = "pimkossible/posts.html"
banner = "Feng Shui of Life Blog"


TSV_FILE = "posts.csv"
function cutedate(dt)
    typeof(dt) == String && return dt

    a = Dates.format(dt, "p-d-u'yy") # use time of day to get 🌇🏙️🌆 or smn
    b = lowercase(string(a))
    c = replace( b,
        "apr" => "april",
        "jun" => "`june",
        "jul" => "july",
        "aug" => "august",
        "sep" => "sept"
    )
end


function addpost!(postbody::String)
    prior = readdlm(TSV_FILE, '\t', AbstractString)
    columns =  size(prior, 1) # 1 is columns, including headers so does +1
    row = makerow(postbody, columns)

    @show row[2:end] == prior[end, 2:end]
    if row[2:end] == prior[end, 2:end]
        return Response(Plain, "we got it last time babes", status=400)
    end
    try
        saverow(row)
    catch
        return Response(Plain, "Saving row failed: Try again", status=400)
    end
    Response(Plain, "added")
end

function saverow(row)
    io = open(TSV_FILE,  "a")
    writedlm(io, permutedims(row), '\t')
    close(io)
    Response(Plain, "yay")

end

# syntax: newpost = ["hi" "my" "name" "is" "john"]
function makerow(postbody::String, columns::Int)

    title, user, content = match(r"&Title=(.+)&User=(.+)&Content=(.+)", postbody).captures
    date = cutedate(Dates.now())

    postnumber = "#$columns"

    row::Vector{String} = [postnumber; title; user; date; content]
end


@tags html head meta body style h1 h2 h4 span article section link div
# @tags_noescape div article #test this on stock. if it works i'm ballin.




const postbox(tup) =
    article.post(id="#$(tup[1])",
        h2.title(
            span("#$(tup[1])" * " "),
            span.Title(tup[2])
        ),
        h4.subtitle(
            span.User(tup[3]),
            span(" " * cutedate(tup[4]))
        ),
        div.Content(tup[5])
    )

const docubox(allposts) =
html(
    head(
        meta(charset="UTF-8"),
        link(rel="stylesheet", href="style.css"),
    ),
    body(
        h1(id="banner", banner),
        section(id="posts",
            allposts,
            ),
        ),
    )



# a = []
# for i in length(Posts.posts):-1:1
#      push!(a, postbox(Posts.posts[i]))
# end

# savehtml(output, Pretty(docubox(a)))

# data, headers = readdlm("posts.tsv", '\t' , String, '\n'; header=true)
