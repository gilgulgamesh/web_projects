using Dates

HTML_FILE = "pimkossible/private/posts.html"
banner = "Feng Shui of Blog"
TSV_FILE = "pimkossible/private/posts.tsv"
EVIL_TSV_FILE = "pimkossible/private/EVILposts.tsv"

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

using DelimitedFiles, HTMLSanitizer, Hyperscript, URIs #my fork

function addpost!(postbody::String)
    prior = readdlm(TSV_FILE, '\t', String)
    evilprior = readdlm(EVIL_TSV_FILE, '\t', String)
    columns =  size(prior, 1) # including header  does +1 (1 arg is dims)
    row = makerow(postbody, columns)
    row = replace.(row,'+' => ' ') #figure out why this is broken?
    row = unescapeuri.(row)
    if row[2:end] == prior[end, 2:end] || row[2:end] == evilprior[end, 2:end]
        return Response(Plain, "we got it last time babes", status=400)
    end
    saverow(row, makesafe(row))
    updatehtml()
    sendwait()
end

function makerow(postbody::String, columns::Int)
    title, user, content = match(r"Title=(.+)&User=(.+)&Content=(.+)", postbody).captures
    date = cutedate(Dates.now())
    user = uppercase(user[1]) * lowercase(user[2:end])
    postnumber = "#$columns"
    row::Vector = [
        postnumber
        title
        user
        date
        content
    ]
end

function makesafe(row::Vector)
    # upgrade to dompurify
    # consider limiting the limited one more for sanity
    saferow::Vector = [
        sanitize(row[1], whitelist = HTMLSanitizer.LIMITED)
        sanitize(row[2], whitelist = HTMLSanitizer.LIMITED)
        sanitize(row[3], whitelist = HTMLSanitizer.LIMITED)
        sanitize(row[4], whitelist = HTMLSanitizer.LIMITED)
        sanitize(row[5], whitelist = HTMLSanitizer.WHITELIST)
    ]
end


function saverow(row::Vector,  saferow::Vector)
    io1 = open(TSV_FILE,  "a")
    writedlm(io1, permutedims(saferow), '\t')
    close(io1)

    if row != saferow
        println("UNSAFE POST CENSORED")
        io2 = open(EVIL_TSV_FILE,  "a")
        writedlm(io2, permutedims(row), '\t')
        close(io2)
    end
end

@tags html head meta body style h1 h2 h4 span  link
@tags_noescape div article section iframe#can this possible work recursively with stock.. .
function updatehtml()
    data, headerrow  = readdlm(TSV_FILE, '\t', String, header=true)
    allposts = []

    for i in 1:size(data, 1)
        d = reverse(data, dims=1)[i, 1:5]
        push!(allposts, postbox(d))
    end

    w = string(Pretty(docubox(allposts)))
    r = replace(w,
        "<html><html>" => "<html>",

        "</html></html>" => "</html>" )
    write(HTML_FILE, r)
end
#omfg i just want to cat, save, flip save flip cat. file systems are not arrays. good for personal things.

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
        h1(id="banner", banner,
            iframe(id="status",
                src="https://content-edible.org/status.html"; style="height:2.3rem; width: 4ch; border;0px solid; float:inline-end"
            )
        ),
        section(id="posts",
            allposts,
        ),
    ),
)
