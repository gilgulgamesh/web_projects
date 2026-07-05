using Dates


banner = "Feng Shui of Blog"
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

    row = replace.(row,'+' => ' ', "&lt;" => '<', "&gt;" => '>') #figure out why this is broken?
    row = unescapeuri.(row)
    if row[2:end] == prior[end, 2:end] || row[2:end] == evilprior[end, 2:end]
        return Response(Plain, "we got it last time babes", status=400)
    end
    saferow = makesafe(row)
    saverow(row, saferow)

    println(" $EVIL_TSV_FILE: \n$row \n $TSV_FILE:\n$saferow  , ")
    updatehtml()
    println("updated $HTML_FILE, sending to $SITE_LOC")
    sendwait()
end

function makerow(postbody::String, columns::Int)

    title, user, content, tags = match(r"Title=(.+)?&User=(.+)&Content=(.+)&Tags=(.+)?", postbody).captures
    isnothing(title) ? title = "" : nothing
    isnothing(tags) ? tags = "" : nothing
    date = cutedate(Dates.now())
    user = uppercase(user[1]) * lowercase(user[2:end])
    postnumber = "#$columns"
    row::Vector = [
        postnumber
        title
        user
        date
        content
        tags
    ]


end

function makesafe(row::Vector)
    # upgrade to dompurify
    # consider limiting the limited one more for sanity
    saferow::Vector = [
        sanitize.(row[1:4], whitelist = HTMLSanitizer.LIMITED)
        sanitize(row[5], whitelist = HTMLSanitizer.WHITELIST)
        sanitize(row[6], whitelist = HTMLSanitizer.LIMITED)
    ]
end

function saverow(row::Vector,  saferow::Vector)
    if row != saferow
        # @show row saferow
        println("UNSAFE POST CENSORED see $EVIL_TSV_FILE \n $row \n $saferow")
        io2 = open(EVIL_TSV_FILE,  "a")
        writedlm(io2, permutedims(row), '\t')
        close(io2)
        saferow[6] =  saferow[6] * " unverified"
        println(saferow)
    end
    io1 = open(TSV_FILE,  "a")
    writedlm(io1, permutedims(saferow), '\t')
    close(io1)
end


const html = m("html")
const head = m("head")
const meta = m("meta")
const body = m("body")
const style = m("style")
const h1 = m("h1")
const h2 = m("h2")
const h4 = m("h4")
const spanlink = m("spanlink")
const article = m("article")
const section = m("section")
const iframe = m("iframe")
const video = m("video")
const a = m("a")
const span = m("span")
const div = m("div")
const sub = m("sub")


const link = m("link")#can this possible work recursively with stock.. .


function updatehtml()
    data, headerrow  = readdlm(TSV_FILE, '\t', String, header=true)
    allposts = []

    for i in 1:size(data, 1)
        d = reverse(data, dims=1)[i, 1:6]
        push!(allposts, postbox(d))
    end

    htmlposts = replace(string(Pretty(docubox(allposts))),
        "<html><html>" => "<html>",

        "</html></html>" => "</html>" )
    write(HTML_FILE, htmlposts)
end
#omfg i just want to cat, save, flip save flip cat. file systems are not arrays. good for personal things.
#format
NUMBER  = 1
TITLE  = 2
USER  = 3
DATE  = 4
CONTENT = 5
TAGS = 6



const postbox(row) =
article(id=row[NUMBER][2:end], #shoulda kept it without the # but ugh
    h2.heading(
        span.Title(row[TITLE])
    ),
    h4.subheading(
        span(" " * cutedate(row[DATE]))
    ),
    div.Content(row[CONTENT]),
    div.bottom(
        span.User('>' * row[USER]),
        span.Tags('>' * row[NUMBER], join(" >" .* split(row[TAGS]))
        ),
    )
)

const docubox(allposts) =
html(
    head(
        meta(charset="UTF-8"),
        link(rel="stylesheet", href="style.css"),
    ),
    body(
        h1(id="banner", banner,
            "&nbsp;&nbsp;&nbsp;",
            a(href="build/post-editor.html", "Post Editor"),
            iframe(id="status",
                src="https://content-edible.org/status.html";
            )

        ),
        section(id="posts",
            allposts,
        ),
    ),
)
