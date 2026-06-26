using Dates, DelimitedFiles, Hyperscript #my fork


HTML_FILE = "pimkossible/posts.html"
banner = "Feng Shui of Life Blog"


TSV_FILE = "posts.tsv"
function cutedate(dt)
    typeof(dt) == String && return dt

    a = Dates.format(dt, "p-d-u'yy") # use time of day to get 🌇🏙️🌆 or smn
    b = lowercase(string(a))
    c = replace( b,
        "apr" => "april",
        "jun" => "june",
        "jul" => "july",
        "aug" => "august",
        "sep" => "sept"
    )
end


function addpost!(postbody::String)
    prior = readdlm(TSV_FILE, '\t', AbstractString)
    columns =  size(prior, 1) # 1 is columns, including headers so does +1
    row = makerow(postbody, columns)
    # if row[2:end] == prior[end, 2:end]
    #     return Response(Plain, "we got it last time babes", status=400)
    # end
    saverow(row)
    updatehtml()
    Response(Plain, "yay"; status=200)
end

function makerow(postbody::String, columns::Int)
    title, user, content = match(r"&Title=(.+)&User=(.+)&Content=(.+)", postbody).captures

    date = cutedate(Dates.now())
    postnumber = "#$columns"
    row::Vector{String} = [postnumber; title; user; date; content]
end

function saverow(row)
    io = open(TSV_FILE,  "a")
    writedlm(io, permutedims(row), '\t')
    close(io)
end


@tags html head meta body style h1 h2 h4 span article  link div
@tags_noescape div article section #test test if stock works on section , when article is a string anyway


# syntax: row = ["hi"; "my"; "name"; "is"; "john"]

function updatehtml()
    data, headerrow  = readdlm(TSV_FILE, '\t', String, header=true)
    allposts = []
    for i in 1:size(data, 1)
        d = reverse(data, dims=1)[i, 1:5]
        push!(allposts, postbox(d))
    end
    savehtml(HTML_FILE, Pretty(docubox(allposts)))

    r = replace( read(HTML_FILE, String),
        "<html><html>" => "<html>",
        # """<section id="posts">""" => """<section id="posts">
        # """,
        # "</article>" => """</article>
        # """,
        "</html></html>" => "</html>" )
    io = open(HTML_FILE, "w")
    write(io, r)
    close(io)
    println("good")
end

#omfg i just want to cat, save, flip

const postbox(row) =
    article(id=row[1][2:end], #shoulda kept it without the # but ugh
        h2.heading(
            span(row[1] * " "),
            span.Title(row[2])
        ),
        h4.subheading(
            span.User(row[3]),
            span(" " * cutedate(row[4]))
        ),
        div.Content(row[5])
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
