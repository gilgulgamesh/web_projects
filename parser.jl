using Dates

using DelimitedFiles, HTMLSanitizer, Hyperscript, URIs #my fork

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
    c
end


function addpost!(postbody::String)
    prior,_ = readdlm(TSV_FILE, '\t', String, header=true)
    evilprior,_ = readdlm(EVIL_TSV_FILE, '\t', String, header=true)
    rowcount =  size(prior, 1)
    row = makerow(postbody, rowcount)
    row = replace.(row, '+' => ' ')
    row = unescapeuri.(row)
    # println("after escape", row)
    row = replace.(row, "&lt;" => '<', "&gt;" => '>', "&amp;" => '&',  ) #enough?
    # println("after replace",row)
    if row[2:end] == prior[end, 2:end] || row[2:end] == evilprior[end, 2:end]
        return Response(Plain, "we got it last time babes", status=400)
    end
    saferow = makesafe(row)
    saverow(row, saferow)

    println(" $EVIL_TSV_FILE: \n$row \n $TSV_FILE:\n$saferow  , ")
    updatehtml(TSV_FILE)
    println("updated $HTML_FILE, sending to $SITE_LOC")
    sendwait()
end

function makerow(postbody::String, rowcount::Int)
    title, user, content, tags = match(r"Title=(.+)?&User=(.+)&Content=(.+)&Tags=(.+)?", postbody).captures
    isnothing(title) ? title = "" : nothing
    isnothing(tags) ? tags = "" : nothing
    date = cutedate(Dates.now())
    user = uppercase(user[1]) * lowercase(user[2:end])
    postnumber = "#$(rowcount + 1)"
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
const at(x) = a(x, href="t/$x")
const span = m("span")
const div = m("div")
const sub = m("sub")


const link = m("link")#can this possible work recursively with stock.. .


function updatehtml(infile)
    rows,_  = readdlm(infile, '\t', String, header=true)
    allposts = []

    for i in 1:size(rows, 1)
        d = reverse(rows, dims=1)[i, 1:6]
        push!(allposts, postbox(d))
    end

    htmlposts = replace(string(Pretty(docubox(allposts, infile))),
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
article(id=row[NUMBER][2:end], class=row[USER], #removes the #
    h2.heading(
        span.Title(row[TITLE])
    ),
    h4.subheading(
        span(" " * cutedate(row[DATE]))
    ),
    div.Content(row[CONTENT]),
    div.bottom(
        a.User(row[USER], href="u/$(row[USER])"),
        span.Tags(at(row[NUMBER]), at.(split(row[TAGS]))
        ),
    )
)

const docubox(allposts, infile) =
html(
    head(
        meta(charset="UTF-8"),
        link(rel="stylesheet", href="style.css"),
        style(makecss(infile))
    ),
    body(
        div(id="banner",
            h1(banner),
            h1(a(href="build/post-editor.html", "Post Editor")),
            div(id="status",
                h1("online?"),
                iframe(src="https://content-edible.org/status.html";)
            ),
        ),
        section(id="posts",
            allposts,
        ),
    ),
)
